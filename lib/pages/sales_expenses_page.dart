import 'package:flutter/material.dart';

class SalesExpensesPage extends StatelessWidget {
  const SalesExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Sales & Expenses Page",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
