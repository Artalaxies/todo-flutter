/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/app/schedule_bloc/schedule_event.dart';
import 'package:todos/app/schedule_bloc/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleState()) {
    on<ScheduleCheckupStarted>(_onStarted);
    on<ScheduleCheckupPaused>(_onPaused);
    on<ScheduleCheckupStopped>(_onStopped);
    on<ScheduleCheckupResumed>(_onResumed);
    on<ScheduleNoticed>(_onNoticed);
  }

  StreamSubscription<int>? _scheduleSubscription;

  Stream<int> _timer(int initCount) =>
      Stream.periodic(const Duration(seconds: 1), (x) => x++);

  @override
  Future<void> close() {
    _scheduleSubscription?.cancel();
    return super.close();
  }

  void _onStarted(
    ScheduleCheckupStarted event,
    Emitter<ScheduleState> emit,
  ) {
    _scheduleSubscription?.cancel();
    _scheduleSubscription = _timer(0).listen((duration) {
      if (duration % event.duration == 0) {
        add(ScheduleNoticed(duration: duration));
      }
    });
    emit(ScheduleState(status: ScheduleStatus.inProgress));
  }

  void _onNoticed(
    ScheduleNoticed event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(duration: event.duration));
  }

  void _onPaused(ScheduleCheckupPaused event, Emitter<ScheduleState> emit) {
    _scheduleSubscription?.pause();
    emit(
      state.copyWith(
        status: ScheduleStatus.stop,
        duration: state.duration,
      ),
    );
  }

  void _onStopped(
    ScheduleCheckupStopped event,
    Emitter<ScheduleState> emit,
  ) {
    _scheduleSubscription?.cancel();
    emit(ScheduleState(status: ScheduleStatus.stop));
  }

  void _onResumed(
    ScheduleCheckupResumed event,
    Emitter<ScheduleState> emit,
  ) {
    _scheduleSubscription?.resume();
    emit(
      state.copyWith(
        status: ScheduleStatus.inProgress,
        duration: state.duration,
      ),
    );
  }
}
