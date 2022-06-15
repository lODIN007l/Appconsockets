import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  //LLAMAMOS DESDE CUALQUIER LADO Y SABREMOS SI ESTA CON CONEXION
  get serverStatusG => this._serverStatus;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    IO.Socket socket = IO.io(
        "http://10.0.2.2:3000",
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());

    socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      //opcional
      socket.emit('mensaje', 'conectado desde app Flutter');
      notifyListeners();
      print('connect');
    });

    socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
      print('disconnect');
    });
  }
}
