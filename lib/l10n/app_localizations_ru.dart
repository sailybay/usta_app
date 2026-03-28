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

  @override
  String get langKk => 'Казахский';

  @override
  String get langRu => 'Русский';

  @override
  String get langEn => 'Английский';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get createOrderTitle => 'Создать заказ';

  @override
  String get createOrderSchedule => 'Расписание';

  @override
  String get createOrderDate => 'Дата';

  @override
  String get createOrderTime => 'Время';

  @override
  String get createOrderLocation => 'Местоположение';

  @override
  String get createOrderAddressHint => 'Введите адрес';

  @override
  String get createOrderPickOnMap => 'Выбрать на карте';

  @override
  String get createOrderNotes => 'Заметки (необязательно)';

  @override
  String get createOrderNotesHint => 'Особые требования...';

  @override
  String get createOrderPayment => 'Способ оплаты';

  @override
  String get createOrderServiceFee => 'Комиссия (5%)';

  @override
  String get createOrderTotal => 'Итого';

  @override
  String get createOrderConfirm => 'Подтвердить заказ';

  @override
  String get createOrderSuccess => 'Заказ размещён! 🎉';

  @override
  String get createOrderServicePrice => 'Стоимость услуги';

  @override
  String get createOrderVia => 'от';

  @override
  String get workerDashboardTitle => 'Панель мастера';

  @override
  String workerGreeting(String name) {
    return 'Привет, $name! 👋';
  }

  @override
  String get workerOverview => 'Обзор результатов работы';

  @override
  String get workerTotalIncome => 'Общий доход';

  @override
  String get workerCompleted => 'Завершено';

  @override
  String get workerPendingOrders => 'Ожидающие заказы';

  @override
  String get workerNoPending => 'Ожидающих заказов нет 🎉';

  @override
  String get workerAccept => 'Принять';

  @override
  String get workerView => 'Просмотр';

  @override
  String get workerIncomeChart => 'Обзор дохода';

  @override
  String get workerAiSuggestion => 'Рекомендация AI';

  @override
  String get workerAskAi => 'Спросить AI →';

  @override
  String get workerStartWork => 'Начать работу';

  @override
  String get workerCompleteOrder => 'Завершить заказ';

  @override
  String get workerRejectOrder => 'Отклонить';

  @override
  String get registerTitle => 'Создать аккаунт ✨';

  @override
  String get registerSubtitle => 'Присоединяйтесь к Usta App';

  @override
  String get registerClientRole => 'Клиент';

  @override
  String get registerWorkerRole => 'Мастер';

  @override
  String get registerFullName => 'Полное имя';

  @override
  String get registerFullNameHint => 'Азамат Нурланов';

  @override
  String get registerNameRequired => 'Имя обязательно';

  @override
  String get registerPhone => 'Номер телефона';

  @override
  String get registerPhoneHint => '+7 777 000 0000';

  @override
  String get registerPhoneRequired => 'Телефон обязателен';

  @override
  String get registerCreateAccount => 'Создать аккаунт';

  @override
  String get registerHaveAccount => 'Уже есть аккаунт? ';

  @override
  String get registerSignIn => 'Войти';

  @override
  String get loginTitle => 'С возвращением! 👋';

  @override
  String get loginSubtitle => 'Войдите для продолжения';

  @override
  String get loginForgotPassword => 'Забыли пароль?';

  @override
  String get loginResetPassword => 'Сброс пароля';

  @override
  String get loginEnterEmail => 'Введите вашу электронную почту';

  @override
  String get loginSendLink => 'Отправить ссылку';

  @override
  String get loginResetSent => 'Ссылка для сброса пароля отправлена!';

  @override
  String get loginNoAccount => 'Нет аккаунта? ';

  @override
  String get loginRegister => 'Зарегистрироваться';

  @override
  String get orderDetailTitle => 'Детали заказа';

  @override
  String get orderStatusLabel => 'Статус заказа';

  @override
  String get orderServiceDetails => 'Детали услуги';

  @override
  String get orderService => 'Услуга';

  @override
  String get orderCategory => 'Категория';

  @override
  String get orderProvider => 'Исполнитель';

  @override
  String get orderAmount => 'Сумма';

  @override
  String get orderAddress => 'Адрес';

  @override
  String get orderNotes => 'Заметки';

  @override
  String get orderScheduleTitle => 'Расписание';

  @override
  String get orderTimelineTitle => 'Хронология заказа';

  @override
  String get orderPlaced => 'Заказ размещён';

  @override
  String get orderAccepted => 'Принят';

  @override
  String get orderInProgress => 'Выполняется';

  @override
  String get orderCompleted => 'Завершён';

  @override
  String get orderChatWithProvider => 'Чат с исполнителем';

  @override
  String get orderLeaveReviewBtn => 'Оставить отзыв';

  @override
  String get orderCancelBtn => 'Отменить заказ';

  @override
  String get orderCancelTitle => 'Отменить заказ';

  @override
  String get orderCancelReasonHint => 'Причина отмены';

  @override
  String get orderBack => 'Назад';

  @override
  String get orderWriteReview => 'Напишите отзыв...';

  @override
  String get orderRateTitle => 'Оцените опыт';

  @override
  String get orderSubmitReviewBtn => 'Отправить отзыв';

  @override
  String get orderAskAi => 'Спросить AI';

  @override
  String get ordersMyOrders => 'Мои заказы';

  @override
  String get ordersActive => 'Активные';

  @override
  String get ordersCompleted => 'Завершённые';

  @override
  String get ordersCancelled => 'Отменённые';

  @override
  String get ordersNoOrders => 'Заказов нет';

  @override
  String get ordersMadeBy => 'от';
}
