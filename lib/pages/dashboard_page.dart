import 'package:flutter/material.dart';
import 'goat_records_page.dart'; // import the records page
import 'NotificationsPage.dart';

// Dashboard page widget
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar (top bar of the screen)
      appBar: AppBar(
        title: const Text("Overview"), // Title displayed on the app bar
        backgroundColor: Colors.green[700], // Custom background color
        actions: [
          // 🔔 Notification Bell
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // 👉 Navigate to notifications page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
          ),
        ],
      ),

      // SafeArea ensures content doesn't overlap with system UI (notch, status bar)
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add spacing around the grid
          child: GridView.count(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 16, // Horizontal spacing between cards
            mainAxisSpacing: 16, // Vertical spacing between cards
            shrinkWrap: true, // Prevents overflow issues
            children: [
              // Dashboard cards (Goats, Sales, Expenses, Profit, Kids)
              _buildDashboardCardWithImage("Goats", "0", "assets/images/goat.png", Colors.brown),
              _buildDashboardCardWithImage("Sales", "\$0", "assets/images/sales_box.png", Colors.blue),
              _buildDashboardCardWithImage("Expenses", "\$0", "assets/images/expenses_icon.png", Colors.red),
              _buildDashboardCardWithImage("Profit", "\$0", "assets/images/profit_icon.png", Colors.green),
              _buildDashboardCardWithImage("Kids", "0", "assets/images/goat_kid.png", Colors.brown),
            ],
          ),
        ),
      ),

      // ✅ Floating Action Button to add goat record
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add),
        onPressed: () {
          // navigate to goat records page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GoatRecordsPage()),
          );
        },
      ),
    );
  }

  // ✅ Reusable method to build a card with an IMAGE (instead of an icon)
  Widget _buildDashboardCardWithImage(
      String title, String value, String imagesPath, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
      elevation: 4, // Shadow depth
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Inner spacing
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
          children: [
            Flexible(
              child: Image.asset(
                imagesPath,
                height: 50,
                width: 50,
                fit: BoxFit.contain, // Keeps aspect ratio inside the card
                color: color, // custom color
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 10), // Space between image and value
            Text(
              value, // The main value (e.g., 0 goats)
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5), // Space between value and title
            Text(
              title, // The label (e.g., Goats)
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}