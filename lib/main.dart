import 'package:flutter/material.dart';
import 'package:rpg_persona2/ui/screens/home_screen.dart';
import 'data/db.dart';
import 'package:flutter/services.dart';

//import 'package:device_preview/device_preview.dart';
//import 'package:flutter/foundation.dart';

void main() async{
  // Initialisation de la base de données au premier lancement
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.database;

  runApp(const MyApp());
  // Pour tester différente taille de device
  /*runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(),
    )
  );*/
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
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

