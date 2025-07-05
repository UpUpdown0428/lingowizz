import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../utils/app_theme.dart';

class ThemeCard extends StatelessWidget {
  final ConversationTheme theme;
  final VoidCallback onTap;

  const ThemeCard({
    super.key,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with role badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      theme.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getRoleColor(theme.role).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      theme.role,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getRoleColor(theme.role),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                theme.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Background info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getScenarioIcon(theme.scenario),
                      size: 16,
                      color: AppTheme.textLightColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        theme.background,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textLightColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Start conversation button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onTap,
                    icon: const Icon(
                      Icons.chat,
                      size: 16,
                    ),
                    label: const Text('Start Chat'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'chef':
        return const Color(0xFFEF4444); // Red
      case 'nutritionist':
        return const Color(0xFF10B981); // Green
      case 'shopping assistant':
        return const Color(0xFF3B82F6); // Blue
      case 'cultural guide':
        return const Color(0xFF8B5CF6); // Purple
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getScenarioIcon(String scenario) {
    switch (scenario.toLowerCase()) {
      case 'cooking_assistance':
        return Icons.restaurant;
      case 'nutrition_advice':
        return Icons.health_and_safety;
      case 'shopping_planning':
        return Icons.shopping_cart;
      case 'cultural_exploration':
        return Icons.public;
      default:
        return Icons.chat;
    }
  }
}
