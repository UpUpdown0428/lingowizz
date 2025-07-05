// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocabularyItem _$VocabularyItemFromJson(Map<String, dynamic> json) =>
    VocabularyItem(
      id: json['id'] as int?,
      word: json['word'] as String,
      definition: json['definition'] as String,
      exampleSentence: json['example_sentence'] as String?,
      imagePath: json['image_path'] as String?,
      segmentedImagePath: json['segmented_image_path'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$VocabularyItemToJson(VocabularyItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'definition': instance.definition,
      'example_sentence': instance.exampleSentence,
      'image_path': instance.imagePath,
      'segmented_image_path': instance.segmentedImagePath,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

