# Usta App 🔧

**Дипломный проект** — мобильное приложение на Flutter для связи клиентов с мастерами.  
Основной язык интерфейса: **Казахский (kk)**, дополнительный: Русский (ru).

---

## 🚀 Быстрый старт

### 1. Клонируйте репозиторий
```bash
git clone https://github.com/YOUR_USERNAME/usta_app.git
cd usta_app
```

### 2. Настройте Firebase
1. Создайте проект в [Firebase Console](https://console.firebase.google.com/)
2. Включите **Authentication** (Email/Password) и **Firestore**
3. Скачайте `google-services.json` и поместите в `android/app/`  
   *(шаблон структуры: `android/app/google-services.json.example`)*

### 3. Настройте API ключи
```bash
# Скопируйте шаблон
cp .env.example .env

# Откройте .env и вставьте ваш Groq API ключ
# Получить ключ: https://console.groq.com/
GROQ_API_KEY=gsk_ваш_реальный_ключ
```

### 4. Установите зависимости
```bash
flutter pub get
flutter gen-l10n
```

### 5. Запуск
```bash
# Разработка (с ключами из .env)
flutter run --dart-define-from-file=.env

# Сборка APK
flutter build apk --dart-define-from-file=.env
```

---

## 📁 Структура проекта

```
lib/
  core/
    constants/    # Константы (api_keys.dart — в gitignore!)
    di/           # Dependency Injection
    router/       # GoRouter + Auth Guard
    theme/        # Тема приложения
  data/
    models/       # Firestore модели
    repositories/ # Реализации репозиториев
  domain/
    entities/     # Доменные сущности
    repositories/ # Интерфейсы репозиториев
  l10n/           # Локализации (kk, ru) — сгенерированные файлы
  presentation/
    blocs/        # BLoC (Auth, Service, Order, AI)
    screens/      # Экраны
    widgets/      # Переиспользуемые виджеты
test/
  blocs/          # Unit-тесты (27 тестов)
```

---

## 🔐 Безопасность

| Файл | В Git? | Описание |
|------|--------|----------|
| `.env` | ❌ Нет | Реальные API ключи |
| `.env.example` | ✅ Да | Шаблон (без ключей) |
| `google-services.json` | ❌ Нет | Firebase конфиг |
| `google-services.json.example` | ✅ Да | Шаблон структуры |
| `lib/core/constants/api_keys.dart` | ❌ Нет | Dart-файл с ключами |

---

## 🧪 Тесты

```bash
flutter test test/blocs/
# Результат: 27/27 тестов проходят
```

---

## 🛠 Технологии

- **Flutter** + **Dart**
- **Firebase** (Auth, Firestore, Messaging, Storage)
- **BLoC** — управление состоянием
- **GoRouter** — навигация с Auth Guard
- **flutter_localizations** — Казахский / Русский / Английский
- **OpenStreetMap** через `flutter_map` (без API ключей)
- **Groq API** — AI-ассистент
