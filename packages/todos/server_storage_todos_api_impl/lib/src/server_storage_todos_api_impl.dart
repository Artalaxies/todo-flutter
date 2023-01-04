import 'dart:async';
import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:local_storage_todos_api_impl/local_storage_todos_api.dart';
import 'package:todos_api/todos_api.dart';

/// {@template local_storage_todos_api}
/// A Flutter api_impl of the [TodosApi] that uses local storage.
/// {@endtemplate}
class ServerStorageTodosApiImpl extends TodosApi {
  /// {@macro notion_todos_api_impl}
  ServerStorageTodosApiImpl({
    required SharedPreferences localStorageInstance,
    FirebaseFunctions? functions,
  }) : _localStorageApi = LocalStorageTodosApi(plugin: localStorageInstance),
      _functions = functions ?? FirebaseFunctions.instance;

  final LocalStorageTodosApi _localStorageApi;
  final FirebaseFunctions _functions;


  @override
  Future<void> sync() async{

    final callable = _functions.httpsCallable('todo-getMyTodos');
    final results = await callable();
    log('Received Data: ${results.data}');
    return;
  }


  @override
  Stream<List<Todo>> getTodos() {
    return _localStorageApi.getTodos();
  }
    @override
    Future<void> saveTodo(Todo todo) {
      return _localStorageApi.saveTodo(todo);
    }

    @override
    Future<void> deleteTodo(String id) {
      return _localStorageApi.deleteTodo(id);
    }

    @override
    Future<int> clearCompleted() async {
      return _localStorageApi.clearCompleted();
    }

    @override
    Future<int> completeAll({required bool isCompleted}) async {
      return _localStorageApi.completeAll(isCompleted: isCompleted);
  }
}
