part of 'timeline_bloc.dart';

abstract class TimelineState extends Equatable {
  const TimelineState();
  
  @override
  List<Object> get props => [];
}

class TimelineInitial extends TimelineState {}
