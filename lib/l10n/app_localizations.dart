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
