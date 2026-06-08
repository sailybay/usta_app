import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usta_app/core/ai/ai_assistant_service.dart';
import 'package:usta_app/presentation/blocs/ai/ai_bloc.dart';

// ─── Mocks ────────────────────────────────────────────────────────────────────
class MockAiAssistantService extends Mock implements AiAssistantService {}

void main() {
  late MockAiAssistantService mockAiService;

  setUp(() {
    mockAiService = MockAiAssistantService();
  });

  AiBloc buildBloc() => AiBloc(aiService: mockAiService);

  group('AiBloc', () {
    test('initial state is AiInitial with empty messages', () {
      expect(buildBloc().state, const AiInitial());
      expect(buildBloc().state.messages, isEmpty);
    });

    blocTest<AiBloc, AiState>(
      'emits [AiLoading, AiResponseReceived] on AiMessageSent success',
      build: () {
        when(
          () => mockAiService.sendMessage(any()),
        ).thenAnswer((_) async => 'Hello from AI!');
        return buildBloc();
      },
      act: (bloc) => bloc.add(AiMessageSent('Hello')),
      expect: () => [
        isA<AiLoading>().having((s) => s.messages.length, 'messages length', 1),
        isA<AiResponseReceived>().having(
          (s) => s.messages.length,
          'messages length',
          2,
        ),
      ],
      verify: (bloc) {
        expect(bloc.state.messages[0].content, 'Hello');
        expect(bloc.state.messages[0].isUser, true);
        expect(bloc.state.messages[1].content, 'Hello from AI!');
        expect(bloc.state.messages[1].isUser, false);
      },
    );

    blocTest<AiBloc, AiState>(
      'emits AiInitial on AiSessionReset and clears messages',
      build: () {
        when(() => mockAiService.startNewSession()).thenReturn(null);
        return buildBloc();
      },
      act: (bloc) => bloc.add(AiSessionReset()),
      expect: () => [const AiInitial()],
      verify: (bloc) {
        expect(bloc.state.messages, isEmpty);
        verify(() => mockAiService.startNewSession()).called(1);
      },
    );

    blocTest<AiBloc, AiState>(
      'emits [AiLoading, AiResponseReceived] on AiGetOrderGuidance',
      build: () {
        when(
          () => mockAiService.getOrderGuidance(any(), any()),
        ).thenAnswer((_) async => 'Here is your guidance.');
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        AiGetOrderGuidance(status: 'pending', serviceName: 'Plumbing'),
      ),
      expect: () => [
        isA<AiLoading>(),
        isA<AiResponseReceived>().having(
          (s) => s.messages.last.content,
          'AI response',
          'Here is your guidance.',
        ),
      ],
    );

    blocTest<AiBloc, AiState>(
      'emits [AiLoading, AiResponseReceived] on AiGetWorkerSuggestion',
      build: () {
        when(
          () => mockAiService.getWorkerSuggestion(
            completedOrders: any(named: 'completedOrders'),
            rating: any(named: 'rating'),
            totalIncome: any(named: 'totalIncome'),
          ),
        ).thenAnswer((_) async => 'You are doing great as a worker!');
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        AiGetWorkerSuggestion(
          completedOrders: 10,
          rating: 4.8,
          totalIncome: 50000,
        ),
      ),
      expect: () => [
        isA<AiLoading>(),
        isA<AiResponseReceived>().having(
          (s) => s.messages.last.content,
          'AI response',
          'You are doing great as a worker!',
        ),
      ],
    );
  });
}
