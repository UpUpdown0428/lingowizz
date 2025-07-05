import 'package:json_annotation/json_annotation.dart';

part 'conversation.g.dart';

@JsonSerializable()
class ConversationTheme {
  final int id;
  final String title;
  final String description;
  final String role;
  final String background;
  final String scenario;

  ConversationTheme({
    required this.id,
    required this.title,
    required this.description,
    required this.role,
    required this.background,
    required this.scenario,
  });

  factory ConversationTheme.fromJson(Map<String, dynamic> json) =>
      _$ConversationThemeFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationThemeToJson(this);
}

@JsonSerializable()
class ConversationSession {
  final int? id;
  final String sessionId;
  final String theme;
  final String? background;
  final String? role;
  final String? imagePath;
  final DateTime? createdAt;
  final List<ConversationMessage>? messages;

  ConversationSession({
    this.id,
    required this.sessionId,
    required this.theme,
    this.background,
    this.role,
    this.imagePath,
    this.createdAt,
    this.messages,
  });

  factory ConversationSession.fromJson(Map<String, dynamic> json) =>
      _$ConversationSessionFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationSessionToJson(this);
}

@JsonSerializable()
class ConversationMessage {
  final int? id;
  final String sessionId;
  final String sender; // 'user' or 'assistant'
  final String message;
  final DateTime? timestamp;

  ConversationMessage({
    this.id,
    required this.sessionId,
    required this.sender,
    required this.message,
    this.timestamp,
  });

  factory ConversationMessage.fromJson(Map<String, dynamic> json) =>
      _$ConversationMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationMessageToJson(this);

  bool get isUser => sender == 'user';
  bool get isAssistant => sender == 'assistant';
}

