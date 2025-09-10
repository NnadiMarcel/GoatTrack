import 'package:flutter/material.dart';

void main() {
  runApp(const GoatFarmApp());
}

class GoatFarmApp extends StatelessWidget {
  const GoatFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoatTrack',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const GoatRecordsPage(),
    const SalesExpensesPage(),
    const ReportsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GoatTrack"),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Records"),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Sales/Expenses"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ----------------- Pages -----------------

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Dashboard - Overview of goats, sales, expenses",
          style: TextStyle(fontSize: 18)),
    );
  }
}

class GoatRecordsPage extends StatelessWidget {
  const GoatRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Goat Records - Add, Edit, Delete goats",
          style: TextStyle(fontSize: 18)),
    );
  }
}

class SalesExpensesPage extends StatelessWidget {
  const SalesExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Sales & Expenses - Record sales and expenses",
          style: TextStyle(fontSize: 18)),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Reports - Profit/Loss overview",
          style: TextStyle(fontSize: 18)),
    );
  }
}
