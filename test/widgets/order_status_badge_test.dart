import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:usta_app/domain/entities/order_entity.dart';
import 'package:usta_app/presentation/widgets/order_status_badge.dart';
import 'package:usta_app/l10n/app_localizations.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('kk'), // Kazakh is default
        Locale('ru'),
      ],
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('OrderStatusBadge Widget Tests', () {
    testWidgets('renders pending status correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const OrderStatusBadge(status: OrderStatus.pending),
        ),
      );
      await tester.pumpAndSettle();

      final textFinder = find.byType(Text);
      expect(textFinder, findsOneWidget);
    });

    testWidgets('renders completed status correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const OrderStatusBadge(status: OrderStatus.completed),
        ),
      );
      await tester.pumpAndSettle();

      final textFinder = find.byType(Text);
      expect(textFinder, findsOneWidget);
    });

    testWidgets('respects isDark parameter', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const OrderStatusBadge(status: OrderStatus.accepted, isDark: true),
        ),
      );
      await tester.pumpAndSettle();

      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      // Expected decoration logic:
      // color is white with alpha 0.2 if isDark is true.
      expect(decoration.color?.a, closeTo(0.2, 0.01));
    });
  });
}
