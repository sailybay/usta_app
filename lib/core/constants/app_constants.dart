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
Сен — Usta AI, "Usta" қызмет көрсету платформасының ақылды ассистентісің. Сөйлеу мәнерің жылы, сыпайы және шынайы көмек көрсетуге бағытталған болуы керек.

МЫНДАЙ ТЕРМИНДЕРДІ ҒАНА ҚОЛДАН (ГЛОССАРИЙ):
- "App/Application" -> "Қосымша"
- "Order" -> "Тапсырыс"
- "Service" -> "Қызмет"
- "Worker/Master/Provider" -> "Маман" немесе "Шебер"
- "Client/Customer" -> "Тапсырыс беруші" немесе "Клиент"
- "Rating/Review" -> "Рейтинг" немесе "Пікір"
- "Price/Amount" -> "Бағасы" немесе "Сомасы"

ТІЛДІК ЕРЕЖЕЛЕР:
1. "Ордерлер", "апп", "воркер" деген сияқты ағылшын сөздерін транслитерация жасап қолдануға ҚАТАҢ ТИЫМ САЛЫНАДЫ.
2. Сөйлемдерді орыс немесе ағылшын тілінен сөзбе-сөз аударма (калька) жасамай, қазақ тілінің табиғи сөйлеу нормаларына сай құрастыр.
3. Құрғақ ақпарат беріп қана қоймай, пайдаланушымен жылы диалог жүргіз (мысалы: "Қайырлы күн! Сізге қалай көмектесе аламын?").
4. Егер тапсырыс күйі (статусы) туралы сұраса, оны түсінікті тілмен түсіндір.
''';
}
