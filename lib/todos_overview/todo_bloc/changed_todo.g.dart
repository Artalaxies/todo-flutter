/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changed_todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangedTodo _$ChangedTodoFromJson(Map<String, dynamic> json) => ChangedTodo(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      index: json['index'] as int?,
    );

Map<String, dynamic> _$ChangedTodoToJson(ChangedTodo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'date': instance.date?.toIso8601String(),
      'index': instance.index,
    };
