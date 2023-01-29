/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:todos/edit_todo/view/edit_todo_page.dart';
// import 'package:todos/l10n/l10n.dart';
// import 'package:todos/todos_overview/todos_overview.dart';
// import 'package:todos_repository/todos_repository.dart';
//
// import '../../app/todos_sync_bloc/schedule_bloc.dart';
// import '../../app/todos_sync_bloc/schedule_state.dart';
//
//
// class TodosOverviewPage extends StatelessWidget {
//   const TodosOverviewPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => TodosOverviewBloc(
//             todosRepository: context.read<TodosRepository>(),
//           )..add(const TodosOverviewSubscriptionRequested()),
//         ),
//       ],
//       child: const TodosOverviewView(),
//     );
//   }
// }
//
// class TodosOverviewView extends StatelessWidget {
//   const TodosOverviewView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final l10n = context.l10n;
//
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text(l10n.todosOverviewAppBarTitle),
//       //   actions: const [
//       //     TodosOverviewFilterButton(),
//       //     TodosOverviewOptionsButton(),
//       //   ],
//       // ),
//       body: MultiBlocListener(
//         listeners: [
//           BlocListener<TodosOverviewBloc, TodosOverviewState>(
//             listenWhen: (previous, current) =>
//                 previous.status != current.status,
//             listener: (context, state) {
//               if (state.status == TodosOverviewStatus.failure) {
//                 ScaffoldMessenger.of(context)
//                   ..hideCurrentSnackBar()
//                   ..showSnackBar(
//                     SnackBar(
//                       content: Text(l10n.todosOverviewErrorSnackbarText),
//                     ),
//                   );
//               }
//             },
//           ),
//           BlocListener<TodosOverviewBloc, TodosOverviewState>(
//             listenWhen: (previous, current) =>
//                 previous.lastDeletedTodo != current.lastDeletedTodo &&
//                 current.lastDeletedTodo != null,
//             listener: (context, state) {
//               final deletedTodo = state.lastDeletedTodo!;
//               final messenger = ScaffoldMessenger.of(context);
//               messenger
//                 ..hideCurrentSnackBar()
//                 ..showSnackBar(
//                   SnackBar(
//                     content: Text(
//                       l10n.todosOverviewTodoDeletedSnackbarText(
//                         deletedTodo.title,
//                       ),
//                     ),
//                     action: SnackBarAction(
//                       label: l10n.todosOverviewUndoDeletionButtonText,
//                       onPressed: () {
//                         messenger.hideCurrentSnackBar();
//                         context
//                             .read<TodosOverviewBloc>()
//                             .add(const TodosOverviewUndoDeletionRequested());
//                       },
//                     ),
//                   ),
//                 );
//             },
//           ),
//           BlocListener<TodosSyncBloc, TodosSyncState>(
//               listener: (context, state) {
//
//               },),
//         ],
//         child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
//           builder: (context, state) {
//             if (state.todos.isEmpty) {
//               if (state.status == TodosOverviewStatus.loading) {
//                 return const Center(child: CupertinoActivityIndicator());
//               } else if (state.status != TodosOverviewStatus.success) {
//                 return const SizedBox();
//               } else {
//                 return Center(
//                   child: Text(
//                     l10n.todosOverviewEmptyText,
//                     style: Theme.of(context).textTheme.caption,
//                   ),
//                 );
//               }
//             }
//
//             return CupertinoScrollbar(
//               child: ListView(
//                 children: [
//                   for (final todo in state.filteredTodos)
//                     TodoListTile(
//                       todo: todo,
//                       onToggleCompleted: (isCompleted) {
//                         context.read<TodosOverviewBloc>().add(
//                               TodosOverviewTodoCompletionToggled(
//                                 todo: todo,
//                                 isCompleted: isCompleted,
//                               ),
//                             );
//                       },
//                       onDismissed: (_) {
//                         context
//                             .read<TodosOverviewBloc>()
//                             .add(TodosOverviewTodoDeleted(todo));
//                       },
//                       onTap: () {
//                         Navigator.of(context).push(
//                           EditTodoPage.route(initialTodo: todo),
//                         );
//                       },
//                     ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
