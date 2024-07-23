import 'package:flutter/material.dart';

class Interaction extends StatefulWidget {
  const Interaction({super.key});

  @override
  State<Interaction> createState() => _InteractionState();
}

class _InteractionState extends State<Interaction> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Interaction page'
      ),
    );
  }
}
