// Import Flutter core material design package
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Import the separate page files (screens)
import 'pages/dashboard_page.dart';
import 'pages/goat_records_page.dart';
import 'pages/sales_expenses_page.dart';
import 'pages/reports_page.dart';
import 'pages/NotificationsPage.dart';
// import 'pages/profile_page.dart';
// import 'pages/settings_page.dart';
// import 'pages/subscriptions_page.dart';
// import 'pages/support_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Set system UI (status bar + navigation bar)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.grey,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const GoatFarmApp());
}

// Root widget
class GoatFarmApp extends StatelessWidget {
  const GoatFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoatTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.grey,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const MainPage(),
    );
  }
}

// Main page with bottom navigation + drawer
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // ✅ Pages list
  final List<Widget> _pages = [
    const DashboardPage(),
    const GoatRecordsPage(),
    const SalesExpensesPage(),
    const ReportsPage(),
  ];

  // ✅ Titles for dynamic AppBar
  final List<String> _titles = [
    "Dashboard",
    "Goat Records",
    "Sales & Expenses",
    "Reports",
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
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
      ),

      // ✅ Navigation Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Goat Farm"),
              accountEmail: const Text("goatfarm@email.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset("assets/images/goat.png", height: 40),
              ),
              decoration: const BoxDecoration(color: Colors.green),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("User Profile"),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text("Subscriptions"),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text("Export / Backup Data"),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add backup logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text("Contact Support"),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About / Help"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add logout logic
              },
            ),
          ],
        ),
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
