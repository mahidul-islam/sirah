import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on((SuccessNotificationEvent event, Emitter<NotificationState> emit) {
      emit(SuccessNotificationState(event.message));
      emit(NotificationInitial());
    });

    on((ErrorNotificationEvent event, Emitter<NotificationState> emit) {
      emit(ErrorNotificationState(event.message));
      emit(NotificationInitial());
    });
    on((SilentNotificationEvent event, Emitter<NotificationState> emit) {
      emit(SilentNotificationState(event.message));
      emit(NotificationInitial());
    });
  }
}
