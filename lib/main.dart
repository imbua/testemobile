import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemobile/controllers/databasehelper.dart';
//import 'package:testemobile/controllers/databasehelper.dart';
import 'package:testemobile/controllers/login_controller.dart';
import 'package:testemobile/controllers/mytreeview_controller.dart';

import 'package:testemobile/views/login_view.dart';
import 'package:testemobile/views/mytreeview_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MyTreeViewController());
  Get.put(LoginController());

  //Deu muito conflito e esgotou meu tempo, ficou a desenvolver
  DatabaseHelper.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Teste Mobile - Semeq',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(
            name: '/mytreeview',
            page: () => MyTreeViewView()), // Adicione sua HomeView aqui
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
