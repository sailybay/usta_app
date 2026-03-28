# Usta App — Diploma Project Documentation

**Version:** 1.0.0 | **Platform:** Flutter (iOS & Android)  
**Author:** [Student Name] | **Date:** 2026  

---

## 1. Project Overview

**Usta App** is a full-stack mobile service platform that connects clients with verified service providers (repairmen, cleaners, tutors, delivery workers, etc.). The platform integrates an **AI Assistant powered by Google Gemini** for guidance, recommendations, and technical support.

---

## 2. System Architecture

### MVVM Pattern
```
┌─────────────────────────────────────────────────┐
│                 PRESENTATION (View)              │
│   Screens: Home, Auth, Orders, Chat, Profile    │
│   Widgets: ServiceCard, CategoryChip, etc.      │
├─────────────────────────────────────────────────┤
│               VIEWMODEL (BLoC)                  │
│   AuthBloc, ServiceBloc, OrderBloc, AiBloc     │
├─────────────────────────────────────────────────┤
│            DOMAIN (Use Cases)                   │
│   Order creation, Payment processing,           │
│   AI recommendation logic, Rating calc          │
├─────────────────────────────────────────────────┤
│               DATA LAYER                        │
│   Repositories: Auth, User, Service, Order     │
│   Firebase: Auth, Firestore, Storage, FCM      │
└─────────────────────────────────────────────────┘
```

### Technology Stack
| Layer          | Technology                                |
|----------------|-------------------------------------------|
| Frontend       | Flutter 3.x / Dart                        |
| State Mgmt     | flutter_bloc (BLoC pattern)               |
| Navigation     | go_router (declarative routing)           |
| Backend        | Firebase (Auth, Firestore, Functions)     |
| Database       | Cloud Firestore (NoSQL, real-time)        |
| AI Assistant   | Google Gemini (gemini-1.5-flash)         |
| Notifications  | Firebase Cloud Messaging (FCM)            |
| Maps           | Google Maps Flutter                       |
| Payments       | Stripe (flutter_stripe)                   |
| Fonts          | Google Fonts (Nunito)                     |

---

## 3. ER Diagram (Main Entities)

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│    USERS     │     │   SERVICES   │     │    ORDERS    │
├──────────────┤     ├──────────────┤     ├──────────────┤
│ id (PK)      │─1──>│ workerId(FK) │     │ id (PK)      │
│ name         │     │ id (PK)      │<────│ serviceId(FK)│
│ email        │     │ name         │     │ clientId(FK) │
│ phone        │     │ category     │     │ workerId(FK) │
│ role         │     │ description  │     │ status       │
│ avatarUrl    │     │ price        │     │ amount       │
│ rating       │     │ priceType    │     │ scheduledAt  │
│ reviewCount  │     │ imageUrl     │     │ chatId(FK)   │
│ isVerified   │     │ rating       │     │ createdAt    │
│ fcmToken     │     │ isActive     │     └──────┬───────┘
│ createdAt    │     └──────────────┘            │
└──────┬───────┘                         ┌───────▼───────┐
       │                                 │   PAYMENTS    │
       │   ┌──────────────┐              ├───────────────┤
       └──>│   REVIEWS    │              │ id (PK)       │
           ├──────────────┤              │ orderId (FK)  │
           │ id (PK)      │              │ amount        │
           │ orderId (FK) │              │ status        │
           │ clientId(FK) │              │ method        │
           │ workerId(FK) │              └───────────────┘
           │ rating       │
           │ comment      │    ┌──────────────┐
           │ createdAt    │    │    CHATS     │
           └──────────────┘    ├──────────────┤
                               │ id (PK)      │
                               │ orderId (FK) │
                               │ participants │
                               │ lastMessage  │
                               └──────────────┘
```

---

## 4. Data Flow Diagram

```
Client Device                Firebase Cloud               Worker Device
     │                            │                             │
     │──── Register / Login ────>│                             │
     │<─── JWT Token ────────────│                             │
     │                            │                             │
     │──── Browse Services ─────>│                             │
     │<─── Service List ─────────│                             │
     │                            │                             │
     │──── Create Order ────────>│──── Push Notification ─>   │
     │                            │                             │──── Accept Order
     │<─── Status Update ─────── │<─── Status Update ─────────│
     │                            │                             │
     │◄──── AI Assistant ───────>│◄──── Gemini API             │
     │      (Guidance/Support)    │                             │
     │                            │                             │
     │──── Payment (Stripe) ────>│                             │
     │<─── Confirmation ─────────│──── Worker Income ─────>   │
