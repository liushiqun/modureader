import 'dart:convert';
import 'dart:typed_data';

import 'package:modu_reader/config/shared_preference_provider.dart';
import 'package:modu_reader/l10n/generated/L10n.dart';
import 'package:modu_reader/models/tts_voice.dart';
import 'package:modu_reader/service/tts/tts_service.dart';
import 'package:modu_reader/service/tts/tts_service_provider.dart';
import 'package:modu_reader/service/tts/tts_synthesis_error.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class OpenRouterTtsProvider extends TtsServiceProvider {
  static final OpenRouterTtsProvider _instance = OpenRouterTtsProvider._internal();

  factory OpenRouterTtsProvider() {
    return _instance;
  }

  OpenRouterTtsProvider._internal() : _client = null;

  @visibleForTesting
  OpenRouterTtsProvider.forTesting({required http.Client client})
      : _client = client;

  final http.Client? _client;

  static const String _defaultUrl = 'https://openrouter.ai/api/v1/audio/speech';
  static const String _defaultModel = 'fish-audio/s2.1-pro-free:free';
  static const String _defaultVoice = '5a88883c20a84f378db686ac6b0bba79';
  static const String _builtinApiKey = String.fromEnvironment('OPENROUTER_API_KEY', defaultValue: '');

  @override
  TtsService get service => TtsService.openrouter;

  @override
  String getLabel(BuildContext context) =>
      L10n.of(context).settingsNarrateOpenRouterTts;

  @override
  List<ConfigItem> getConfigItems(BuildContext context) {
    return [
      ConfigItem(
        key: 'tip',
        label: L10n.of(context).translateTip,
        type: ConfigItemType.tip,
        defaultValue: L10n.of(context).settingsNarrateOpenRouterHelpText,
      ),
      ConfigItem(
        key: 'url',
        label: 'Base URL',
        description: L10n.of(context).settingsNarrateOpenRouterUrlDescription,
        type: ConfigItemType.text,
        defaultValue: _defaultUrl,
      ),
      ConfigItem(
        key: 'key',
        label: 'API Key',
        description: L10n.of(context).settingsNarrateOpenRouterKeyDescription,
        type: ConfigItemType.password,
        defaultValue: '',
      ),
      ConfigItem(
        key: 'model',
        label: 'Model',
        description: L10n.of(context).settingsNarrateOpenRouterModelDescription,
        type: ConfigItemType.text,
        defaultValue: _defaultModel,
      ),
      ConfigItem(
        key: 'voice',
        label: 'Voice ID',
        description: L10n.of(context).settingsNarrateOpenRouterVoiceDescription,
        type: ConfigItemType.text,
        defaultValue: _defaultVoice,
      ),
      ConfigItem(
        key: 'instructions',
        label: 'Instructions (optional)',
        description: L10n.of(context).settingsNarrateOpenRouterInstructionsDescription,
        type: ConfigItemType.text,
        defaultValue: '',
      ),
    ];
  }

  @override
  Map<String, dynamic> getConfig() {
    final config = Prefs().getOnlineTtsConfig(serviceId);
    final builtinKey = _builtinApiKey;
    
    if (config.isEmpty) {
      return {
        'url': _defaultUrl,
        'key': builtinKey,
        'model': _defaultModel,
        'voice': _defaultVoice,
        'instructions': '',
        'instructionsEnabled': 'true',
      };
    }
    final userKey = config['key']?.toString().trim();
    final effectiveKey = (userKey == null || userKey.isEmpty) ? builtinKey : userKey;

    return {
      'url': config['url']?.toString().trim().isNotEmpty == true
          ? config['url']?.toString().trim()
          : _defaultUrl,
      'key': effectiveKey,
      'model': config['model']?.toString().trim().isNotEmpty == true
          ? config['model']?.toString().trim()
          : _defaultModel,
      'voice': config['voice']?.toString().trim().isNotEmpty == true
          ? config['voice']?.toString().trim()
          : _defaultVoice,
      'instructions': config['instructions']?.toString() ?? '',
      'instructionsEnabled': config['instructionsEnabled'] ?? 'true',
    };
  }

  @override
  void saveConfig(Map<String, dynamic> config) {
    Prefs().saveOnlineTtsConfig(serviceId, config);
  }

  @override
  Future<Uint8List> speak(
      String text, String? voice, double rate, double pitch) async {
    final config = getConfig();
    final String url = config['url']?.toString().trim() ?? _defaultUrl;
    final String key = config['key']?.toString() ?? builtinKey;
    final String model = config['model']?.toString().trim() ?? _defaultModel;
    final String resolvedVoice = resolveVoice(voice);

    if (key.isEmpty) {
      throw TtsSynthesisError(
          TtsFailureReason.configuration, 'OpenRouter TTS config missing (key)');
    }

    final String instructions = config['instructionsEnabled'] == 'true'
        ? _buildInstructions(config['instructions']?.toString(), pitch)
        : '';

    final response = await (_client?.post ?? http.post)(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://github.com/liushiqun/modureader',
        'X-Title': 'ModuReader',
      },
      body: jsonEncode({
        'model': model,
        'voice': resolvedVoice,
        'input': text,
        if (instructions.isNotEmpty) 'instructions': instructions,
        if (rate.isFinite && rate != 1) 'speed': rate.clamp(0.25, 4.0),
        'response_format': 'mp3',
      }),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw TtsSynthesisError(
        TtsFailureReason.http, 'OpenRouter TTS failed: ${response.statusCode}',
        statusCode: response.statusCode,
        retryAfter:
            TtsSynthesisError.parseRetryAfter(response.headers['retry-after']));
  }

  String _buildInstructions(String? base, double pitch) {
    final buffer = StringBuffer();
    if (base != null && base.trim().isNotEmpty) {
      buffer.writeln(base.trim());
    }
    if (pitch.isFinite && pitch != 1) {
      buffer.writeln(pitch > 1
          ? 'Use a higher pitch, at ${pitch.clamp(0.5, 2.0).toStringAsFixed(2)} times the default pitch. Keep the speaking pace and volume unchanged.'
          : 'Use a lower pitch, at ${pitch.clamp(0.5, 2.0).toStringAsFixed(2)} times the default pitch. Keep the speaking pace and volume unchanged.');
    }
    return buffer.toString();
  }

  @override
  Future<List<TtsVoice>> getVoices() async {
    return const [
      TtsVoice(
          shortName: _defaultVoice,
          name: 'Fish Audio Default',
          locale: 'zh-CN'),
    ];
  }

  @override
  TtsVoice convertVoiceModel(dynamic voiceData) {
    if (voiceData is TtsVoice) return voiceData;
    if (voiceData is Map<String, dynamic>) {
      return TtsVoice.fromMap(voiceData);
    }
    return const TtsVoice(shortName: _defaultVoice, name: 'Fish Audio Default', locale: 'zh-CN');
  }
}
