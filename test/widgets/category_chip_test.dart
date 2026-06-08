import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usta_app/core/theme/app_colors.dart';
import 'package:usta_app/presentation/widgets/category_chip.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('CategoryChip Widget Tests', () {
    testWidgets('renders label and icon correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          CategoryChip(
            label: 'Cleaning',
            icon: Icons.cleaning_services_rounded,
            color: AppColors.categoryCleaning,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Cleaning'), findsOneWidget);
      expect(find.byIcon(Icons.cleaning_services_rounded), findsOneWidget);
    });

    testWidgets('applies selected styling when isSelected is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(
          CategoryChip(
            label: 'Repair',
            icon: Icons.build_rounded,
            color: AppColors.categoryRepair,
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      final containerFinder = find.byType(AnimatedContainer);
      expect(containerFinder, findsOneWidget);
      final container = tester.widget<AnimatedContainer>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      // Color should match category color when selected
      expect(decoration.color, AppColors.categoryRepair);
    });

    testWidgets('triggers onTap callback when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        buildTestableWidget(
          CategoryChip(
            label: 'Delivery',
            icon: Icons.delivery_dining_rounded,
            color: AppColors.categoryDelivery,
            isSelected: false,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(CategoryChip));
      expect(tapped, isTrue);
    });
  });
}
