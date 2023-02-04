import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todos_api/todos_api.dart';
import 'package:uuid/uuid.dart';

part 'todo.g.dart';

/// {@template todos}
/// A single todos item.
///
/// Contains a [title], [description] and [id], in addition to a [isCompleted]
/// flag.
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Todo]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@JsonSerializable()
class Todo extends Equatable {
  /// {@macro todos}
  Todo({
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.date,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  ///
  final GlobalKey key = GlobalKey();

  /// The unique identifier of the todos.
  ///
  /// Cannot be empty.
  final String id;

  /// The title of the todos.
  ///
  /// Note that the title may be empty.
  final String title;

  /// The description of the todos.
  ///
  /// Defaults to an empty string.
  final String description;

  /// Whether the todos is completed.
  ///
  /// Defaults to `false`.
  final bool isCompleted;

  /// The date of todos scheduled.
  ///
  /// Defaults to an empty string.
  final DateTime? date;

  /// Returns a copy of this todos with the given values updated.
  ///
  /// {@macro todos}
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? date,
  }) {
    return Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isCompleted: isCompleted ?? this.isCompleted,
        date: date ?? this.date,);
  }

  /// Deserializes the given [JsonMap] into a [Todo].
  static Todo fromJson(JsonMap json) => _$TodoFromJson(json);

  /// Converts this [Todo] into a [JsonMap].
  JsonMap toJson() => _$TodoToJson(this);

  @override
  List<Object> get props => [id, title, description, isCompleted];
}
