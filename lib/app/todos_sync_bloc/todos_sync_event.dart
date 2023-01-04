import 'package:equatable/equatable.dart';

abstract class TodosSyncEvent extends Equatable {
  const TodosSyncEvent();

  @override
  List<Object> get props => [];
}

class TodosSyncScheduled extends TodosSyncEvent {
  const TodosSyncScheduled({required this.sec}) : super();
  final int sec;
}

class TodosSyncStarted extends TodosSyncEvent {
  const TodosSyncStarted({required this.sec}) : super();
  final int sec;
}

class TodosSyncPaused extends TodosSyncEvent {
  const TodosSyncPaused() : super();
}
