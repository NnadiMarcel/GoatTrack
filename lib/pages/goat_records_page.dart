import 'package:flutter/material.dart';

class GoatRecordsPage extends StatelessWidget {
  const GoatRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Goat Records Page",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
