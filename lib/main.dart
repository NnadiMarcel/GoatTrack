// Import Flutter's core material design package
import 'package:flutter/material.dart';

// Import the separate page files (screens) for navigation
import 'pages/dashboard_page.dart';
import 'pages/goat_records_page.dart';
import 'pages/sales_expenses_page.dart';
import 'pages/reports_page.dart';

// The entry point of the app
void main() {
  runApp(const GoatFarmApp()); // Runs the app and loads GoatFarmApp widget
}

// Root widget of the app
class GoatFarmApp extends StatelessWidget {
  const GoatFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'GoatTrack', // App title
      theme: ThemeData(
        primarySwatch: Colors.green, // Main theme color
      ),
      home: const MainPage(), // First page loaded when app starts
    );
  }
}

// The main page containing bottom navigation
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

// State class for MainPage (manages changes in selected page)
class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // Keeps track of which tab is active

  // List of pages that can be displayed
  final List<Widget> _pages = [
    const DashboardPage(),
    const GoatRecordsPage(),
    const SalesExpensesPage(),
    const ReportsPage(),
  ];

  // Function to update selected tab index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Updates the active page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GoatTrack"), // Title on top
        centerTitle: true, // Centers the title text
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures all items are shown
        items: const [
          // Navigation items (with icons and labels)
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Records"),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Sales/Expenses"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
        ],
        currentIndex: _selectedIndex, // Highlights the active tab
        selectedItemColor: Colors.green, // Active tab color
        onTap: _onItemTapped, // Handles tab click
      ),
    );
  }
}
