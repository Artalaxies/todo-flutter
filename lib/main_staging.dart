import 'package:flutter/widgets.dart';
import 'package:local_storage_todos_api_impl/local_storage_todos_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/bootstrap.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final todosApi = LocalStorageTodosApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(todosApi: todosApi);
}
