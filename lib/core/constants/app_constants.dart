// CORE - App Constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Usta App';
  static const String appVersion = '1.0.0';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String servicesCollection = 'services';
  static const String ordersCollection = 'orders';
  static const String reviewsCollection = 'reviews';
  static const String paymentsCollection = 'payments';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String categoriesCollection = 'categories';

  // User Roles
  static const String roleClient = 'client';
  static const String roleWorker = 'worker';
  static const String roleAdmin = 'admin';

  // Order Statuses
  static const String orderStatusPending = 'pending';
  static const String orderStatusAccepted = 'accepted';
  static const String orderStatusInProgress = 'in_progress';
  static const String orderStatusCompleted = 'completed';
  static const String orderStatusCancelled = 'cancelled';

  // Payment Statuses
  static const String paymentStatusPending = 'pending';
  static const String paymentStatusCompleted = 'completed';
  static const String paymentStatusFailed = 'failed';
  static const String paymentStatusRefunded = 'refunded';

  // Payment Methods
  static const String paymentMethodCard = 'card';
  static const String paymentMethodCash = 'cash';
  static const String paymentMethodWallet = 'wallet';

  // Cache Keys
  static const String cachedUserKey = 'cached_user';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String themeKey = 'app_theme';

  // AI System Prompt
  static const String aiSystemPrompt = '''
You are Usta AI, a smart assistant for the Usta App — a service platform.
Your role is to:
1. Help clients find the best service providers and answer questions about services.
2. Guide users through registration, orders, payments, and cancellations.
3. Provide technical support for app errors.
4. Give analytics-based recommendations to service providers.
5. Escalate complex issues by instructing users to contact human administrators.
Always respond in the user's language. Be helpful, friendly, and concise.
''';
}
