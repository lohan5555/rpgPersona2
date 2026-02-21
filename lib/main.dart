import 'package:flutter/material.dart';
import 'package:rpg_persona2/data/models/partie.dart';
import 'package:rpg_persona2/services/partieService.dart';
import 'data/db.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PartieService partieService = PartieService();

  List<Partie> _partie = [];

  @override
  void initState(){
    super.initState();
    _loadPartie();
  }

  Future<void> _loadPartie() async{
    final partie = await partieService.getAllpartie();
    setState(() {
      _partie = partie;
    });
  }

  Future<void> _createPartie() async{
    DateTime d = DateTime.now(); DateTime f = DateTime.now();
    final partie = Partie(name: "a", dateDebut: d, dateFin: f);
    await partieService.insertPartie(partie);
    await _loadPartie();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partie créé')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _partie.isEmpty
          ? const Center(child: Text('Aucune partie'))
          : ListView.builder(
        itemCount: _partie.length,
        itemBuilder: (context, index) {
          final partie = _partie[index];
          return ListTile(
            title: Text(partie.name),
            subtitle: Text(
              'Début : ${partie.dateDebut}\nFin : ${partie.dateFin}',
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPartie,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
