// langchain 存根 - 替代所有 langchain 依赖，仅供编译通过
// 实际 AI 功能已禁用，仅保留 TTS 功能

library langchain_stubs;

/// 基础聊天模型接口
abstract class BaseChatModel {
  const BaseChatModel();
  Stream<ChatResult> stream(PromptValue prompt);
  Future<void> close();
}

/// 提示值
class PromptValue {
  final List<ChatMessage> messages;
  const PromptValue(this.messages);
  static PromptValue chat(List<ChatMessage> messages) => PromptValue(messages);
}

/// 聊天结果
class ChatResult {
  final ChatOutput output;
  const ChatResult({required this.output});
}

/// 聊天输出
class ChatOutput {
  final String content;
  final String reasoningContent;
  const ChatOutput({this.content = '', this.reasoningContent = ''});
}

/// 聊天消息基类
abstract class ChatMessage {
  final String content;
  const ChatMessage(this.content);
  String get contentAsString => content;
}

/// 系统消息
class SystemChatMessage extends ChatMessage {
  const SystemChatMessage(super.content);
}

/// 人类消息
class HumanChatMessage extends ChatMessage {
  const HumanChatMessage(super.content);
}

/// AI 消息
class AIChatMessage extends ChatMessage {
  final String reasoningContent;
  final List<ToolCall>? toolCalls;
  AIChatMessage({
    required super.content,
    this.reasoningContent = '',
    this.toolCalls,
  });
}

/// 工具调用
class ToolCall {
  final String name;
  final Map<String, dynamic> arguments;
  final String id;
  const ToolCall({required this.name, required this.arguments, required this.id});
}

/// 提示模板值
abstract class PromptValue {}

/// OpenAI 选项
class ChatOpenAIOptions {
  final String? model;
  final double? temperature;
  final double? topP;
  const ChatOpenAIOptions({this.model, this.temperature, this.topP});
}

/// 聊天流式回调
typedef OnFinished = void Function(bool successful);

/// 语言链管道
class LangchainPipeline {
  final BaseChatModel model;
  final String? systemMessage;
  final List<dynamic> tools;
  const LangchainPipeline({
    required this.model,
    this.systemMessage,
    this.tools = const [],
  });
}

/// 语言链注册表
class LangchainAiRegistry {
  final dynamic ref;
  LangchainAiRegistry(this.ref);

  LangchainPipeline resolve(
    dynamic config, {
    bool useAgent = false,
    Set<String>? allowedToolIds,
  }) {
    return LangchainPipeline(model: _StubModel(), tools: const []);
  }

  LangchainPipeline resolveByProtocol(
    String protocol,
    dynamic config, {
    bool useAgent = false,
    Set<String>? allowedToolIds,
  }) {
    return LangchainPipeline(model: _StubModel(), tools: const []);
  }
}

class _StubModel extends BaseChatModel {
  @override
  Stream<ChatResult> stream(PromptValue prompt) {
    return Stream.value(ChatResult(output: ChatOutput(content: '')));
  }

  @override
  Future<void> close() async {}
}

/// 存根聊天模型
class ChatOpenAI extends BaseChatModel {
  final ChatOpenAIOptions options;
  ChatOpenAI({required this.options});
  @override
  Stream<ChatResult> stream(PromptValue prompt) {
    return Stream.value(ChatResult(output: ChatOutput(content: '')));
  }

  @override
  Future<void> close() async {}
}

/// 提示模板
class ChatPromptTemplate extends PromptValue {
  final List<ChatMessage> messages;
  ChatPromptTemplate(this.messages);
  static PromptValue fromMessages(List<ChatMessage> messages) => PromptValue.chat(messages);
  @override
  List<ChatMessage> get messages => throw UnimplementedError();
}

/// 提示值扩展
extension PromptValueChat on PromptValue {
  static PromptValue chat(List<ChatMessage> messages) => PromptValue(messages);
}

/// 存根
class BaseChatModel {
  const BaseChatModel();
  Stream<ChatResult> stream(PromptValue prompt) => Stream.value(ChatResult(output: ChatOutput()));
  Future<void> close() async {}
}

class PromptValue {
  final List<ChatMessage> messages;
  const PromptValue(this.messages);
  static PromptValue chat(List<ChatMessage> messages) => PromptValue(messages);
}

class ChatResult {
  final ChatOutput output;
  const ChatResult({required this.output});
}

class ChatOutput {
  final String content;
  final String reasoningContent;
  const ChatOutput({this.content = '', this.reasoningContent = ''});
}

/// 基础聊天消息
abstract class BaseChatMessage {
  final String content;
  const BaseChatMessage(this.content);
}

class ChatMessage {
  final String content;
  const ChatMessage(this.content);
  String get contentAsString => content;
}

class SystemChatMessage extends ChatMessage {
  const SystemChatMessage(String content) : super(content);
}

class HumanChatMessage extends ChatMessage {
  const HumanChatMessage(String content) : super(content);
}

class AIChatMessage extends ChatMessage {
  final String reasoningContent;
  final List<ToolCall>? toolCalls;
  AIChatMessage({
    required String content,
    this.reasoningContent = '',
    this.toolCalls,
  }) : super(content);
}

class ToolCall {
  final String name;
  final Map<String, dynamic> arguments;
  final String id;
  const ToolCall({required this.name, required this.arguments, required this.id});
}

/// OpenAI 选项
class ChatOpenAIOptions {
  final String? model;
  final double? temperature;
  final double? topP;
  const ChatOpenAIOptions({this.model, this.temperature, this.topP});
}

class ChatOpenAI {
  final ChatOpenAIOptions options;
  ChatOpenAI({required this.options});
  Stream<ChatResult> stream(PromptValue prompt) => Stream.value(ChatResult(output: ChatOutput()));
  Future<void> close() async {}
}

