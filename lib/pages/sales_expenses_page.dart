import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesExpensesPage extends StatefulWidget {
  const SalesExpensesPage({super.key});

  @override
  State<SalesExpensesPage> createState() => _SalesExpensesPageState();
}

class _SalesExpensesPageState extends State<SalesExpensesPage> {
  final List<Map<String, dynamic>> _transactions = [];
  String _selectedFilter = "All Time";
  bool _showChart = false; // ✅ hide chart by default

  @override
  Widget build(BuildContext context) {
    double totalSales = _transactions
        .where((t) => t['type'] == 'Sale')
        .fold(0.0, (sum, t) => sum + t['amount']);

    double totalExpenses = _transactions
        .where((t) => t['type'] == 'Expense')
        .fold(0.0, (sum, t) => sum + t['amount']);

    double netProfit = totalSales - totalExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales & Expenses",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterOptions(context),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white), // ⋮ menu
            onSelected: (value) {
              if (value == 'pdf') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Exporting as PDF...")),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pdf',
                child: Text("Export as PDF"),
              ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          // ✅ Summary cards
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryCard("Sales", totalSales, Colors.green),
                _buildSummaryCard("Expenses", totalExpenses, Colors.red),
                _buildSummaryCard("Profit", netProfit, Colors.blue),
              ],
            ),
          ),

          // ✅ Toggle Chart Button
          TextButton(
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            },
            child: Text(
              _showChart ? "Hide Chart" : "Show Chart",
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),

          // ✅ Donut Chart (with values + percentages)
          if (_showChart)
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 50,
                  sectionsSpace: 2,
                  sections: _buildChartSections(totalSales, totalExpenses),
                ),
              ),
            ),

          // ✅ Transactions List
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final tx = _transactions[index];
                return ListTile(
                  leading: Icon(
                    tx['type'] == 'Sale'
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: tx['type'] == 'Sale' ? Colors.green : Colors.red,
                  ),
                  title: Text("${tx['type']} - \$${tx['amount']}"),
                  subtitle: Text(
                    "${tx['item']} • ${DateFormat('yyyy-MM-dd').format(tx['date'])}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _transactions.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddTransactionDialog(context),
      ),
    );
  }

  // ✅ Chart Sections with % and values
  List<PieChartSectionData> _buildChartSections(double sales, double expenses) {
    final double total = sales + expenses;

    if (total == 0) {
      return [
        PieChartSectionData(
          value: 1,
          color: Colors.grey[300],
          title: "No Data",
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ];
    }

    return [
      PieChartSectionData(
        value: sales,
        color: Colors.green,
        radius: 60,
        title:
        "Sales\n₦${sales.toStringAsFixed(0)}\n${((sales / total) * 100).toStringAsFixed(1)}%",
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: expenses,
        color: Colors.red,
        radius: 60,
        title:
        "Expenses\n₦${expenses.toStringAsFixed(0)}\n${((expenses / total) * 100).toStringAsFixed(1)}%",
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  // Summary card
  Widget _buildSummaryCard(String title, double value, Color color) {
    return Card(
      elevation: 3,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title,
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("\$${value.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Filter Options
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
            ListTile(
              title: const Text("Custom Range"),
              onTap: () async {
                Navigator.pop(context);
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Custom range: ${picked.start} - ${picked.end}")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterTile(String option) {
    return ListTile(
      title: Text(option),
      trailing: _selectedFilter == option
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () {
        setState(() {
          _selectedFilter = option;
        });
        Navigator.pop(context);
      },
    );
  }

  // Add transaction dialog
  void _showAddTransactionDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController itemController = TextEditingController();
    String type = "Sale";
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add Transaction"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: type,
                    items: const [
                      DropdownMenuItem(value: "Sale", child: Text("Sale")),
                      DropdownMenuItem(
                          value: "Expense", child: Text("Expense")),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        type = value!;
                      });
                    },
                  ),
                  TextField(
                    controller: itemController,
                    decoration:
                    const InputDecoration(labelText: "Item/Description"),
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Amount"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setDialogState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text(
                      "Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () {
                    setState(() {
                      _transactions.add({
                        "type": type,
                        "item": itemController.text,
                        "amount": double.tryParse(amountController.text) ?? 0.0,
                        "date": selectedDate,
                      });
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
