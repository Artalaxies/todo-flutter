/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

part of 'stats_bloc.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();

  @override
  List<Object> get props => [];
}

class StatsSubscriptionRequested extends StatsEvent {
  const StatsSubscriptionRequested();
}
