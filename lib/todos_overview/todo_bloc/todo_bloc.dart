/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:replay_bloc/replay_bloc.dart';
import 'package:todos_repository/todos_repository.dart';

import 'package:todos/todos_overview/todo_bloc/changed_todo.dart';

abstract class TodoEvent extends ReplayEvent {}

class TodoOnChanged extends TodoEvent {
  TodoOnChanged(this.changedTodo) : super();
  final ChangedTodo changedTodo;
}

class TodoSyncRequest extends TodoEvent {}

class TodoState {
  TodoState({required this.changedList});

  final Map<String, ChangedTodo> changedList;
}

class TodoBloc extends ReplayBloc<TodoEvent, TodoState> {
  TodoBloc(this.todosRepository)
      : super(TodoState(changedList: {})) {
    on<TodoOnChanged>(
      (event, emit) async {
        emit(
          TodoState(
            changedList: Map.of(
              (state.changedList)
                ..addAll({event.changedTodo.id: event.changedTodo}),
            ),
          ),
        );
      },
    );
    on<TodoSyncRequest>((event, emit) async {
      final changedTodos =
          state.changedList.values.map((e) => e.toTodo()).toList();
      await todosRepository.sync(changedTodos).then(
        (value) {
          emit(TodoState(changedList: {}));
        },
        onError: (e) {

        },
      );
    });
  }

  final TodosRepository todosRepository;
}
