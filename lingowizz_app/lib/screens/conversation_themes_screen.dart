import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../services/api_service.dart';
import '../models/conversation.dart';
import '../utils/app_theme.dart';
import '../widgets/theme_card.dart';

class ConversationThemesScreen extends StatefulWidget {
  final File? imageFile;
  final ConversationTheme? defaultTheme;

  const ConversationThemesScreen({
    super.key,
    this.imageFile,
    this.defaultTheme,
  });

  @override
  State<ConversationThemesScreen> createState() =>
      _ConversationThemesScreenState();
}

class _ConversationThemesScreenState extends State<ConversationThemesScreen> {
  bool _isLoading = true;
  List<ConversationTheme> _themes = [];
  String? _error;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.defaultTheme != null) {
      _themes = [widget.defaultTheme!];
      _isLoading = false;
    } else if (widget.imageFile != null) {
      _analyzeImageAndGenerateThemes();
    }
  }

  Future<void> _analyzeImageAndGenerateThemes() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);

      // Upload image
      final uploadResult = await apiService.uploadImage(widget.imageFile!);
      if (!uploadResult['success']) {
        throw Exception('Failed to upload image');
      }

      _imagePath = uploadResult['filepath'];

      // Understand image
      final understanding = await apiService.understandImage(_imagePath!);
      if (!understanding['success']) {
        throw Exception('Failed to understand image');
      }

      // Generate conversation themes
      final themes = await apiService
          .generateConversationThemes(understanding['understanding']);

      setState(() {
        _themes = themes;
        _isLoading = false;
      });
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
        title: const Text('Choose Conversation Theme'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
              ? _buildErrorState()
              : _buildThemesList(),
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
            'Generating conversation themes based on image content',
            textAlign: TextAlign.center,
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
              _analyzeImageAndGenerateThemes();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemesList() {
    return Column(
      children: [
        // Image preview (if available)
        if (widget.imageFile != null)
          Container(
            height: 150,
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
                widget.imageFile!,
                fit: BoxFit.cover,
              ),
            ),
          ),

        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                'Conversation Themes',
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
                  '${_themes.length} themes',
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

        // Themes list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _themes.length,
            itemBuilder: (context, index) {
              final theme = _themes[index];
              return ThemeCard(
                theme: theme,
                onTap: () => _selectTheme(theme),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectTheme(ConversationTheme theme) async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);

      // Create conversation session
      final session =
          await apiService.createConversationSession(theme, _imagePath);

      // Return to conversation screen with the new session
      if (mounted) {
        Navigator.pop(context, session);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating conversation: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
