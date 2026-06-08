import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usta_app/domain/entities/service_entity.dart';
import 'package:usta_app/l10n/app_localizations.dart';
import 'package:usta_app/presentation/widgets/service_card.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('kk'), Locale('ru')],
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('ServiceCard Widget Tests', () {
    final testService = ServiceEntity(
      id: '1',
      name: 'Установка розеток и люстр',
      description: 'Быстро и качественно',
      category: 'Repair', // Should be properly detected by internal logic
      price: 5000,
      workerId: 'w1',
      workerName: 'Иван Иванов',
      isActive: true,
      createdAt: DateTime(2024),
      rating: 4.8,
    );

    testWidgets('renders service information correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(ServiceCard(service: testService, onTap: () {})),
      );

      // Verify name is rendered
      expect(find.text('Установка розеток и люстр'), findsOneWidget);
      // Verify price (assuming default locale format without specific symbol if not tested)
      expect(find.textContaining('000'), findsOneWidget);
      // Verify rating
      expect(find.text('4.8'), findsOneWidget);
    });

    testWidgets('triggers onTap callback when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        buildTestableWidget(
          ServiceCard(
            service: testService,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(ServiceCard));
      expect(tapped, isTrue);
    });
  });
}
