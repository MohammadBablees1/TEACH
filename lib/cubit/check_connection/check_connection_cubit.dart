import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'check_connection_state.dart';

enum ConnectivityStatus { mobile, wifi, none, unknown }

class CheckConnectionCubit extends Cubit<ConnectivityStatus> {
  CheckConnectionCubit() : super(ConnectivityStatus.unknown) {
    _initConnectivity();
    Connectivity()
        .onConnectivityChanged
        .listen((result) => _updateConnectionStatus(result));
  }

  Future<void> _initConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(result) {
    switch (result) {
      case ConnectivityResult.mobile:
        emit(ConnectivityStatus.mobile);
        break;
      case ConnectivityResult.wifi:
        emit(ConnectivityStatus.wifi);
        break;
      case ConnectivityResult.none:
        emit(ConnectivityStatus.none);
        break;
      default:
        emit(ConnectivityStatus.unknown);
    }
  }
  // checkConnection() {
  //   Connectivity().onConnectivityChanged.listen(
  //     (event) {
  //       switch (event) {
  //         case ConnectivityResult.mobile:
  //           emit(CheckConnection(connected: true));
  //           break;
  //         case ConnectivityResult.wifi:
  //           emit(CheckConnection(connected: true));
  //           break;
  //         case ConnectivityResult.none:
  //           emit(CheckConnection(connected: false));
  //           break;
  //       }
  //     },
  //   );
  // }
}
