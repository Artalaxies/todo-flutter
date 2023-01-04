import 'dart:developer' as d;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/app/todos_sync_bloc/todos_sync_bloc.dart';
import 'package:todos/app/todos_sync_bloc/todos_sync_state.dart';
import 'package:todos/l10n/l10n.dart';
import 'package:todos/todos_overview/todos_overview.dart';
import 'package:todos_repository/todos_repository.dart';
import 'dart:ui' as ui;

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodosOverviewBloc(
            todosRepository: context.read<TodosRepository>(),
          )..add(const TodosOverviewSubscriptionRequested()),
        ),
      ],
      child: TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatefulWidget {
  const TodosOverviewView({super.key});

  @override
  State<StatefulWidget> createState() => _TodosOverviewState();
}

class _TodosOverviewState extends State<TodosOverviewView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(l10n.todosOverviewAppBarTitle),
      //   actions: const [
      //     TodosOverviewFilterButton(),
      //     TodosOverviewOptionsButton(),
      //   ],
      // ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.todosOverviewErrorSnackbarText),
                    ),
                  );
              }
            },
          ),
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTodo != current.lastDeletedTodo &&
                current.lastDeletedTodo != null,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.todosOverviewTodoDeletedSnackbarText(
                        deletedTodo.title,
                      ),
                    ),
                    action: SnackBarAction(
                      label: l10n.todosOverviewUndoDeletionButtonText,
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<TodosOverviewBloc>()
                            .add(const TodosOverviewUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
          BlocListener<TodosSyncBloc, TodosSyncState>(
            listener: (context, state) {},
          ),
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (context, state) {
            // if (state.todos.isEmpty) {
            //   if (state.status == TodosOverviewStatus.loading) {
            //     return const Center(child: CupertinoActivityIndicator());
            //   } else if (state.status != TodosOverviewStatus.success) {
            //     return const SizedBox();
            //   } else {
            //     return Center(
            //       child: Text(
            //         l10n.todosOverviewEmptyText,
            //         style: Theme.of(context).textTheme.caption,
            //       ),
            //     );
            //   }
            // }
            final date = DateTime.now();
            final offsets = Iterable.generate(1000).map((e) {
              final size = MediaQuery.of(context).size;
              final py = Random().nextInt(size.height.toInt() - 1).toDouble();
              final px = Random().nextInt(size.width.toInt() - 1).toDouble();
              return Offset(px, py);
            }).toList();
            final theme = Theme.of(context);
            final captionTextStyle = theme.textTheme.caption?.getTextStyle() ??
                ui.TextStyle(color: Colors.blue);

            return ColoredBox(
              color: const Color(0xAAF1E2B1),
              child: CustomPaint(
                painter: BackgroundCustomPainter(offsets),
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      // final todo = Todo(
                      //   title: 'test$index',
                      // );
                      final indexDate = date
                          .subtract(
                            const Duration(hours: 1),
                          )
                          .add(
                            Duration(minutes: index * 5),
                          );
                      return CustomPaint(
                        painter:
                            TimeRulerCustomPainter(indexDate, captionTextStyle),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),
                            Container(
                              constraints: const BoxConstraints(minHeight: 44),
                            ),
                            // TodoListTile(
                            //   todo: t,
                            // ),
                          ],
                        ),
                      );
                    },
                    itemCount: 50,
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      d.log('is bottom');
    }
    if (_isTop) {
      d.log('is top');
    }
  }

  bool get _isTop {
    if (!_scrollController.hasClients) return false;
    final currentScroll = _scrollController.offset;
    return currentScroll < 100;
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class BackgroundCustomPainter extends CustomPainter {
  const BackgroundCustomPainter(this.offsets) : super();
  final List<Offset> offsets;

  @override
  void paint(Canvas canvas, Size size) {
    // const dense = 100;
    for (var n in offsets) {
      canvas.drawCircle(n, 1, Paint()..color = Colors.black38);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TimeRulerCustomPainter extends CustomPainter {
  TimeRulerCustomPainter(this.date, this.captionTextStyle) : super();
  final DateTime date;
  final ui.TextStyle captionTextStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final _minutes = (date.minute - (date.minute % 5)).toString();
    final formattedMinutes = _minutes.length == 1 ? '${_minutes}0' : _minutes;
    canvas.drawLine(
      const Offset(50, 18),
      Offset(size.width - 20, 18),
      Paint()
        ..color = date.difference(DateTime.now()).inMinutes < 5 &&
                date.difference(DateTime.now()).inMinutes > 0
            ? Colors.blue
            : Colors.black38
        ..strokeWidth = 2,
    );
    if (date.hour == 12) {
      canvas.drawParagraph(
        (ParagraphBuilder(ParagraphStyle())
              ..pushStyle(captionTextStyle)
              ..addText(
                'Noon Time',
              ))
            .build()
          ..layout(const ParagraphConstraints(width: 100)),
        Offset(size.width / 2 - 20, 10),
      );
    }
    canvas.drawParagraph(
      (ParagraphBuilder(ParagraphStyle())
            ..pushStyle(captionTextStyle)
            ..addText(
              '${date.hour.toString()}:$formattedMinutes',
            ))
          .build()
        ..layout(const ParagraphConstraints(width: 100)),
      const Offset(0, 10),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
