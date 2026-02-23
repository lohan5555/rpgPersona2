import 'package:flutter/material.dart';
import 'package:rpg_persona2/screens/home_page.dart';
import 'data/db.dart';
import 'package:flutter/services.dart';

void main() async{
  // Initialisation de la base de données au premier lancement
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // On empeche de basculer l'écran à l'horizontal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RPGpersona2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xfff8bc0c)),
        scaffoldBackgroundColor: Color(0xffffffff),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'RPGpersona'),
    );
  }
}

