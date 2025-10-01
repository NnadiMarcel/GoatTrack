// VaccinationPage.dart
import 'package:flutter/material.dart';

class VaccinationPage extends StatelessWidget {
  final Map<String, dynamic> goat;

  const VaccinationPage({super.key, required this.goat});

  @override
  Widget build(BuildContext context) {
    final id = goat['id']?.toString() ?? 'Unknown';
    final vacc = goat['vaccination']?.toString() ?? 'Not provided';
    final vaccDetails = goat['vaccinationDetails']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Vaccination - $id'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Vaccination: $vacc', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          if (vaccDetails.isNotEmpty) ...[
            const Text('Details:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(vaccDetails),
          ] else
            const Text('No vaccination details provided.'),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[400]),
            onPressed: () {
              // TODO: open vaccination update form
              Navigator.pop(context);
            },
            icon: const Icon(Icons.vaccines),
            label: const Text('Edit Vaccination Info'),
          ),
        ]),
      ),
    );
  }
}
