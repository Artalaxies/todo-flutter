
import 'package:equatable/equatable.dart';



abstract class TodosSyncState extends Equatable{
  const TodosSyncState({
    this.interrupted = false,
  });
  final bool interrupted;

  @override
  List<Object> get props => [interrupted];
}

class TodosSyncInitial extends TodosSyncState{
  const TodosSyncInitial({super.interrupted});

}

class TodosSyncInProgress extends TodosSyncState{
  const TodosSyncInProgress({super.interrupted});
}

class TodosSyncSuccess extends TodosSyncState{
  const TodosSyncSuccess({super.interrupted});
}

class TodosSyncFailure extends TodosSyncState{
  const TodosSyncFailure({super.interrupted,required this.error});
  final Exception error;

  @override
  List<Object> get props => [interrupted, error];
}
