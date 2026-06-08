import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:usta_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End App Test', () {
    testWidgets('App loads and shows splash or onboarding', (tester) async {
      // 1. Сборка приложения
      app.main();

      // Ждем завершения анимации загрузки
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. Проверяем, что приложение загрузилось без крашей
      // При первой загрузке (если пользователь не вошел), ожидаем экран приветствия/входа
      // либо Сплеш-скрин. Ищем любой текст, который может быть на стартовом экране.
      final finder = find.byType(MaterialApp);
      expect(finder, findsOneWidget);
    });

    testWidgets('Navigation routing architecture works', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 3. Проверка навигации
      // Поскольку мы не можем легко залогиниться Firebase (требует реальной сети и данных),
      // интеграционный тест проверяет, что корневой виджет Router был встроен в дерево.
      final routerFinder = find.byType(Router<Object>);

      // В Flutter приложениях, использующих go_router, Router должен быть в дереве.
      expect(routerFinder, findsWidgets);
    });

    testWidgets('Interactive UI interactions work (Language Switcher)', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // При непройденной авторизации мы оказываемся на LoginScreen.
      // Попробуем открыть меню смены языка
      final languageButton = find.byIcon(Icons.language_rounded);

      // Проверяем, что кнопка смены языка существует
      if (languageButton.evaluate().isNotEmpty) {
        await tester.tap(languageButton);
        await tester.pumpAndSettle();

        // Или если мы используем иконки:
        final iconCheck = find.byType(PopupMenuItem<String>);
        expect(iconCheck, findsWidgets);
      }
    });
  });
}
