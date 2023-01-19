import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_repository/todos_repository.dart';

class InfiniteTimeViewState {
  InfiniteTimeViewState({
    required this.now,
    this.futureTimeCount = 20,
    this.pastTimeCount = 20,
  });

  final DateTime now;
  final int futureTimeCount;
  final int pastTimeCount;

  InfiniteTimeViewState copyWith({
    DateTime? now,
    int? futureTimeCount,
    int? pastTimeCount,
  }) =>
      InfiniteTimeViewState(
        now: now ?? this.now,
        futureTimeCount: futureTimeCount ?? this.futureTimeCount,
        pastTimeCount: pastTimeCount ?? this.pastTimeCount,
      );
}

class InfiniteTimeViewCubit extends Cubit<InfiniteTimeViewState> {
  InfiniteTimeViewCubit(DateTime now)
      : super(
    InfiniteTimeViewState(
      now: now,
    ),
  );

  void update(DateTime now) => emit(state.copyWith(now: now));



  void addMoreFutureTime() =>
      emit(state.copyWith(futureTimeCount: state.futureTimeCount + 10));

  void addMorePastTime() =>
      emit(state.copyWith(pastTimeCount: state.pastTimeCount + 10));
}
