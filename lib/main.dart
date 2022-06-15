import 'package:app_con_sockets/pages/home_page.dart';
import 'package:app_con_sockets/pages/status.dart';
import 'package:app_con_sockets/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        )
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home': (context) => HomeScreen(),
          'status': (context) => StatusScreen(),
        },
      ),
    );
  }
}
