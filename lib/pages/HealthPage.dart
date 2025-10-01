// HealthPage.dart
import 'package:flutter/material.dart';

class HealthPage extends StatelessWidget {
  final Map<String, dynamic> goat; // accept dynamic map

  const HealthPage({super.key, required this.goat});

  @override
  Widget build(BuildContext context) {
    final id = goat['id']?.toString() ?? 'Unknown';
    final health = goat['health']?.toString() ?? 'Unknown';
    final sicknessInfo = goat['sicknessInfo']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Health - $id'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Health Status: $health', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          if (sicknessInfo.isNotEmpty) ...[
            const Text('Sickness details:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(sicknessInfo),
          ] else
            const Text('No sickness details provided.'),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
            onPressed: () {
              // TODO: open a form to update health (save to DB/backend)
              Navigator.pop(context);
            },
            child: const Text('Edit Health Info'),
          ),
        ]),
      ),
    );
  }
}
