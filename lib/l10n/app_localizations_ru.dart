// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Ұста Приложение';

  @override
  String get homeGreetingMorning => 'Доброе утро! 👋';

  @override
  String get homeGreetingAfternoon => 'Добрый день! 👋';

  @override
  String get homeGreetingEvening => 'Добрый вечер! 👋';

  @override
  String get homeFindService => 'Найти услугу';

  @override
  String get homeSearchHint => 'Услуги, специалисты...';

  @override
  String get homePopularServices => 'Популярные услуги';

  @override
  String get homeSeeAll => 'Все';

  @override
  String get homeNoServices => 'Услуги не найдены';

  @override
  String get homeSortBy => 'Сортировка';

  @override
  String get homeSortRating => 'Высокий рейтинг';

  @override
  String get homeSortPriceLow => 'Цена: по возрастанию';

  @override
  String get homeSortPriceHigh => 'Цена: по убыванию';

  @override
  String get homeApply => 'Применить';

  @override
  String get catAll => 'Все';

  @override
  String get catCleaning => 'Уборка';

  @override
  String get catRepair => 'Ремонт';

  @override
  String get catDelivery => 'Доставка';

  @override
  String get catTutoring => 'Репетитор';

  @override
  String get catBeauty => 'Красота';

  @override
  String get catPlumbing => 'Сантехника';

  @override
  String get navHome => 'Главная';

  @override
  String get navOrders => 'Заказы';

  @override
  String get navAiHelp => 'AI Помощь';

  @override
  String get navProfile => 'Профиль';

  @override
  String get authWelcomeBack => 'С возвращением! 👋';

  @override
  String get authSignInContinue => 'Войдите для продолжения';

  @override
  String get authEmailLabel => 'Электронная почта';

  @override
  String get authEmailHint => 'email@example.com';

  @override
  String get authEmailRequired => 'Электронная почта обязательна';

  @override
  String get authEmailInvalid => 'Введите корректный email';

  @override
  String get authPasswordLabel => 'Пароль';

  @override
  String get authPasswordHint => '••••••••';

  @override
  String get authPasswordRequired => 'Пароль обязателен';

  @override
  String get authPasswordTooShort => 'Пароль должен быть не менее 6 символов';

  @override
  String get authForgotPassword => 'Забыли пароль?';

  @override
  String get authSignIn => 'Войти';

  @override
  String get authNoAccount => 'Нет аккаунта? ';

  @override
  String get authRegister => 'Зарегистрироваться';

  @override
  String get authResetTitle => 'Сброс пароля';

  @override
  String get authResetSend => 'Отправить ссылку';

  @override
  String get authResetSent => 'Ссылка для сброса пароля отправлена!';

  @override
  String get authCancel => 'Отмена';

  @override
  String get ordersTitle => 'Мои заказы';

  @override
  String get ordersTabActive => 'Активные';

  @override
  String get ordersTabCompleted => 'Завершённые';

  @override
  String get ordersTabCancelled => 'Отменённые';

  @override
  String get ordersEmpty => 'Заказов нет';

  @override
  String get orderStatusPending => 'Ожидание';

  @override
  String get orderStatusAccepted => 'Принят';

  @override
  String get orderStatusInProgress => 'Выполняется';

  @override
  String get orderStatusCompleted => 'Завершён';

  @override
  String get orderStatusCancelled => 'Отменён';

  @override
  String get orderDetails => 'Детали заказа';

  @override
  String get orderChatProvider => 'Чат с исполнителем';

  @override
  String get orderLeaveReview => 'Оставить отзыв';

  @override
  String get orderCancelOrder => 'Отменить заказ';

  @override
  String get orderCancelReason => 'Причина отмены';

  @override
  String get orderRateExperience => 'Оцените опыт';

  @override
  String get orderSubmitReview => 'Отправить отзыв';

  @override
  String get orderReviewSubmitted => 'Отзыв отправлен. Спасибо!';

  @override
  String get orderUpdated => 'Статус заказа обновлён.';

  @override
  String get orderCancelled => 'Заказ отменён.';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileRating => 'Рейтинг';

  @override
  String get profileReviews => 'Отзывы';

  @override
  String get profileRole => 'Роль';

  @override
  String get profileRoleWorker => 'Мастер';

  @override
  String get profileRoleClient => 'Клиент';

  @override
  String get profileSectionAccount => 'Аккаунт';

  @override
  String get profileEditProfile => 'Редактировать профиль';

  @override
  String get profileSavedAddresses => 'Сохранённые адреса';

  @override
  String get profilePaymentMethods => 'Способы оплаты';

  @override
  String get profileSectionWorker => 'Мастер';

  @override
  String get profileDashboard => 'Панель управления';

  @override
  String get profileSchedule => 'Мой график';

  @override
  String get profileSectionSupport => 'Поддержка';

  @override
  String get profileAiAssistant => 'AI Ассистент';

  @override
  String get profileHelp => 'Помощь и FAQ';

  @override
  String get profileTerms => 'Условия и конфиденциальность';

  @override
  String get profileSignOut => 'Выйти';

  @override
  String get serviceDetail => 'Детали услуги';

  @override
  String get serviceProvider => 'Исполнитель';

  @override
  String get serviceAbout => 'Об услуге';

  @override
  String serviceBookNow(String price) {
    return 'Забронировать — $price';
  }

  @override
  String get comingSoon => 'Скоро будет доступно!';

  @override
  String get onboardingTitle1 => 'Найдите надёжных специалистов';

  @override
  String get onboardingSubtitle1 =>
      'Сотни проверенных мастеров по ремонту, уборке, репетиторству и многому другому.';

  @override
  String get onboardingTitle2 => 'Бронируйте за секунды';

  @override
  String get onboardingSubtitle2 =>
      'Планируйте услугу в удобное время и место. Отслеживайте заказ в реальном времени.';

  @override
  String get onboardingTitle3 => 'AI Ассистент';

  @override
  String get onboardingSubtitle3 =>
      'Умный AI проведёт вас от бронирования до оплаты.';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingGetStarted => 'Начать';

  @override
  String get mapTitle => 'Выберите адрес';

  @override
  String get mapConfirm => 'Подтвердить';

  @override
  String get errorGeneric => 'Произошла ошибка. Попробуйте снова.';

  @override
  String get errorNoInternet => 'Нет подключения к интернету.';

  @override
  String get errorRetry => 'Повторить';
}
