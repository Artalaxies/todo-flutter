/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

part of 'edit_todo_bloc.dart';

abstract class EditTodoEvent extends Equatable {
  const EditTodoEvent();

  @override
  List<Object> get props => [];
}

class EditTodoTitleChanged extends EditTodoEvent {
  const EditTodoTitleChanged(this.id,this.title);

  final String title;
  final String id;

  @override
  List<Object> get props => [id,title];
}

class EditTodoDescriptionChanged extends EditTodoEvent {
  const EditTodoDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class EditTodoSubmitted extends EditTodoEvent {
  const EditTodoSubmitted();
}