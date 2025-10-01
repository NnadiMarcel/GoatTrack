import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'HealthPage.dart';
import 'PregnancyPage.dart';
import 'VaccinationPage.dart';
import 'AddGoatPage.dart';

class GoatDetailsPage extends StatefulWidget {
  final Map<String, dynamic> goat;

  const GoatDetailsPage({super.key, required this.goat});

  @override
  State<GoatDetailsPage> createState() => _GoatDetailsPageState();
}

class _GoatDetailsPageState extends State<GoatDetailsPage> {
  late Map<String, dynamic> goat;

  @override
  void initState() {
    super.initState();
    goat = Map<String, dynamic>.from(widget.goat);
  }

  /// Pick image either from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 75);

    if (pickedFile != null) {
      setState(() {
        goat['image'] = pickedFile.path;
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Picture"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Calculate Age
  String calculateAge(DateTime dob) {
    final today = DateTime.now();
    final difference = today.difference(dob);

    if (difference.inDays < 30) {
      final days = difference.inDays;
      return "$days ${days == 1 ? 'day' : 'days'} old";
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return "$months ${months == 1 ? 'month' : 'months'} old";
    } else {
      final years = (difference.inDays / 365).floor();
      return "$years ${years == 1 ? 'year' : 'years'} old";
    }
  }

  String _formatDate(dynamic date) {
    if (date is DateTime) {
      return DateFormat('dd MMM yyyy').format(date);
    }
    return date?.toString() ?? "Not provided";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ✅ Pass back updated goat when leaving
        Navigator.pop(context, goat);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Goat Details"),
          backgroundColor: Colors.green[700],
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddGoatPage(existingGoat: goat),
                    ),
                  );

                  if (updated != null && mounted) {
                    // ✅ Update locally only, stay on page
                    setState(() {
                      goat = Map<String, dynamic>.from(updated as Map);
                    });
                  }
                } else if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Goat"),
                      content: const Text(
                          "Are you sure you want to delete this goat?"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        TextButton(
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && mounted) {
                    // ✅ Tell record page to delete
                    Navigator.pop(context, {'deleted': true, 'id': goat['id']});
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 8),
                      Text("Edit Goat"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text("Delete Goat"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Goat Image OR Camera Placeholder
              Center(
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: ClipOval(
                    child: goat['image'] != null
                        ? Image.file(
                      File(goat['image']),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      height: 150,
                      width: 150,
                      color: Colors.brown[100],
                      child: const Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Basic Information Section (ONE card)
              Text("Detail Information", style: _titleStyle()),
              const SizedBox(height: 10),

              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      _buildInfoRow("ID", goat['id'] ?? "Unknown"),
                      _buildInfoRow("Breed", goat['breed'] ?? "Unknown"),
                      _buildInfoRow("Gender", goat['gender'] ?? "Unknown"),
                      _buildInfoRow(
                        "Age",
                        goat['dob'] != null
                            ? calculateAge(goat['dob'])
                            : "Unknown",
                      ),
                      _buildInfoRow("Date of Birth", _formatDate(goat['dob'])),
                      _buildInfoRow("Joined on",
                          _formatDate(goat['dateOfEntry'] ?? goat['entryDate'])),
                      _buildInfoRow("Obtained",
                          goat['obtainedMethod'] ?? "Not specified"),
                      _buildInfoRow(
                          "Mother’s Tag", goat['motherTag'] ?? "Not provided"),
                      _buildInfoRow(
                          "Father’s Tag", goat['fatherTag'] ?? "Not provided"),
                      _buildInfoRow("Notes", goat['notes'] ?? "No notes"),
                    ],
                  ),
                ),
              ),

              const Divider(height: 30, thickness: 1),

              // Pregnancy section (only if female)
              if (goat['gender'] == "Female") ...[
                Text(
                  "Pregnancy Status: ${goat['pregnant'] ?? goat['pregnancy'] ?? "Not provided"}",
                  style: _textStyle(),
                ),
                const SizedBox(height: 5),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PregnancyPage(goat: goat)),
                    );
                  },
                  icon: const Icon(Icons.pregnant_woman),
                  label: const Text("Update Pregnancy Info"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300]),
                ),
                const Divider(height: 30, thickness: 1),
              ],

              // Health section
              Text("Health Status: ${goat['healthStatus'] ?? "Unknown"}",
                  style: _textStyle()),
              if (goat['health'] == "Sick")
                Text("Sickness Info: ${goat['sicknessInfo'] ?? "No details"}",
                    style: _textStyle()),
              const SizedBox(height: 5),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HealthPage(goat: goat)));
                },
                icon: const Icon(Icons.local_hospital),
                label: const Text("Update Health Info"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
              ),

              const Divider(height: 30, thickness: 1),

              // Vaccination section
              Text("Vaccination: ${goat['vaccination'] ?? "Not provided"}",
                  style: _textStyle()),
              if (goat['vaccinationDetails'] != null)
                Text("Details: ${goat['vaccinationDetails']}",
                    style: _textStyle()),
              const SizedBox(height: 5),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VaccinationPage(goat: goat)));
                },
                icon: const Icon(Icons.vaccines),
                label: const Text("Update Vaccination Info"),
                style:
                ElevatedButton.styleFrom(backgroundColor: Colors.blue[400]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper row inside the card
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.brown,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _titleStyle() => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  TextStyle _textStyle() => const TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );
}
