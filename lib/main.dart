import 'package:flutter/material.dart';

void main() {
  runApp(GoatFarmApp());
}

class GoatFarmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoatTrack',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: GoatDashboard(),
    );
  }
}

class GoatDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoatTrack Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome to Chibuike Goat Farm App!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
