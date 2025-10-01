import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // ✅ for date formatting

/// Page for Adding or Editing a Goat Record
class AddGoatPage extends StatefulWidget {
  final Map<String, dynamic>? existingGoat; // 🐐 Optional goat for edit

  const AddGoatPage({super.key, this.existingGoat});

  @override
  State<AddGoatPage> createState() => _AddGoatPageState();
}

class _AddGoatPageState extends State<AddGoatPage> {
  // Controllers
  late TextEditingController idController;
  late TextEditingController motherTagController;
  late TextEditingController fatherTagController;
  late TextEditingController notesController;

  // Dropdown values
  String? selectedGender;
  String? obtainedMethod;
  String? healthStatus;
  String? selectedBreed;

  // Date values
  DateTime? entryDate;
  DateTime? dob;

  // Image picker
  File? goatImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // ✅ Pre-fill form if editing
    idController = TextEditingController(text: widget.existingGoat?['id'] ?? '');
    motherTagController = TextEditingController(text: widget.existingGoat?['motherTag'] ?? '');
    fatherTagController = TextEditingController(text: widget.existingGoat?['fatherTag'] ?? '');
    notesController = TextEditingController(text: widget.existingGoat?['notes'] ?? '');

    selectedGender = widget.existingGoat?['gender'];
    obtainedMethod = widget.existingGoat?['obtainedMethod'];
    healthStatus = widget.existingGoat?['healthStatus'];
    selectedBreed = widget.existingGoat?['breed'];

    // ✅ Parse date safely
    entryDate = _parseDate(widget.existingGoat?['dateOfEntry']);
    dob = _parseDate(widget.existingGoat?['dob']);

    if (widget.existingGoat?['image'] != null) {
      goatImage = File(widget.existingGoat!['image']);
    }
  }

  /// Helper to safely parse DateTime or return null
  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        goatImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.brown),
            title: const Text("Take Photo"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo, color: Colors.brown),
            title: const Text("Choose from Gallery"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Widget buildDropdown({
    required String? value,
    required String hint,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return DropdownButton<String>(
      isExpanded: true,
      value: value,
      hint: Text(hint, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      items: [
        DropdownMenuItem<String>(
          value: null,
          enabled: false,
          child: Text(hint, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ),
        ...options.map(
              (option) => DropdownMenuItem(
            value: option,
            child: Text(option, style: const TextStyle(fontSize: 16)),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingGoat != null;
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Goat" : "New Goat"),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🐐 Goat Image Picker
            Center(
              child: InkWell(
                onTap: _showImageSourceDialog,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.brown[100],
                  backgroundImage: goatImage != null ? FileImage(goatImage!) : null,
                  child: goatImage == null
                      ? const Icon(Icons.add_a_photo, size: 40, color: Colors.brown)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🐐 Goat ID
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: "Goat Tag No *"),
            ),
            const SizedBox(height: 16),

            // 🔻 Breed Dropdown
            buildDropdown(
              value: selectedBreed,
              hint: "Breed",
              options: ["Boer", "Kalahari Red", "Nubian", "Saanen", "Alpine", "Toggenburg", "Pygmy", "Other"],
              onChanged: (v) => setState(() => selectedBreed = v),
            ),
            const SizedBox(height: 16),

            // 📅 Date of Birth Picker
            Row(
              children: [
                Expanded(
                  child: Text(
                    dob == null ? "Date of Birth (DOB)" : "DOB: ${dateFormat.format(dob!)}",
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: dob ?? DateTime(2022),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => dob = picked);
                  },
                  child: const Text("Select DOB", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 🗓 Date of Entry
            Row(
              children: [
                Expanded(
                  child: Text(
                    entryDate == null
                        ? "Date of Entry on Farm"
                        : "Entry Date: ${dateFormat.format(entryDate!)}",
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: entryDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => entryDate = picked);
                  },
                  child: const Text("Select Date", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 🔻 Gender Dropdown
            buildDropdown(
              value: selectedGender,
              hint: "Gender *",
              options: ["Male", "Female"],
              onChanged: (v) => setState(() => selectedGender = v),
            ),
            const SizedBox(height: 16),

            // 🔻 How Obtained Dropdown
            buildDropdown(
              value: obtainedMethod,
              hint: "How Obtained *",
              options: ["Born on Farm", "Purchased"],
              onChanged: (v) => setState(() => obtainedMethod = v),
            ),
            const SizedBox(height: 16),

            // 🔻 Health Dropdown
            buildDropdown(
              value: healthStatus,
              hint: "Health Status",
              options: ["Healthy", "Sick", "Under Treatment"],
              onChanged: (v) => setState(() => healthStatus = v),
            ),
            const SizedBox(height: 16),

            // 🐐 Mother's Tag
            TextField(
              controller: motherTagController,
              decoration: const InputDecoration(labelText: "Mother's Tag No"),
            ),
            const SizedBox(height: 16),

            // 🐐 Father's Tag
            TextField(
              controller: fatherTagController,
              decoration: const InputDecoration(labelText: "Father's Tag No"),
            ),
            const SizedBox(height: 16),

            // 📝 Notes
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: "Notes"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // ✅ Save Record Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                onPressed: () {
                  if (idController.text.isEmpty || selectedGender == null || obtainedMethod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill in required fields")),
                    );
                    return;
                  }

                  final goatData = {
                    "id": idController.text,
                    "breed": selectedBreed,
                    "gender": selectedGender!,
                    "dob": dob,
                    "pregnant": selectedGender == "Female" ? "No" : "N/A",
                    "dateOfEntry": entryDate,
                    "obtainedMethod": obtainedMethod!,
                    "healthStatus": healthStatus,
                    "motherTag": motherTagController.text,
                    "fatherTag": fatherTagController.text,
                    "notes": notesController.text,
                    "image": goatImage?.path,
                  };

                  Navigator.pop(context, goatData);
                },
                child: Text(
                  isEditing ? "Update Record" : "Save Record",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
