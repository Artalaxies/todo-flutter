import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:todos_repository/todos_repository.dart';

part 'changed_todo.g.dart';

@immutable
@JsonSerializable()
class ChangedTodo extends Todo {
  ChangedTodo({
    super.id,
    required super.title,
    super.description,
    super.isCompleted,
    super.date,
    this.index,
  });

  final int? index;

  @override
  ChangedTodo copyWith(
      {String? id,
      String? title,
      String? description,
      bool? isCompleted,
      DateTime? date,
      int? index}) {
    return ChangedTodo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      index: index ?? this.index,
    );
  }

  static ChangedTodo fromJson(Map<String, dynamic> json) =>
      _$ChangedTodoFromJson(json);

  static ChangedTodo fromTodo(Todo todo) => ChangedTodo(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted,
        date: todo.date,
      );

  Todo toTodo() => Todo(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      date: date);

  @override
  Map<String, dynamic> toJson() => _$ChangedTodoToJson(this);

  @override
  List<Object> get props => [id];
}
