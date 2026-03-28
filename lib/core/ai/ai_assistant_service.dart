import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/api_keys.dart';

/// AI Chat message representation
class AiMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  AiMessage({required this.content, required this.isUser, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

/// AI Assistant Service using Groq API (llama-3.3-70b)
class AiAssistantService {
  static const String _groqApiUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String _groqApiKey = ApiKeys.groqApiKey;
  // Updated to latest available model — llama-3.3-70b-versatile may be
  // unavailable on new API keys. Use llama-3.1-8b-instant as fallback.
  static const String _model = 'llama-3.1-8b-instant';

  // Conversation history (role: system/user/assistant)
  final List<Map<String, String>> _history = [];
  late final Dio _dio;

  // Singleton
  static final AiAssistantService _instance = AiAssistantService._internal();
  factory AiAssistantService() => _instance;

  AiAssistantService._internal() {
    _dio = Dio(
      BaseOptions(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_groqApiKey',
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    _resetHistory();
  }

  void _resetHistory() {
    _history.clear();
    _history.add({'role': 'system', 'content': AppConstants.aiSystemPrompt});
  }

  /// Start a new conversation session
  void startNewSession() => _resetHistory();

  /// Send a message and get AI response
  Future<String> sendMessage(String userMessage) async {
    try {
      _history.add({'role': 'user', 'content': userMessage});

      final response = await _dio.post(
        _groqApiUrl,
        data: {
          'model': _model,
          'messages': _history,
          'temperature': 0.7,
          'max_tokens': 512,
        },
      );

      final content =
          response.data['choices'][0]['message']['content'] as String?;
      final reply =
          content?.trim() ?? 'Жауап алу мүмкін болмады. Қайталап көріңіз.';

      // Save assistant reply to history for context
      _history.add({'role': 'assistant', 'content': reply});

      return reply;
    } on DioException catch (e) {
      debugPrint('🤖 Groq API ERROR: ${e.response?.data ?? e.message}');
      return _handleDioError(e);
    } catch (e) {
      debugPrint('🤖 AiAssistantService unexpected ERROR: $e');
      return 'AI уақытша қолжетімсіз. Кейінірек қайталаңыз.';
    }
  }

  String _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final errorBody = e.response?.data?.toString().toLowerCase() ?? '';

    if (statusCode == 401) {
      return 'Авторизация қатесі. Groq API кілтін тексеріңіз.';
    } else if (statusCode == 429 ||
        errorBody.contains('quota') ||
        errorBody.contains('rate')) {
      return 'AI уақытша толып жатыр. Бір минуттан кейін қайталаңыз.';
    } else if (statusCode == 400) {
      return 'AI-ға қате сұраным. Басқаша сұрап көріңіз.';
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Күту уақыты аяқталды. Интернет байланысыңызды тексеріңіз.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'Интернет байланысы жоқ. Желіні тексеріңіз.';
    }
    return 'AI уақытша қолжетімсіз. Кейінірек қайталаңыз.';
  }

  /// Get service recommendation based on user needs
  Future<String> getServiceRecommendation({
    required String userNeed,
    required List<String> availableCategories,
  }) async {
    final prompt =
        '''
Based on the following user need, recommend the most suitable service category from the list.
User need: "$userNeed"
Available categories: ${availableCategories.join(', ')}
Respond with only the category name and a brief 1-sentence explanation.
''';
    return await sendMessage(prompt);
  }

  /// Get order status guidance
  Future<String> getOrderGuidance(
    String orderStatus,
    String serviceName,
  ) async {
    final prompt =
        '''
A user has an order for "$serviceName" with status "$orderStatus". 
Provide a brief, helpful message about what this status means and what they should expect next.
''';
    return await sendMessage(prompt);
  }

  /// Proactive suggestion for workers
  Future<String> getWorkerSuggestion({
    required int completedOrders,
    required double rating,
    required double totalIncome,
  }) async {
    final prompt =
        '''
A service provider has:
- Completed orders: $completedOrders
- Rating: $rating/5.0
- Total income: \$$totalIncome
Provide 2 short, actionable recommendations to improve their performance and income.
''';
    return await sendMessage(prompt);
  }

  /// Technical support answer
  Future<String> getTechnicalSupport(String issue) async {
    final prompt =
        '''
User is experiencing this issue with the Usta App: "$issue"
Provide a clear step-by-step solution. If this cannot be resolved via app, instruct them to email support@ustaapp.com.
''';
    return await sendMessage(prompt);
  }
}
