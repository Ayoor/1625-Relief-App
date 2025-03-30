import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  ConnectivityProvider() {
    _checkConnectivity();
  }

  void _checkConnectivity() {
    InternetConnection().onStatusChange.listen((status) {
      bool newStatus = status == InternetStatus.connected;
      if (_isConnected != newStatus) {
        _isConnected = newStatus;
        notifyListeners();
      }
    });
  }
}
