import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:local_storage_todos_api_impl/local_storage_todos_api.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_api/todos_api.dart';

/// {@template local_storage_todos_api}
/// A Flutter api_impl of the [TodosApi] that uses local storage.
/// {@endtemplate}
class ServerStorageTodosApiImpl extends LocalStorageTodosApi {
  /// {@macro notion_todos_api_impl}
  ServerStorageTodosApiImpl({
    required super.plugin,
    FirebaseFunctions? functions,
  })  : _functions = functions ?? FirebaseFunctions.instance,
        _plugin = plugin {
    _init();
  }

  final FirebaseFunctions _functions;

  final SharedPreferences _plugin;

  final _changedTodoStreamController =
      BehaviorSubject<List<Todo>>.seeded(const []);

  /// The key used for storing the changed todos locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kChangedTodosCollectionKey = '__changed_todos_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final changedTodosJson = _getValue(kChangedTodosCollectionKey);
    if (changedTodosJson != null) {
      final todos = List<Map<dynamic, dynamic>>.from(
        json.decode(changedTodosJson) as List,
      )
          .map((jsonMap) => Todo.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _changedTodoStreamController.add(todos);
    } else {
      _changedTodoStreamController.add(const []);
    }
  }

  @override
  Future<void> saveTodo(Todo todo) async {
    await super.saveTodo(todo);
    final todos = [..._changedTodoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == todo.id);
    if (todoIndex >= 0) {
      todos[todoIndex] = todo;
    } else {
      todos.add(todo);
    }
    _changedTodoStreamController.add(todos);
    return _setValue(kChangedTodosCollectionKey, json.encode(todos));

  }


  @override
  Future<void> sync(List<Todo> list) async {
    await super.sync(list);
    final callable = _functions.httpsCallable('todo-getMyTodos');
    final results = await callable().then((value){
      _changedTodoStreamController.add(const []);
    });
    log('Received Data: ${results.data}');
  }
}
