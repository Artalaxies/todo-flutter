
import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}


class ScheduleCheckupStarted extends ScheduleEvent {
  const ScheduleCheckupStarted({required this.duration}) : super();
  final int duration;

}

class ScheduleCheckupPaused extends ScheduleEvent {
  const ScheduleCheckupPaused() : super();
}

class ScheduleCheckupStopped extends ScheduleEvent{
  const ScheduleCheckupStopped() : super();
}


class ScheduleCheckupResumed extends ScheduleEvent{
  const ScheduleCheckupResumed() : super();
}

class ScheduleNoticed extends ScheduleEvent {
  const ScheduleNoticed({required this.duration}) : super();
  final int duration;
}