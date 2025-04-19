part of 'check_connection_cubit.dart';

@immutable
sealed class CheckConnectionState {}

final class CheckConnectionInitial extends CheckConnectionState {}

class CheckConnection extends CheckConnectionState {
  var connected = false;
  CheckConnection({required this.connected});
}
