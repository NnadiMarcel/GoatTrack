// Import Flutter's core material design package
import 'package:flutter/material.dart';

// Import the separate page files (screens) for navigation
import 'pages/dashboard_page.dart';
import 'pages/goat_records_page.dart';
import 'pages/sales_expenses_page.dart';
import 'pages/reports_page.dart';
import 'pages/NotificationsPage.dart';

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

      // ✅ Navigation Drawer Added
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            UserAccountsDrawerHeader(
              accountName: const Text("Goat Farm"),
              accountEmail: const Text("goatfarm@email.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset("assets/images/goat.png", height: 40),
              ),
              decoration: BoxDecoration(
                color: Colors.green[700],
              ),
            ),

            // 👤 User Profile
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("User Profile"),
              onTap: () {
                // TODO: Navigate to Profile Page
                Navigator.pop(context);
              },
            ),

            // ⚙️ Settings
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                // TODO: Navigate to Settings Page
                Navigator.pop(context);
              },
            ),

            // 🔔 Notifications / Alerts
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              onTap: () {
                // TODO: Navigate to Notifications Page
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsPage(), // ✅ Opens Notifications Page
                  ),
                );
              },
            ),

            // 💳 Subscriptions / Membership
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text("Subscriptions"),
              onTap: () {
                // TODO: Navigate to Subscription Page
                Navigator.pop(context);
              },
            ),

            // 📤 Export / Backup Data
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text("Export / Backup Data"),
              onTap: () {
                // TODO: Trigger data export / backup
                Navigator.pop(context);
              },
            ),

            // 📞 Contact Support
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text("Contact Support"),
              onTap: () {
                // TODO: Open support page or email/WhatsApp
                Navigator.pop(context);
              },
            ),

            // ℹ️ About/Help
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About / Help"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const Divider(),

            // 🚪 Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                // TODO: Handle logout logic
                Navigator.pop(context);
              },
            ),
          ],
        ),
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
