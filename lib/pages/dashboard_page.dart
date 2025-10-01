import 'package:flutter/material.dart';
import 'NotificationsPage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedFilter = "Current Month"; // Default filter

  // ✅ Backend-ready variables (replace these with database values later)
  int totalGoats = 0;
  int totalKids = 0;
  double totalSales = 0.0;
  double totalProfit = 0.0;
  int pregnantGoats = 0;
  double totalExpenses = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Overview",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        actions: [
          // Filter Icon
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
          // Notification Bell
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
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

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            children: [
              _buildDashboardCardWithImage(
                  "Goats", "$totalGoats", "assets/images/goat.png", Colors.brown),
              _buildDashboardCardWithImage(
                  "Kids", "$totalKids", "assets/images/goat_kid.png", Colors.brown),
              _buildDashboardCardWithImage(
                  "Sales", "\$${totalSales.toStringAsFixed(2)}",
                  "assets/images/sales_box.png", Colors.brown),
              _buildDashboardCardWithImage(
                  "Profit", "\$${totalProfit.toStringAsFixed(2)}",
                  "assets/images/profit_icon.png", Colors.brown),
              _buildDashboardCardWithImage(
                  "Pregnant Goats", "$pregnantGoats",
                  "assets/images/pregnant_goat.png", Colors.brown),
              _buildDashboardCardWithImage(
                  "Expenses", "\$${totalExpenses.toStringAsFixed(2)}",
                  "assets/images/expenses_icon.png", Colors.brown),
            ],
          ),
        ),
      ),
    );
  }

  // Filter Options with checkmark
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            _buildFilterTile("Last 7 Days"),
            _buildFilterTile("Current Month"),
            _buildFilterTile("Last 3 Months"),
            _buildFilterTile("Last 6 Months"),
            _buildFilterTile("Current Year"),
            _buildFilterTile("Previous Year"),
            _buildFilterTile("Custom Range"),
          ],
        );
      },
    );
  }

  // Reusable filter option with highlight
  Widget _buildFilterTile(String option) {
    return ListTile(
      title: Text(option),
      trailing: _selectedFilter == option
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () async {
        if (option == "Custom Range") {
          Navigator.pop(context); // Close bottom sheet before opening picker
          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime.now().add(const Duration(days: 365)), // allow future dates
            initialDateRange: DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 7)),
              end: DateTime.now(),
            ),
          );

          if (picked != null) {
            setState(() {
              _selectedFilter =
              "Custom Range: ${picked.start.toString().split(' ')[0]} - ${picked.end.toString().split(' ')[0]}";
            });
          }
        } else {
          setState(() {
            _selectedFilter = option;
          });
          Navigator.pop(context);
        }
      },
    );
  }

  // Dashboard card widget
  Widget _buildDashboardCardWithImage(
      String title, String value, String imagePath, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(
                imagePath,
                height: 50,
                width: 50,
                fit: BoxFit.contain,
                color: color,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
