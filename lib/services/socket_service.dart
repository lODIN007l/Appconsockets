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
  late IO.Socket _socket;
  ServerStatus get serverStatusG => this._serverStatus;
  IO.Socket get socketG => this._socket;
  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    this._socket = IO.io(
        "http://10.0.2.2:3000",
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());

    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      //opcional
      this._socket.emit('mensaje', 'conectado desde app Flutter');
      notifyListeners();
      print('connect');
    });

    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
      print('disconnect');
    });

    // this._socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo mensaje !!!!');
    //   print('nombre:' + payload['nombre']);
    //   print('mensaje:' + payload['mensaje']);
    //   print(payload.containsKey('mensaje2')
    //       ? payload['mensaje2']
    //       : 'no xite el argumento llamado');
    // });
  }
}
