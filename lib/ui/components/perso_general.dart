import 'package:flutter/widgets.dart';

class PersoGeneral extends StatelessWidget{

  const PersoGeneral({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("général"),
        const Image(image: AssetImage('assets/placeholder.jpeg'))
      ],
    );
  }
}