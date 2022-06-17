import 'dart:io';
import 'package:pie_chart/pie_chart.dart';
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
    // Banda(id: '1', name: 'Metalica', votes: 5),
    // Banda(id: '2', name: 'LINKINPARK', votes: 5),
    // Banda(id: '3', name: 'ROCK', votes: 5),
    // Banda(id: '4', name: 'ACDC', votes: 5),
    // Banda(id: '5', name: 'TWENTYONEPILOTS', votes: 5)
  ];

  @override
  void initState() {
    final scoketProvi = Provider.of<SocketService>(context, listen: false);
    scoketProvi.socketG.on('bandas-registradas', (payload) {
      this.LBanda =
          (payload as List).map((banaobj) => Banda.fromMap(banaobj)).toList();
      //print(payload);
      setState(() {});
    });
    super.initState();
  }

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
                //TODO:hacemos un if para ver la conexion en base al status
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
        body: Column(
          children: [
            //solo si las bandas esta con datos se dibuja el widget
            if (LBanda.isNotEmpty) _graficadebandas(),
            Expanded(
              child: ListView.builder(
                itemCount: LBanda.length,
                itemBuilder: (BuildContext context, int index) {
                  return bandaTile(LBanda[index]);
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addNewBand,
          child: Icon(Icons.add),
          elevation: 1,
        ));
  }

  Widget bandaTile(Banda objbanda) {
    final socketSerObj = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(objbanda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        print(objbanda.id);
        socketSerObj.socketG.emit('eliminar-banda', {'id': objbanda.id});
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
        onTap: () {
          socketSerObj.socketG.emit('votar-banda', {'id': objbanda.id});
        },
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
    final socketSerObj = Provider.of<SocketService>(context, listen: false);
    print(name);
    if (name.length > 1) {
      //podmeos agregar
      socketSerObj.socketG.emit('nueva-banda', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _graficadebandas() {
    Map<String, double> dataMap = new Map();
    LBanda.forEach((banda) {
      dataMap.putIfAbsent(banda.name, () => banda.votes.toDouble());
    });

    return Container(
      margin: const EdgeInsets.only(left: 10, top: 5),
      child: PieChart(
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.left,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        dataMap: dataMap,
      ),
    );
  }
}
