part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => <Object>[];
}

class NotificationInitial extends NotificationState {}

class NotificationUpdatedState extends NotificationState {}

class ErrorNotificationState extends NotificationState {
  const ErrorNotificationState(this.message);
  final String? message;
  @override
  List<Object?> get props => <String?>[message];
}

class SuccessNotificationState extends NotificationState {
  const SuccessNotificationState(this.message);
  final String message;
  @override
  List<Object> get props => <String>[message];
}

class SilentNotificationState extends NotificationState {
  const SilentNotificationState(this.message);
  final String message;
  @override
  List<Object> get props => <String>[message];
}

// class ForceUpdateState extends NotificationState {}

// class OptionalUpdateState extends NotificationState {
//   const OptionalUpdateState(
//       {this.android, this.ios, required this.title, required this.body});
//   final String? android;
//   final String? ios;
//   final String? title;
//   final String? body;

//   @override
//   List<Object?> get props => <String?>[android, ios, title, body];
// }

// class ServerUnderPlannedMaintainanceNotificationState
//     extends NotificationState {
//   const ServerUnderPlannedMaintainanceNotificationState(
//       {this.message, this.callback});
//   final String? message;
//   final Function? callback;
//   @override
//   List<Object?> get props => <String?>[message];
// }

// class ServerErrorNotificationState extends NotificationState {}

class NoInternetConnectionNotificationState extends NotificationState {}
