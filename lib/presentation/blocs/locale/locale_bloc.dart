import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Events ───────────────────────────────────────────────────────────────────
abstract class LocaleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocaleChanged extends LocaleEvent {
  final Locale locale;
  LocaleChanged(this.locale);
  @override
  List<Object?> get props => [locale];
}

class LocaleLoaded extends LocaleEvent {}

// ─── State ────────────────────────────────────────────────────────────────────
class LocaleState extends Equatable {
  final Locale locale;
  const LocaleState(this.locale);
  @override
  List<Object?> get props => [locale];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  static const _key = 'app_locale';

  LocaleBloc() : super(const LocaleState(Locale('kk'))) {
    on<LocaleLoaded>(_onLoaded);
    on<LocaleChanged>(_onChanged);
  }

  Future<void> _onLoaded(LocaleLoaded event, Emitter<LocaleState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'kk';
    emit(LocaleState(Locale(code)));
  }

  Future<void> _onChanged(
    LocaleChanged event,
    Emitter<LocaleState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, event.locale.languageCode);
    emit(LocaleState(event.locale));
  }
}
