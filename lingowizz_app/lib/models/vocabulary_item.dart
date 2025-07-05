import 'package:json_annotation/json_annotation.dart';

part 'vocabulary_item.g.dart';

@JsonSerializable()
class VocabularyItem {
  final int? id;
  final String word;
  final String definition;
  final String? exampleSentence;
  final String? imagePath;
  final String? segmentedImagePath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VocabularyItem({
    this.id,
    required this.word,
    required this.definition,
    this.exampleSentence,
    this.imagePath,
    this.segmentedImagePath,
    this.createdAt,
    this.updatedAt,
  });

  factory VocabularyItem.fromJson(Map<String, dynamic> json) =>
      _$VocabularyItemFromJson(json);

  Map<String, dynamic> toJson() => _$VocabularyItemToJson(this);

  VocabularyItem copyWith({
    int? id,
    String? word,
    String? definition,
    String? exampleSentence,
    String? imagePath,
    String? segmentedImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VocabularyItem(
      id: id ?? this.id,
      word: word ?? this.word,
      definition: definition ?? this.definition,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      imagePath: imagePath ?? this.imagePath,
      segmentedImagePath: segmentedImagePath ?? this.segmentedImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

