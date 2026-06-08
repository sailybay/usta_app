import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usta_app/l10n/app_localizations.dart';
import 'package:usta_app/presentation/blocs/service/service_bloc.dart';
import 'package:usta_app/presentation/screens/home/home_screen.dart';
import 'package:usta_app/presentation/widgets/category_chip.dart';

// ─── Mocks ────────────────────────────────────────────────────────────────────
class MockServiceBloc extends MockBloc<ServiceEvent, ServiceState>
    implements ServiceBloc {}

class FakeServiceEvent extends Fake implements ServiceEvent {}

class FakeServiceState extends Fake implements ServiceState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeServiceEvent());
    registerFallbackValue(FakeServiceState());
  });

  Widget buildTestableWidget(ServiceBloc serviceBloc) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('kk'), Locale('ru')],
      home: BlocProvider.value(value: serviceBloc, child: const HomeScreen()),
    );
  }

  group('HomeScreen Widget Tests', () {
    late MockServiceBloc mockServiceBloc;

    setUp(() {
      mockServiceBloc = MockServiceBloc();
    });

    testWidgets(
      'renders search bar, categories, and empty state when ServiceLoaded is empty',
      (tester) async {
        // 1. Arrange: Return empty loaded state
        when(() => mockServiceBloc.state).thenReturn(
          ServiceLoaded(services: [], searchQuery: '', selectedCategory: null),
        );

        // 2. Act: Pump the widget
        await tester.pumpWidget(buildTestableWidget(mockServiceBloc));
        await tester.pumpAndSettle();

        // 3. Assert: Verify core UI components exist
        expect(find.byType(TextField), findsOneWidget); // Search bar
        expect(find.byType(CategoryChip), findsWidgets); // Categories
        expect(
          find.byType(FloatingActionButton),
          findsOneWidget,
        ); // Create Order FAB

        // Verify empty state is shown (since services list is empty)
        expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
      },
    );

    testWidgets('triggers ServiceLoadAll on init', (tester) async {
      // 1. Arrange
      when(() => mockServiceBloc.state).thenReturn(
        ServiceLoaded(services: [], searchQuery: '', selectedCategory: null),
      );

      // 2. Act
      await tester.pumpWidget(buildTestableWidget(mockServiceBloc));

      // 3. Assert
      verify(() => mockServiceBloc.add(ServiceLoadAll())).called(1);
    });
  });
}
