import 'package:app_con_sockets/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scoketProvi = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('Server Status: ${scoketProvi.serverStatusG}')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          scoketProvi.socketG.emit('emitir-mensaje',
              {'nombre': 'Flutter', 'mensaje': 'Hola flutter'});
        },
      ),
    );
  }
}
