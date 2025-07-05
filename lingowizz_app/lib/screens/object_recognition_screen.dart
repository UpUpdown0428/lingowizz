import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../services/api_service.dart';
import '../models/vocabulary_item.dart';
import '../utils/app_theme.dart';
import '../widgets/object_card.dart';

class ObjectRecognitionScreen extends StatefulWidget {
  final String imagePath;
  final File imageFile;

  const ObjectRecognitionScreen({
    super.key,
    required this.imagePath,
    required this.imageFile,
  });

  @override
  State<ObjectRecognitionScreen> createState() =>
      _ObjectRecognitionScreenState();
}

class _ObjectRecognitionScreenState extends State<ObjectRecognitionScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _detectedObjects = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);

      // Segment objects in the image
      final result = await apiService.segmentObjects(widget.imagePath);

      if (result['success']) {
        setState(() {
          _detectedObjects = List<Map<String, dynamic>>.from(result['objects']);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to analyze image');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Recognition'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
              ? _buildErrorState()
              : _buildResultsState(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          SizedBox(height: 20),
          Text(
            'Analyzing image...',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Identifying objects and generating vocabulary',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textLightColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 20),
          const Text(
            'Analysis Failed',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _error ?? 'Unknown error occurred',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _error = null;
              });
              _analyzeImage();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsState() {
    return Column(
      children: [
        // Original image
        Container(
          height: 200,
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Results header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                'Detected Objects',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_detectedObjects.length} found',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Objects list
        Expanded(
          child: _detectedObjects.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _detectedObjects.length,
                  itemBuilder: (context, index) {
                    final object = _detectedObjects[index];
                    return ObjectCard(
                      object: object,
                      onAddToVocabulary: () => _addToVocabulary(object),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.textLightColor,
          ),
          SizedBox(height: 20),
          Text(
            'No Objects Detected',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Try taking another photo with clearer objects',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textLightColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addToVocabulary(Map<String, dynamic> object) async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);

      // Generate word information
      final wordInfo = await apiService.generateWordInfo(object['name']);

      if (wordInfo['success']) {
        final wordData = wordInfo['word_info'];

        // Create vocabulary item
        final vocabularyItem = VocabularyItem(
          word: wordData['word'],
          definition: wordData['definition'],
          exampleSentence: wordData['example_sentence'],
          imagePath: widget.imagePath,
          segmentedImagePath: object['segmented_image'],
        );

        // Add to vocabulary
        await apiService.addVocabulary(vocabularyItem);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"${object['name']}" added to vocabulary!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      } else {
        throw Exception('Failed to generate word information');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding to vocabulary: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