```

---

## 5. AI Assistant Integration

The **Usta AI** module uses Google Gemini (`gemini-1.5-flash`) with a custom system prompt to:

| Functionality         | Implementation                        |
|-----------------------|---------------------------------------|
| Technical Support     | `getTechnicalSupport(issue)`          |
| Order Guidance        | `getOrderGuidance(status, service)`   |
| Service Recommendation| `getServiceRecommendation(need, cats)`|
| Worker Analytics Tips | `getWorkerSuggestion(orders, rating)` |
| Interactive Chat      | Persistent `ChatSession` with history |

**Use Case Scenarios:**
1. **Client asks:** "How do I cancel my order?" → AI provides step-by-step cancellation guide
2. **Client asks:** "I need someone to fix my sink" → AI recommends 'Plumbing' category
3. **Order status changes** → AI proactively explains what the new status means
4. **Worker opens dashboard** → AI generates income optimization recommendations

---

## 6. Security Best Practices

| Area                 | Implementation                                             |
|----------------------|------------------------------------------------------------|
| Authentication       | Firebase Auth with JWT; tokens auto-refresh               |
| Authorization        | Firestore Security Rules with role-based func helpers     |
| Data Privacy         | Payments processed server-side via Cloud Functions        |
| API Keys             | Gemini API key via `--dart-define` (never in source)     |
| Secure Storage       | `flutter_secure_storage` for sensitive local data        |
| Firebase App Check   | Prevents unauthorized API calls                           |
| Encryption           | Firebase enforces TLS in transit                          |
| Input Validation     | Form validators + Firestore rules enforce data types     |

---

## 7. Project Structure

```
lib/
├── core/
│   ├── ai/
│   │   └── ai_assistant_service.dart    # Gemini AI integration
│   ├── constants/
│   │   └── app_constants.dart           # All constants
│   ├── router/
│   │   └── app_router.dart             # GoRouter setup
│   └── theme/
│       ├── app_colors.dart             # Color palette
│       └── app_theme.dart              # Material 3 theme
├── data/
│   ├── models/                         # Data models
│   │   ├── user_model.dart
│   │   ├── service_model.dart
│   │   ├── order_model.dart
│   │   ├── review_model.dart
│   │   ├── payment_model.dart
│   │   └── chat_model.dart
│   └── repositories/                   # Firebase data access
│       ├── auth_repository.dart
│       ├── user_repository.dart
│       ├── service_repository.dart
│       ├── order_repository.dart
│       └── support_repositories.dart
├── presentation/
│   ├── blocs/                          # BLoC state management
│   │   ├── auth/auth_bloc.dart
│   │   ├── service/service_bloc.dart
│   │   ├── order/order_bloc.dart
│   │   └── ai/ai_bloc.dart
│   ├── screens/                        # UI screens
│   │   ├── onboarding/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── orders/
│   │   ├── chat/
│   │   ├── profile/
│   │   ├── worker/
│   │   └── map/
│   └── widgets/                        # Reusable components
│       ├── gradient_button.dart
│       ├── service_card.dart
│       ├── category_chip.dart
│       ├── order_status_badge.dart
│       ├── star_rating.dart
│       ├── shimmer_loading.dart
│       └── custom_text_field.dart
└── main.dart                           # App entry point
```

---

## 8. Setup Instructions

### Prerequisites
- Flutter SDK ≥ 3.10
- Android Studio / VS Code
- Firebase project with Auth, Firestore, FCM, Storage enabled
- Google Maps API key
- Google Gemini API key

### Steps
1. **Install dependencies:** `flutter pub get`
2. **Configure Firebase:** Place `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in respective directories
3. **Add API keys:**
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=your_key_here
   ```
4. **Add Google Maps key** to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data android:name="com.google.android.geo.API_KEY"
              android:value="YOUR_MAPS_KEY"/>
   ```
5. **Deploy Firestore rules:** `firebase deploy --only firestore:rules`
6. **Run:** `flutter run`

---

## 9. Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Test Coverage Areas
- `AuthBloc`: Registration, login, logout, error mapping
- `OrderBloc`: Order creation, status transitions, reviews
- `ServiceBloc`: Category filter, sort, search
- Repository Unit Tests with mock Firestore

---

*This documentation was generated as part of a diploma-level project demonstrating professional Flutter application development with Firebase backend, MVVM architecture, and AI integration.*
