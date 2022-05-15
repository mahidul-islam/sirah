part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => <Object>[];
}

class ErrorNotificationEvent extends NotificationEvent {
  const ErrorNotificationEvent(this.message);
  final String? message;
  @override
  List<Object?> get props => <String?>[message];
}

// class ServerUnderPlannedMaintainanceNotificationEvent
//     extends NotificationEvent {
//   const ServerUnderPlannedMaintainanceNotificationEvent({this.message});
//   final String? message;
//   @override
//   List<Object?> get props => <String?>[message];
// }

// class ServerErrorNotificationEvent extends NotificationEvent {}

class NoInternetConnectionNotificationEvent extends NotificationEvent {}

class SuccessNotificationEvent extends NotificationEvent {
  const SuccessNotificationEvent(this.message);
  final String message;
  @override
  List<Object> get props => <String>[message];
}

class SilentNotificationEvent extends NotificationEvent {
  const SilentNotificationEvent(this.message);
  final String message;
  @override
  List<Object> get props => <String>[message];
}

// class ForceUpdateEvent extends NotificationEvent {}

// class OptionalUpdateEvent extends NotificationEvent {
//   const OptionalUpdateEvent(
//       {this.android, this.ios, required this.title, required this.body});
//   final String? android;
//   final String? ios;
//   final String? title;
//   final String? body;

//   @override
//   List<Object?> get props => <String?>[android, ios, title, body];
// }
