import 'package:equatable/equatable.dart';

enum ScheduleStatus { initial, inProgress, stop }

class ScheduleState extends Equatable {
  ScheduleState({
    this.status = ScheduleStatus.initial,
    this.duration = 0,
    DateTime? datetime,
  }): datetime = datetime ?? DateTime.now();

  final ScheduleStatus status;
  final int duration;
  final DateTime datetime;

  ScheduleState copyWith({
    ScheduleStatus? status,
    int? duration,
    DateTime? datetime,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      duration: duration ?? this.duration,
      datetime: datetime ?? this.datetime,
    );
  }

  @override
  List<Object> get props => [status, duration];
}
