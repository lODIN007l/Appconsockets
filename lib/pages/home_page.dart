import 'dart:io';

import 'package:app_con_sockets/models/banda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Banda> LBanda = [
    Banda(id: '1', name: 'Metalica', votes: 5),
    Banda(id: '2', name: 'LINKINPARK', votes: 5),
    Banda(id: '3', name: 'ROCK', votes: 5),
    Banda(id: '4', name: 'ACDC', votes: 5),
    Banda(id: '5', name: 'TWENTYONEPILOTS', votes: 5)
  ];

  @override
  Widget build(BuildContext context) {
    final scoketProvi = Provider.of<SocketService>(context);
    //print(scoketProvi.serverStatusG);
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Center(
            child: Text(
              'Nombres de Bandas',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          actions: [
            Container(
                margin: EdgeInsets.only(right: 10),
                child: scoketProvi.serverStatusG == ServerStatus.Online
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.blue[300],
                      )
                    : Icon(
                        Icons.offline_bolt,
                        color: Colors.redAccent,
                      )),
          ],
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: LBanda.length,
          itemBuilder: (BuildContext context, int index) {
            return bandaTile(LBanda[index]);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addNewBand,
          child: Icon(Icons.add),
          elevation: 1,
        ));
  }

  Widget bandaTile(Banda objbanda) {
    return Dismissible(
      key: Key(objbanda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print(direction);
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Eliminar Banda',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(objbanda.name.substring(0, 2)),
        ),
        title: Text(objbanda.name),
        trailing: Text(
          '${objbanda.votes}',
          style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        onTap: () => print(objbanda.name),
      ),
    );
  }

  addNewBand() {
    final texcontroler = TextEditingController();
    if (Platform.isIOS) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Nueva banda '),
          content: TextField(
            controller: texcontroler,
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                addBandList(texcontroler.text);
              },
              child: Text('Agregar'),
              elevation: 5,
            )
          ],
        ),
      );
    }
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('Agregar Banda'),
            content: CupertinoTextField(
              controller: texcontroler,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('agregar'),
                onPressed: () => addBandList(texcontroler.text),
                textStyle:
                    TextStyle(fontSize: 19, fontWeight: FontWeight.normal),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('cerrar'),
                onPressed: () => Navigator.pop(context),
                textStyle:
                    TextStyle(fontSize: 19, fontWeight: FontWeight.normal),
              ),
            ],
          );
        });
  }

  void addBandList(String name) {
    print(name);
    if (name.length > 1) {
      //podmeos agregar
      this
          .LBanda
          .add(new Banda(id: DateTime.now().toString(), name: name, votes: 1));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
