// PregnancyPage.dart
import 'package:flutter/material.dart';

class PregnancyPage extends StatelessWidget {
  final Map<String, dynamic> goat;

  const PregnancyPage({super.key, required this.goat});

  @override
  Widget build(BuildContext context) {
    final id = goat['id']?.toString() ?? 'Unknown';
    final pregnant = (goat['pregnant'] ?? goat['pregnancy'])?.toString() ?? 'Not provided';
    final pregnancyDetails = goat['pregnancyDetails']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Pregnancy - $id'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Pregnancy Status: $pregnant', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          if (pregnancyDetails.isNotEmpty) ...[
            const Text('Pregnancy details:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(pregnancyDetails),
          ] else
            const Text('No pregnancy details provided.'),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[300]),
            onPressed: () {
              // TODO: navigate to a form to update pregnancy info
              Navigator.pop(context);
            },
            icon: const Icon(Icons.pregnant_woman),
            label: const Text('Edit Pregnancy Info'),
          ),
        ]),
      ),
    );
  }
}