class ChatOpenAIOptions {
  final String? model;
  final double? temperature;
  final double? topP;
  const ChatOpenAIOptions({this.model, this.temperature, this.topP});
}

class PromptValue {
  final List<ChatMessage> messages;
  const PromptValue(this.messages);
  static PromptValue chat(List<ChatMessage> messages) => PromptValue(messages);
}

class ChatResult {
  final ChatOutput output;
  const ChatResult({required this.output});
}

class ChatOutput {
  final String content;
  final String reasoningContent;
  const ChatOutput({this.content = '', this.reasoningContent = ''});
}

abstract class ChatMessage {
  final String content;
  const ChatMessage(this.content);
  String get contentAsString => content;
}

class SystemChatMessage extends ChatMessage {
  const SystemChatMessage(String content) : super(content);
}

class HumanChatMessage extends ChatMessage {
  const HumanChatMessage(String content) : super(content);
}

class AIChatMessage extends ChatMessage {
  final String reasoningContent;
  final List<ToolCall>? toolCalls;
  AIChatMessage({required String content, this.reasoningContent = '', this.toolCalls}) : super(content);
}

class ToolCall {
  final String name;
  final Map<String, dynamic> arguments;
  final String id;
  const ToolCall({required this.name, required this.arguments, required this.id});
}

class ChatOpenAIOptions {
  final String? model;
  final double? temperature;
  final double? topP;
  const ChatOpenAIOptions({this.model, this.temperature, this.topP});
}

class PromptValue {
  final List<ChatMessage> messages;
  const PromptValue(this.messages);
  static PromptValue chat(List<ChatMessage> messages) => PromptValue(messages);
}

class ChatResult {
  final ChatOutput output;
  const ChatResult({required this.output});
}

class ChatOutput {
  final String content;
  final String reasoningContent;
  const ChatOutput({this.content = '', this.reasoningContent = ''});
}

class ChatMessage {
  final String content;
  const ChatMessage(this.content);
  String get contentAsString => content;
}

class SystemChatMessage extends ChatMessage {
  const SystemChatMessage(String content) : super(content);
}

class HumanChatMessage extends ChatMessage {
  const HumanChatMessage(String content) : super(content);
}

class AIChatMessage extends ChatMessage {
  final String reasoningContent;
  final List<ToolCall>? toolCalls;
  AIChatMessage({required String content, this.reasoningContent = '', this.toolCalls}) : super(content);
}

class ToolCall {
  final String name;
  final Map<String, dynamic> arguments;
  final String id;
  const ToolCall({required this.name, required this.arguments, required this.id});
}

class ChatOpenAIOptions {
  final String? model;
  final double? temperature;
  final double? topP;
  const ChatOpenAIOptions({this.model, this.temperature, this.topP});
}

class ChatOpenAI {
  final ChatOpenAIOptions options;
  ChatOpenAI({required this.options});
  Stream<ChatResult> stream(PromptValue prompt) => Stream.value(ChatResult(output: ChatOutput()));
  Future<void> close() async {}
}

class PromptValue {
  final List<ChatMessage> messages;
  const PromptValue(this.messages);
  static PromptValue chat(List<ChatMessage> messages) => PromptValue(messages);
}

class ChatResult {
  final ChatOutput output;
  const ChatResult({required this.output});
}

class ChatOutput {
  final String content;
  final String reasoningContent;
  const ChatOutput({this.content = '', this.reasoningContent = ''});
}

abstract class ChatMessage {
  final String content;
  const ChatMessage(this.content);
  String get contentAsString => content;
}

class SystemChatMessage extends ChatMessage {
  const SystemChatMessage(String content) : super(content);
}

class HumanChatMessage extends ChatMessage {
  const HumanChatMessage(String content) : super(content);
}

class AIChatMessage extends ChatMessage {
  final String reasoningContent;
  final List<ToolCall>? toolCalls;
  AIChatMessage({required String content, this.reasoningContent = '', this.toolCalls}) : super(content);
}

class ToolCall {
  final String name;
  final Map<String, dynamic> arguments;
  final String id;
  const ToolCall({required this.name, required this.arguments, required this.id});
}

class ChatOpenAIOptions {
  final String? model;
  final double? temperature;
  final double? topP;
  const ChatOpenAIOptions({this.model, this.temperature, this.topP});
}

class ChatOpenAI {
  final ChatOpenAIOptions options;
  ChatOpenAI({required this.options});
  Stream<ChatResult> stream(PromptValue prompt) => Stream.value(ChatResult(output: ChatOutput()));
  Future<void> close() async {}
}

class PromptValue {
  final List<ChatMessage> messages;
  const PromptValue(this.messages);
  static PromptValue chat(List<ChatMessage> messages) => PromptValue(messages);
}

class ChatResult {
  final ChatOutput output;
  const ChatResult({required this.output});
}

class ChatOutput {
  final String content;
  final String reasoningContent;
  const ChatOutput({this.content = '', this.reasoningContent = ''});
}

abstract class ChatMessage {
  final String content;
  const ChatMessage(this.content);
  String get contentAsString => content;
}

class SystemChatMessage extends ChatMessage {
  const SystemChatMessage(String content) : super(content);
}

class HumanChatMessage extends ChatMessage {
  const HumanChatMessage(String content) : super(content);
}

class AIChatMessage extends ChatMessage {
  final String reasoningContent;
  final List<ToolCall>? toolCalls;
  AIChatMessage({required String content, this.reasoningContent = '', this.toolCalls}) : super(content);
}

class ToolCall {
  final String name;
  final Map<String, dynamic> arguments;
  final String id;
  const ToolCall({required this.name, required this.arguments, required this.id});
}