import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('kk'),
    Locale('ru'),
  ];

  /// Application name
  ///
  /// In kk, this message translates to:
  /// **'Ұста Қосымшасы'**
  String get appName;

  /// Morning greeting on home screen
  ///
  /// In kk, this message translates to:
  /// **'Қайырлы таң! 👋'**
  String get homeGreetingMorning;

  /// Afternoon greeting
  ///
  /// In kk, this message translates to:
  /// **'Қайырлы күн! 👋'**
  String get homeGreetingAfternoon;

  /// Evening greeting
  ///
  /// In kk, this message translates to:
  /// **'Қайырлы кеш! 👋'**
  String get homeGreetingEvening;

  /// Subtitle on home screen
  ///
  /// In kk, this message translates to:
  /// **'Қызмет табу'**
  String get homeFindService;

  /// Search bar hint text
  ///
  /// In kk, this message translates to:
  /// **'Қызметтер, мамандар...'**
  String get homeSearchHint;

  /// Section header
  ///
  /// In kk, this message translates to:
  /// **'Танымал қызметтер'**
  String get homePopularServices;

  /// See all button
  ///
  /// In kk, this message translates to:
  /// **'Барлығы'**
  String get homeSeeAll;

  /// Empty state text
  ///
  /// In kk, this message translates to:
  /// **'Қызметтер табылмады'**
  String get homeNoServices;

  /// Sort filter label
  ///
  /// In kk, this message translates to:
  /// **'Сұрыптау'**
  String get homeSortBy;

  /// Sort by rating option
  ///
  /// In kk, this message translates to:
  /// **'Жоғары рейтинг'**
  String get homeSortRating;

  /// Sort price ascending
  ///
  /// In kk, this message translates to:
  /// **'Баға: өсу бойынша'**
  String get homeSortPriceLow;

  /// Sort price descending
  ///
  /// In kk, this message translates to:
  /// **'Баға: кему бойынша'**
  String get homeSortPriceHigh;

  /// Apply filter button
  ///
  /// In kk, this message translates to:
  /// **'Қолдану'**
  String get homeApply;

  /// No description provided for @catAll.
  ///
  /// In kk, this message translates to:
  /// **'Барлығы'**
  String get catAll;

  /// No description provided for @catCleaning.
  ///
  /// In kk, this message translates to:
  /// **'Тазалық'**
  String get catCleaning;

  /// No description provided for @catRepair.
  ///
  /// In kk, this message translates to:
  /// **'Жөндеу'**
  String get catRepair;

  /// No description provided for @catDelivery.
  ///
  /// In kk, this message translates to:
  /// **'Жеткізу'**
  String get catDelivery;

  /// No description provided for @catTutoring.
  ///
  /// In kk, this message translates to:
  /// **'Репетитор'**
  String get catTutoring;

  /// No description provided for @catBeauty.
  ///
  /// In kk, this message translates to:
  /// **'Сұлулық'**
  String get catBeauty;

  /// No description provided for @catPlumbing.
  ///
  /// In kk, this message translates to:
  /// **'Сантехника'**
  String get catPlumbing;

  /// Bottom nav home tab
  ///
  /// In kk, this message translates to:
  /// **'Басты'**
  String get navHome;

  /// Bottom nav orders tab
  ///
  /// In kk, this message translates to:
  /// **'Тапсырыстар'**
  String get navOrders;

  /// Bottom nav AI tab
  ///
  /// In kk, this message translates to:
  /// **'AI Көмек'**
  String get navAiHelp;

  /// Bottom nav profile tab
  ///
  /// In kk, this message translates to:
  /// **'Профиль'**
  String get navProfile;

  /// Login screen heading
  ///
  /// In kk, this message translates to:
  /// **'Қайта оралдыңыз! 👋'**
  String get authWelcomeBack;

  /// Login screen subtitle
  ///
  /// In kk, this message translates to:
  /// **'Жалғастыру үшін кіріңіз'**
  String get authSignInContinue;

  /// Email field label
  ///
  /// In kk, this message translates to:
  /// **'Электрондық пошта'**
  String get authEmailLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In kk, this message translates to:
  /// **'email@example.com'**
  String get authEmailHint;

  /// No description provided for @authEmailRequired.
  ///
  /// In kk, this message translates to:
  /// **'Электрондық пошта қажет'**
  String get authEmailRequired;

  /// No description provided for @authEmailInvalid.
  ///
  /// In kk, this message translates to:
  /// **'Дұрыс электрондық пошта енгізіңіз'**
  String get authEmailInvalid;

  /// Password field label
  ///
  /// In kk, this message translates to:
  /// **'Құпия сөз'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHint.
  ///
  /// In kk, this message translates to:
  /// **'••••••••'**
  String get authPasswordHint;

  /// No description provided for @authPasswordRequired.
  ///
  /// In kk, this message translates to:
  /// **'Құпия сөз қажет'**
  String get authPasswordRequired;

  /// No description provided for @authPasswordTooShort.
  ///
  /// In kk, this message translates to:
  /// **'Құпия сөз кемінде 6 таңба болуы керек'**
  String get authPasswordTooShort;

  /// Forgot password link
  ///
  /// In kk, this message translates to:
  /// **'Құпия сөзді ұмыттыңыз ба?'**
  String get authForgotPassword;

  /// Sign in button
  ///
  /// In kk, this message translates to:
  /// **'Кіру'**
  String get authSignIn;

  /// Register prompt text
  ///
  /// In kk, this message translates to:
  /// **'Аккаунт жоқ па? '**
  String get authNoAccount;

  /// Register link
  ///
  /// In kk, this message translates to:
  /// **'Тіркелу'**
  String get authRegister;

  /// Reset password dialog title
  ///
  /// In kk, this message translates to:
  /// **'Құпия сөзді қалпына келтіру'**
  String get authResetTitle;

  /// Send reset link button
  ///
  /// In kk, this message translates to:
  /// **'Сілтемені жіберу'**
  String get authResetSend;

  /// Confirmation snackbar
  ///
  /// In kk, this message translates to:
  /// **'Құпия сөзді қалпына келтіру сілтемесі жіберілді!'**
  String get authResetSent;

  /// Cancel button
  ///
  /// In kk, this message translates to:
  /// **'Болдырмау'**
  String get authCancel;

  /// Orders screen title
  ///
  /// In kk, this message translates to:
  /// **'Менің тапсырыстарым'**
  String get ordersTitle;

  /// No description provided for @ordersTabActive.
  ///
  /// In kk, this message translates to:
  /// **'Белсенді'**
  String get ordersTabActive;

  /// No description provided for @ordersTabCompleted.
  ///
  /// In kk, this message translates to:
  /// **'Аяқталған'**
  String get ordersTabCompleted;

  /// No description provided for @ordersTabCancelled.
  ///
  /// In kk, this message translates to:
  /// **'Бас тартылған'**
  String get ordersTabCancelled;

  /// No description provided for @ordersEmpty.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырыстар жоқ'**
  String get ordersEmpty;

  /// No description provided for @orderStatusPending.
  ///
  /// In kk, this message translates to:
  /// **'Күтуде'**
  String get orderStatusPending;

  /// No description provided for @orderStatusAccepted.
  ///
  /// In kk, this message translates to:
  /// **'Қабылданды'**
  String get orderStatusAccepted;

  /// No description provided for @orderStatusInProgress.
  ///
  /// In kk, this message translates to:
  /// **'Орындалуда'**
  String get orderStatusInProgress;

  /// No description provided for @orderStatusCompleted.
  ///
  /// In kk, this message translates to:
  /// **'Аяқталды'**
  String get orderStatusCompleted;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In kk, this message translates to:
  /// **'Бас тартылды'**
  String get orderStatusCancelled;

  /// No description provided for @orderDetails.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырыс мәліметтері'**
  String get orderDetails;

  /// No description provided for @orderChatProvider.
  ///
  /// In kk, this message translates to:
  /// **'Мамандармен сөйлесу'**
  String get orderChatProvider;

  /// No description provided for @orderLeaveReview.
  ///
  /// In kk, this message translates to:
  /// **'Пікір қалдыру'**
  String get orderLeaveReview;

  /// No description provided for @orderCancelOrder.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырысты бас тарту'**
  String get orderCancelOrder;

  /// No description provided for @orderCancelReason.
  ///
  /// In kk, this message translates to:
  /// **'Бас тарту себебі'**
  String get orderCancelReason;

  /// No description provided for @orderRateExperience.
  ///
  /// In kk, this message translates to:
  /// **'Тәжірибеңізді бағалаңыз'**
  String get orderRateExperience;

  /// No description provided for @orderSubmitReview.
  ///
  /// In kk, this message translates to:
  /// **'Пікір жіберу'**
  String get orderSubmitReview;

  /// No description provided for @orderReviewSubmitted.
  ///
  /// In kk, this message translates to:
  /// **'Пікір жіберілді. Рақмет!'**
  String get orderReviewSubmitted;

  /// No description provided for @orderUpdated.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырыс күйі жаңартылды.'**
  String get orderUpdated;

  /// No description provided for @orderCancelled.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырыс бас тартылды.'**
  String get orderCancelled;

  /// Profile screen title
  ///
  /// In kk, this message translates to:
  /// **'Профиль'**
  String get profileTitle;

  /// No description provided for @profileRating.
  ///
  /// In kk, this message translates to:
  /// **'Рейтинг'**
  String get profileRating;

  /// No description provided for @profileReviews.
  ///
  /// In kk, this message translates to:
  /// **'Пікірлер'**
  String get profileReviews;

  /// No description provided for @profileRole.
  ///
  /// In kk, this message translates to:
  /// **'Рөл'**
  String get profileRole;

  /// No description provided for @profileRoleWorker.
  ///
  /// In kk, this message translates to:
  /// **'Маман'**
  String get profileRoleWorker;

  /// No description provided for @profileRoleClient.
  ///
  /// In kk, this message translates to:
  /// **'Клиент'**
  String get profileRoleClient;

  /// No description provided for @profileSectionAccount.
  ///
  /// In kk, this message translates to:
  /// **'Аккаунт'**
  String get profileSectionAccount;

  /// No description provided for @profileEditProfile.
  ///
  /// In kk, this message translates to:
  /// **'Профильді өзгерту'**
  String get profileEditProfile;

  /// No description provided for @profileSavedAddresses.
  ///
  /// In kk, this message translates to:
  /// **'Сақталған мекенжайлар'**
  String get profileSavedAddresses;

  /// No description provided for @profilePaymentMethods.
  ///
  /// In kk, this message translates to:
  /// **'Төлем әдістері'**
  String get profilePaymentMethods;

  /// No description provided for @profileSectionWorker.
  ///
  /// In kk, this message translates to:
  /// **'Маман'**
  String get profileSectionWorker;

  /// No description provided for @profileDashboard.
  ///
  /// In kk, this message translates to:
  /// **'Бақылау тақтасы'**
  String get profileDashboard;

  /// No description provided for @profileSchedule.
  ///
  /// In kk, this message translates to:
  /// **'Кестем'**
  String get profileSchedule;

  /// No description provided for @profileSectionSupport.
  ///
  /// In kk, this message translates to:
  /// **'Қолдау'**
  String get profileSectionSupport;

  /// No description provided for @profileAiAssistant.
  ///
  /// In kk, this message translates to:
  /// **'AI Көмекші'**
  String get profileAiAssistant;

  /// No description provided for @profileHelp.
  ///
  /// In kk, this message translates to:
  /// **'Анықтама және сұрақтар'**
  String get profileHelp;

  /// No description provided for @profileTerms.
  ///
  /// In kk, this message translates to:
  /// **'Шарттар және құпиялылық'**
  String get profileTerms;

  /// No description provided for @profileSignOut.
  ///
  /// In kk, this message translates to:
  /// **'Шығу'**
  String get profileSignOut;

  /// No description provided for @serviceDetail.
  ///
  /// In kk, this message translates to:
  /// **'Қызмет мәліметтері'**
  String get serviceDetail;

  /// No description provided for @serviceProvider.
  ///
  /// In kk, this message translates to:
  /// **'Қызмет көрсетуші'**
  String get serviceProvider;

  /// No description provided for @serviceAbout.
  ///
  /// In kk, this message translates to:
  /// **'Қызмет туралы'**
  String get serviceAbout;

  /// No description provided for @serviceBookNow.
  ///
  /// In kk, this message translates to:
  /// **'Брондау — {price}'**
  String serviceBookNow(String price);

  /// Feature coming soon snackbar
  ///
  /// In kk, this message translates to:
  /// **'Жақында қосылады!'**
  String get comingSoon;

  /// No description provided for @onboardingTitle1.
  ///
  /// In kk, this message translates to:
  /// **'Сенімді мамандарды табыңыз'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In kk, this message translates to:
  /// **'Жөндеу, тазалық, репетитор және басқа да тексерілген мамандар.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In kk, this message translates to:
  /// **'Бірнеше секундта брондаңыз'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In kk, this message translates to:
  /// **'Ыңғайлы уақытта және жерде қызметті жоспарлаңыз. Тапсырыңызды нақты уақытта бақылаңыз.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In kk, this message translates to:
  /// **'AI Көмекші'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In kk, this message translates to:
  /// **'Ақылды AI сізді брондаудан төлемге дейін бағыттайды.'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingSkip.
  ///
  /// In kk, this message translates to:
  /// **'Өткізу'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In kk, this message translates to:
  /// **'Келесі'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In kk, this message translates to:
  /// **'Бастау'**
  String get onboardingGetStarted;

  /// No description provided for @mapTitle.
  ///
  /// In kk, this message translates to:
  /// **'Мекенжайды таңдаңыз'**
  String get mapTitle;

  /// No description provided for @mapConfirm.
  ///
  /// In kk, this message translates to:
  /// **'Растау'**
  String get mapConfirm;

  /// No description provided for @errorGeneric.
  ///
  /// In kk, this message translates to:
  /// **'Қате орын алды. Қайталап көріңіз.'**
  String get errorGeneric;

  /// No description provided for @errorNoInternet.
  ///
  /// In kk, this message translates to:
  /// **'Интернет байланысы жоқ.'**
  String get errorNoInternet;

  /// No description provided for @errorRetry.
  ///
  /// In kk, this message translates to:
  /// **'Қайталау'**
  String get errorRetry;

  /// No description provided for @langKk.
  ///
  /// In kk, this message translates to:
  /// **'Қазақша'**
  String get langKk;

  /// No description provided for @langRu.
  ///
  /// In kk, this message translates to:
  /// **'Орысша'**
  String get langRu;

  /// No description provided for @langEn.
  ///
  /// In kk, this message translates to:
  /// **'Ағылшынша'**
  String get langEn;

  /// No description provided for @settingsLanguage.
  ///
  /// In kk, this message translates to:
  /// **'Тіл'**
  String get settingsLanguage;

  /// No description provided for @createOrderTitle.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырыс беру'**
  String get createOrderTitle;

  /// No description provided for @createOrderSchedule.
  ///
  /// In kk, this message translates to:
  /// **'Кесте'**
  String get createOrderSchedule;

  /// No description provided for @createOrderDate.
  ///
  /// In kk, this message translates to:
  /// **'Күн'**
  String get createOrderDate;

  /// No description provided for @createOrderTime.
  ///
  /// In kk, this message translates to:
  /// **'Уақыт'**
  String get createOrderTime;

  /// No description provided for @createOrderLocation.
  ///
  /// In kk, this message translates to:
  /// **'Орналасуы'**
  String get createOrderLocation;

  /// No description provided for @createOrderAddressHint.
  ///
  /// In kk, this message translates to:
  /// **'Мекенжайды енгізіңіз'**
  String get createOrderAddressHint;

  /// No description provided for @createOrderPickOnMap.
  ///
  /// In kk, this message translates to:
  /// **'Картадан таңдау'**
  String get createOrderPickOnMap;

  /// No description provided for @createOrderNotes.
  ///
  /// In kk, this message translates to:
  /// **'Ескертпелер (міндетті емес)'**
  String get createOrderNotes;

  /// No description provided for @createOrderNotesHint.
  ///
  /// In kk, this message translates to:
  /// **'Арнайы талаптар...'**
  String get createOrderNotesHint;

  /// No description provided for @createOrderPayment.
  ///
  /// In kk, this message translates to:
  /// **'Төлем әдісі'**
  String get createOrderPayment;

  /// No description provided for @createOrderServiceFee.
  ///
  /// In kk, this message translates to:
  /// **'Қызмет ақысы (5%)'**
  String get createOrderServiceFee;

  /// No description provided for @createOrderTotal.
  ///
  /// In kk, this message translates to:
  /// **'Жиыны'**
  String get createOrderTotal;

  /// No description provided for @createOrderConfirm.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырысты растау'**
  String get createOrderConfirm;

  /// No description provided for @createOrderSuccess.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырыс орналастырылды! 🎉'**
  String get createOrderSuccess;

  /// No description provided for @createOrderServicePrice.
  ///
  /// In kk, this message translates to:
  /// **'Қызмет бағасы'**
  String get createOrderServicePrice;

  /// No description provided for @createOrderVia.
  ///
  /// In kk, this message translates to:
  /// **'арқылы'**
  String get createOrderVia;

  /// No description provided for @workerDashboardTitle.
  ///
  /// In kk, this message translates to:
  /// **'Маман бақылау тақтасы'**
  String get workerDashboardTitle;

  /// No description provided for @workerGreeting.
  ///
  /// In kk, this message translates to:
  /// **'Сәлем, {name}! 👋'**
  String workerGreeting(String name);

  /// No description provided for @workerOverview.
  ///
  /// In kk, this message translates to:
  /// **'Жұмыс нәтижелеріңіздің шолуы'**
  String get workerOverview;

  /// No description provided for @workerTotalIncome.
  ///
  /// In kk, this message translates to:
  /// **'Жалпы табыс'**
  String get workerTotalIncome;

  /// No description provided for @workerCompleted.
  ///
  /// In kk, this message translates to:
  /// **'Аяқталды'**
  String get workerCompleted;

  /// No description provided for @workerPendingOrders.
  ///
  /// In kk, this message translates to:
  /// **'Күтіп тұрған тапсырыстар'**
  String get workerPendingOrders;

  /// No description provided for @workerNoPending.
  ///
  /// In kk, this message translates to:
  /// **'Күтіп тұрған тапсырыстар жоқ 🎉'**
  String get workerNoPending;

  /// No description provided for @workerAccept.
  ///
  /// In kk, this message translates to:
  /// **'Қабылдау'**
  String get workerAccept;

  /// No description provided for @workerView.
  ///
  /// In kk, this message translates to:
  /// **'Қарау'**
  String get workerView;

  /// No description provided for @workerIncomeChart.
  ///
  /// In kk, this message translates to:
  /// **'Табыс шолуы'**
  String get workerIncomeChart;

  /// No description provided for @workerAiSuggestion.
  ///
  /// In kk, this message translates to:
  /// **'AI Ұсынысы'**
  String get workerAiSuggestion;

  /// No description provided for @workerAskAi.
  ///
  /// In kk, this message translates to:
  /// **'AI-дан кеңес сұрау →'**
  String get workerAskAi;

  /// No description provided for @workerStartWork.
  ///
  /// In kk, this message translates to:
  /// **'Жұмысты бастау'**
  String get workerStartWork;

  /// No description provided for @workerCompleteOrder.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырысты аяқтау'**
  String get workerCompleteOrder;

  /// No description provided for @workerRejectOrder.
  ///
  /// In kk, this message translates to:
  /// **'Бас тарту'**
  String get workerRejectOrder;

  /// No description provided for @registerTitle.
  ///
  /// In kk, this message translates to:
  /// **'Аккаунт жасау ✨'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In kk, this message translates to:
  /// **'Ұста Қосымшасына қосылыңыз'**
  String get registerSubtitle;

  /// No description provided for @registerClientRole.
  ///
  /// In kk, this message translates to:
  /// **'Клиент'**
  String get registerClientRole;

  /// No description provided for @registerWorkerRole.
  ///
  /// In kk, this message translates to:
  /// **'Маман'**
  String get registerWorkerRole;

  /// No description provided for @registerFullName.
  ///
  /// In kk, this message translates to:
  /// **'Толық аты'**
  String get registerFullName;

  /// No description provided for @registerFullNameHint.
  ///
  /// In kk, this message translates to:
  /// **'Азамат Нұрланов'**
  String get registerFullNameHint;

  /// No description provided for @registerNameRequired.
  ///
  /// In kk, this message translates to:
  /// **'Аты қажет'**
  String get registerNameRequired;

  /// No description provided for @registerPhone.
  ///
  /// In kk, this message translates to:
  /// **'Телефон нөмірі'**
  String get registerPhone;

  /// No description provided for @registerPhoneHint.
  ///
  /// In kk, this message translates to:
  /// **'+7 777 000 0000'**
  String get registerPhoneHint;

  /// No description provided for @registerPhoneRequired.
  ///
  /// In kk, this message translates to:
  /// **'Телефон қажет'**
  String get registerPhoneRequired;

  /// No description provided for @registerCreateAccount.
  ///
  /// In kk, this message translates to:
  /// **'Аккаунт жасау'**
  String get registerCreateAccount;

  /// No description provided for @registerHaveAccount.
  ///
  /// In kk, this message translates to:
  /// **'Аккаунт бар ма? '**
  String get registerHaveAccount;

  /// No description provided for @registerSignIn.
  ///
  /// In kk, this message translates to:
  /// **'Кіру'**
  String get registerSignIn;

  /// No description provided for @loginTitle.
  ///
  /// In kk, this message translates to:
  /// **'Қайта оралдыңыз! 👋'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In kk, this message translates to:
  /// **'Жалғастыру үшін кіріңіз'**
  String get loginSubtitle;

  /// No description provided for @loginForgotPassword.
  ///
  /// In kk, this message translates to:
  /// **'Құпия сөзді ұмыттыңыз ба?'**
  String get loginForgotPassword;

  /// No description provided for @loginResetPassword.
  ///
  /// In kk, this message translates to:
  /// **'Құпия сөзді қалпына келтіру'**
  String get loginResetPassword;

  /// No description provided for @loginEnterEmail.
  ///
  /// In kk, this message translates to:
  /// **'Электрондық поштаңызды енгізіңіз'**
  String get loginEnterEmail;

  /// No description provided for @loginSendLink.
  ///
  /// In kk, this message translates to:
  /// **'Сілтемені жіберу'**
  String get loginSendLink;

  /// No description provided for @loginResetSent.
  ///
  /// In kk, this message translates to:
  /// **'Құпия сөзді қалпына келтіру сілтемесі жіберілді!'**
  String get loginResetSent;

  /// No description provided for @loginNoAccount.
  ///
  /// In kk, this message translates to:
  /// **'Аккаунт жоқ па? '**
  String get loginNoAccount;

  /// No description provided for @loginRegister.
  ///
  /// In kk, this message translates to:
  /// **'Тіркелу'**
  String get loginRegister;

  /// No description provided for @orderDetailTitle.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырыс мәліметтері'**
  String get orderDetailTitle;

  /// No description provided for @orderStatusLabel.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырыс күйі'**
  String get orderStatusLabel;

  /// No description provided for @orderServiceDetails.
  ///
  /// In kk, this message translates to:
  /// **'Қызмет мәліметтері'**
  String get orderServiceDetails;

  /// No description provided for @orderService.
  ///
  /// In kk, this message translates to:
  /// **'Қызмет'**
  String get orderService;

  /// No description provided for @orderCategory.
  ///
  /// In kk, this message translates to:
  /// **'Санат'**
  String get orderCategory;

  /// No description provided for @orderProvider.
  ///
  /// In kk, this message translates to:
  /// **'Маман'**
  String get orderProvider;

  /// No description provided for @orderAmount.
  ///
  /// In kk, this message translates to:
  /// **'Сома'**
  String get orderAmount;

  /// No description provided for @orderAddress.
  ///
  /// In kk, this message translates to:
  /// **'Мекенжай'**
  String get orderAddress;

  /// No description provided for @orderNotes.
  ///
  /// In kk, this message translates to:
  /// **'Ескертпелер'**
  String get orderNotes;

  /// No description provided for @orderScheduleTitle.
  ///
  /// In kk, this message translates to:
  /// **'Кесте'**
  String get orderScheduleTitle;

  /// No description provided for @orderTimelineTitle.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырыс уақыт желісі'**
  String get orderTimelineTitle;

  /// No description provided for @orderPlaced.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырыс берілді'**
  String get orderPlaced;

  /// No description provided for @orderAccepted.
  ///
  /// In kk, this message translates to:
  /// **'Қабылданды'**
  String get orderAccepted;

  /// No description provided for @orderInProgress.
  ///
  /// In kk, this message translates to:
  /// **'Орындалуда'**
  String get orderInProgress;

  /// No description provided for @orderCompleted.
  ///
  /// In kk, this message translates to:
  /// **'Аяқталды'**
  String get orderCompleted;

  /// No description provided for @orderChatWithProvider.
  ///
  /// In kk, this message translates to:
  /// **'Мамандармен чат'**
  String get orderChatWithProvider;

  /// No description provided for @orderLeaveReviewBtn.
  ///
  /// In kk, this message translates to:
  /// **'Пікір қалдыру'**
  String get orderLeaveReviewBtn;

  /// No description provided for @orderCancelBtn.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырысты бас тарту'**
  String get orderCancelBtn;

  /// No description provided for @orderCancelTitle.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырысты бас тарту'**
  String get orderCancelTitle;

  /// No description provided for @orderCancelReasonHint.
  ///
  /// In kk, this message translates to:
  /// **'Бас тарту себебі'**
  String get orderCancelReasonHint;

  /// No description provided for @orderBack.
  ///
  /// In kk, this message translates to:
  /// **'Артқа'**
  String get orderBack;

  /// No description provided for @orderWriteReview.
  ///
  /// In kk, this message translates to:
  /// **'Пікіріңізді жазыңыз...'**
  String get orderWriteReview;

  /// No description provided for @orderRateTitle.
  ///
  /// In kk, this message translates to:
  /// **'Тәжірибеңізді бағалаңыз'**
  String get orderRateTitle;

  /// No description provided for @orderSubmitReviewBtn.
  ///
  /// In kk, this message translates to:
  /// **'Пікір жіберу'**
  String get orderSubmitReviewBtn;

  /// No description provided for @orderAskAi.
  ///
  /// In kk, this message translates to:
  /// **'AI-дан сұрау'**
  String get orderAskAi;

  /// No description provided for @ordersMyOrders.
  ///
  /// In kk, this message translates to:
  /// **'Менің тапсырыстарым'**
  String get ordersMyOrders;

  /// No description provided for @ordersActive.
  ///
  /// In kk, this message translates to:
  /// **'Белсенді'**
  String get ordersActive;

  /// No description provided for @ordersCompleted.
  ///
  /// In kk, this message translates to:
  /// **'Аяқталған'**
  String get ordersCompleted;

  /// No description provided for @ordersCancelled.
  ///
  /// In kk, this message translates to:
  /// **'Бас тартылған'**
  String get ordersCancelled;

  /// No description provided for @ordersNoOrders.
  ///
  /// In kk, this message translates to:
  /// **'Тапсырыстар жоқ'**
  String get ordersNoOrders;

  /// No description provided for @ordersMadeBy.
  ///
  /// In kk, this message translates to:
  /// **'арқылы'**
  String get ordersMadeBy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
