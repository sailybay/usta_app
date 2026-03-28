import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/ai/ai_assistant_service.dart';

// ─── Events ───────────────────────────────────────────────────────────────────
abstract class AiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AiMessageSent extends AiEvent {
  final String message;
  AiMessageSent(this.message);
  @override
  List<Object?> get props => [message];
}

class AiSessionReset extends AiEvent {}

class AiGetOrderGuidance extends AiEvent {
  final String status;
  final String serviceName;
  AiGetOrderGuidance({required this.status, required this.serviceName});
  @override
  List<Object?> get props => [status, serviceName];
}

class AiGetWorkerSuggestion extends AiEvent {
  final int completedOrders;
  final double rating;
  final double totalIncome;
  AiGetWorkerSuggestion({
    required this.completedOrders,
    required this.rating,
    required this.totalIncome,
  });
}

// ─── States ───────────────────────────────────────────────────────────────────
abstract class AiState extends Equatable {
  final List<AiMessage> messages;
  const AiState(this.messages);
  @override
  List<Object?> get props => [messages];
}

class AiInitial extends AiState {
  const AiInitial() : super(const []);
}

class AiLoading extends AiState {
  const AiLoading(super.messages);
}

class AiResponseReceived extends AiState {
  const AiResponseReceived(super.messages);
}

class AiError extends AiState {
  final String error;
  const AiError(super.messages, this.error);
  @override
  List<Object?> get props => [...super.props, error];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────
class AiBloc extends Bloc<AiEvent, AiState> {
  final AiAssistantService _aiService;
  final List<AiMessage> _messages = [];

  AiBloc({required AiAssistantService aiService})
    : _aiService = aiService,
      super(const AiInitial()) {
    on<AiMessageSent>(_onMessageSent);
    on<AiSessionReset>(_onSessionReset);
    on<AiGetOrderGuidance>(_onOrderGuidance);
    on<AiGetWorkerSuggestion>(_onWorkerSuggestion);
  }

  Future<void> _onMessageSent(
    AiMessageSent event,
    Emitter<AiState> emit,
  ) async {
    _messages.add(AiMessage(content: event.message, isUser: true));
    emit(AiLoading(List.from(_messages)));

    final response = await _aiService.sendMessage(event.message);
    _messages.add(AiMessage(content: response, isUser: false));
    emit(AiResponseReceived(List.from(_messages)));
  }

  Future<void> _onSessionReset(
    AiSessionReset event,
    Emitter<AiState> emit,
  ) async {
    _messages.clear();
    _aiService.startNewSession();
    emit(const AiInitial());
  }

  Future<void> _onOrderGuidance(
    AiGetOrderGuidance event,
    Emitter<AiState> emit,
  ) async {
    emit(AiLoading(List.from(_messages)));
    final response = await _aiService.getOrderGuidance(
      event.status,
      event.serviceName,
    );
    _messages.add(AiMessage(content: response, isUser: false));
    emit(AiResponseReceived(List.from(_messages)));
  }

  Future<void> _onWorkerSuggestion(
    AiGetWorkerSuggestion event,
    Emitter<AiState> emit,
  ) async {
    emit(AiLoading(List.from(_messages)));
    final response = await _aiService.getWorkerSuggestion(
      completedOrders: event.completedOrders,
      rating: event.rating,
      totalIncome: event.totalIncome,
    );
    _messages.add(AiMessage(content: response, isUser: false));
    emit(AiResponseReceived(List.from(_messages)));
  }
}
