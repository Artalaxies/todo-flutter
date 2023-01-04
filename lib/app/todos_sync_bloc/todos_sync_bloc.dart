
import 'dart:developer';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/app/todos_sync_bloc/todos_sync_event.dart';
import 'package:todos/app/todos_sync_bloc/todos_sync_state.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosSyncBloc extends Bloc<TodosSyncEvent, TodosSyncState> {
  TodosSyncBloc({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(const TodosSyncInitial()) {
    on<TodosSyncScheduled>(
      (event, emit) async {
        if (!state.interrupted) {
          await Future.delayed(
              Duration(seconds: event.sec),
              () => add(TodosSyncStarted(sec: event.sec,)),);
        }
      },
      transformer: sequential(),
    );
    on<TodosSyncStarted>(
      (event, emit) async {
        emit(const TodosSyncInProgress());
        try {
          await _todosRepository.sync();
          emit(const TodosSyncSuccess());
          if(event.sec > 0) {
            add(TodosSyncScheduled(sec: event.sec));
          }
        } on Exception catch (ex, e) {
          emit(TodosSyncFailure(interrupted: true, error: ex));
          add(const TodosSyncPaused());
          log(e.toString());
          rethrow;
        }
      },
      transformer: droppable(),
    );
    on<TodosSyncPaused>(
      (event, emit) {},
      transformer: sequential(),
    );
  }

  final TodosRepository _todosRepository;
}
