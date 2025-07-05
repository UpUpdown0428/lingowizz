// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationTheme _$ConversationThemeFromJson(Map<String, dynamic> json) =>
    ConversationTheme(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      role: json['role'] as String,
      background: json['background'] as String,
      scenario: json['scenario'] as String,
    );

Map<String, dynamic> _$ConversationThemeToJson(ConversationTheme instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'role': instance.role,
      'background': instance.background,
      'scenario': instance.scenario,
    };

ConversationSession _$ConversationSessionFromJson(Map<String, dynamic> json) =>
    ConversationSession(
      id: json['id'] as int?,
      sessionId: json['session_id'] as String,
      theme: json['theme'] as String,
      background: json['background'] as String?,
      role: json['role'] as String?,
      imagePath: json['image_path'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => ConversationMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConversationSessionToJson(
        ConversationSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'theme': instance.theme,
      'background': instance.background,
      'role': instance.role,
      'image_path': instance.imagePath,
      'created_at': instance.createdAt?.toIso8601String(),
      'messages': instance.messages,
    };

ConversationMessage _$ConversationMessageFromJson(Map<String, dynamic> json) =>
    ConversationMessage(
      id: json['id'] as int?,
      sessionId: json['session_id'] as String,
      sender: json['sender'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$ConversationMessageToJson(
        ConversationMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'sender': instance.sender,
      'message': instance.message,
      'timestamp': instance.timestamp?.toIso8601String(),
    };

