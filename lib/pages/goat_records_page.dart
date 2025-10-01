// GoatRecordsPage.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'GoatDetailsPage.dart';
import 'AddGoatPage.dart';

class GoatRecordsPage extends StatefulWidget {
  const GoatRecordsPage({super.key});

  @override
  State<GoatRecordsPage> createState() => _GoatRecordsPageState();
}

class _GoatRecordsPageState extends State<GoatRecordsPage> {
  List<Map<String, dynamic>> goatRecords = [];
  final Set<int> _selectedIndexes = {};

  String searchQuery = "";
  String _selectedFilter = "All Time";
  DateTimeRange? customRange;

  // Category filters
  String _selectedGender = "All";
  String _selectedAgeGroup = "All";
  String _selectedBreed = "All";

  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

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

  /// Handle the result returned from GoatDetailsPage.
  /// - If result is a deletion signal (`{'deleted': true, 'id': ...}`) -> remove the goat.
  /// - If result is an updated goat map -> replace the original record.
  void _handleDetailsResult(dynamic result, String? originalId) {
    if (result == null) return;

    if (result is Map<String, dynamic> && result['deleted'] == true) {
      final idToRemove = result['id']?.toString() ?? originalId;
      if (idToRemove == null) return;
      setState(() {
        goatRecords.removeWhere((g) => g['id']?.toString() == idToRemove);
      });
      return;
    }

    // If result looks like an updated goat map (no deleted flag), update record
    if (result is Map<String, dynamic>) {
      final idx = goatRecords.indexWhere((g) => g['id']?.toString() == originalId);
      if (idx != -1) {
        setState(() {
          goatRecords[idx] = result;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Build filteredRecords with null-safe date handling
    final filteredRecords = goatRecords.where((goat) {
      // read date safely (it might be DateTime, String, or null)
      final rawDate = goat['dateOfEntry'] ?? goat['entryDate'];
      DateTime? date;
      if (rawDate is DateTime) {
        date = rawDate;
      } else if (rawDate is String) {
        date = DateTime.tryParse(rawDate);
      } else {
        date = null;
      }

      bool dateMatch = true;
      if (date != null) {
        if (_selectedFilter == "Last 7 Days") {
          dateMatch = date.isAfter(now.subtract(const Duration(days: 7)));
        } else if (_selectedFilter == "Current Month") {
          dateMatch = date.month == now.month && date.year == now.year;
        } else if (_selectedFilter == "Last 3 Months") {
          final start = DateTime(now.year, now.month - 2, 1);
          dateMatch = date.isAfter(start);
        } else if (_selectedFilter == "Last 6 Months") {
          final start = DateTime(now.year, now.month - 5, 1);
          dateMatch = date.isAfter(start);
        } else if (_selectedFilter == "Current Year") {
          dateMatch = date.year == now.year;
        } else if (_selectedFilter == "Previous Year") {
          dateMatch = date.year == now.year - 1;
        } else if (_selectedFilter == "Custom Range") {
          if (customRange != null) {
            dateMatch = date.isAfter(customRange!.start.subtract(const Duration(days: 1))) &&
                date.isBefore(customRange!.end.add(const Duration(days: 1)));
          } else {
            dateMatch = true;
          }
        } else {
          dateMatch = true;
        }
      } else {
        // If there's no date, treat as matching (prevents cast errors and keeps records visible).
        dateMatch = true;
      }

      // Category filters (gender, age group, breed)
      bool categoryMatch = true;
      if (_selectedGender != "All") {
        categoryMatch = categoryMatch && (goat['gender'] == _selectedGender);
      }

      if (_selectedAgeGroup != "All") {
        final dobRaw = goat['dob'];
        DateTime? dob;
        if (dobRaw is DateTime) dob = dobRaw;
        else if (dobRaw is String) dob = DateTime.tryParse(dobRaw);

        final ageText = dob != null ? calculateAge(dob) : "";
        if (_selectedAgeGroup == "Kids") {
          categoryMatch = categoryMatch && (ageText.contains("month") || ageText.contains("day"));
        } else if (_selectedAgeGroup == "Adults") {
          categoryMatch = categoryMatch && ageText.contains("year");
        }
      }

      if (_selectedBreed != "All") {
        final breed = goat['breed']?.toString() ?? "";
        categoryMatch = categoryMatch && (breed == _selectedBreed);
      }

      // Search
      final idText = (goat['id']?.toString() ?? "").toLowerCase();
      final breedText = (goat['breed']?.toString() ?? "").toLowerCase();
      final q = searchQuery.toLowerCase();
      final matchesSearch = idText.contains(q) || breedText.contains(q);

      return matchesSearch && dateMatch && categoryMatch;
    }).toList();

    // Build breeds list for filter dropdown (unique breeds + "All")
    final breeds = [
      "All",
      ...{for (var g in goatRecords) (g['breed']?.toString() ?? "")}
    ]..removeWhere((b) => b.isEmpty);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: _selectedIndexes.isEmpty
            ? !isSearching
            ? const Text(
          "Goat Records",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        )
            : TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search by Tag or Breed...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => searchQuery = value),
        )
            : Text(
          "${_selectedIndexes.length} selected",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          if (_selectedIndexes.isEmpty) ...[
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    searchQuery = "";
                    _searchController.clear();
                  }
                  isSearching = !isSearching;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () => _showFilterOptions(context, breeds),
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _confirmMultiDelete,
            ),
          ]
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: filteredRecords.isEmpty
                ? const Center(child: Text("No records found"))
                : ListView.builder(
              itemCount: filteredRecords.length,
              itemBuilder: (context, index) {
                final goat = filteredRecords[index];

                // compute display-safe strings for DOB/Entry Date/age
                final dobRaw = goat['dob'];
                DateTime? dob;
                if (dobRaw is DateTime) dob = dobRaw;
                else if (dobRaw is String) dob = DateTime.tryParse(dobRaw);

                final ageDisplay = dob != null ? calculateAge(dob) : "Unknown";

                final rawEntry = goat['dateOfEntry'] ?? goat['entryDate'];
                DateTime? entryDate;
                if (rawEntry is DateTime) entryDate = rawEntry;
                else if (rawEntry is String) entryDate = DateTime.tryParse(rawEntry);

                final entryDisplay = entryDate != null
                    ? DateFormat('dd MMM yyyy').format(entryDate)
                    : "Unknown";

                // find index in original list (needed for selection toggle)
                final originalIndex = goatRecords.indexWhere(
                        (g) => g['id']?.toString() == goat['id']?.toString());

                final isSelected = _selectedIndexes.contains(originalIndex);

                return GestureDetector(
                  onLongPress: () {
                    setState(() {
                      if (originalIndex >= 0) {
                        isSelected
                            ? _selectedIndexes.remove(originalIndex)
                            : _selectedIndexes.add(originalIndex);
                      }
                    });
                  },
                  onTap: () async {
                    if (_selectedIndexes.isNotEmpty) {
                      setState(() {
                        if (originalIndex >= 0) {
                          isSelected
                              ? _selectedIndexes.remove(originalIndex)
                              : _selectedIndexes.add(originalIndex);
                        }
                      });
                      return;
                    }

                    // Open details and handle returned result safely
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GoatDetailsPage(goat: goat)),
                    );

                    final originalId = goat['id']?.toString();
                    _handleDetailsResult(result, originalId);
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 3,
                    color: (originalIndex >= 0 && _selectedIndexes.contains(originalIndex))
                        ? Colors.green[50]
                        : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: ClipOval(
                        child: (goat['image'] != null)
                            ? Image.file(File(goat['image']), height: 50, width: 50, fit: BoxFit.cover)
                            : Container(
                          height: 50,
                          width: 50,
                          color: Colors.brown[100],
                          child: const Icon(Icons.camera_alt, size: 26, color: Colors.black54),
                        ),
                      ),
                      title: Text("ID: ${goat['id'] ?? ''} - ${goat['breed'] ?? ''}"),
                      subtitle: Text(
                        "Age: $ageDisplay | Entered: $entryDisplay | ${goat['gender'] ?? ''}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
                      ),
                      trailing: (originalIndex >= 0 && _selectedIndexes.contains(originalIndex)) ? null : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'view') {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => GoatDetailsPage(goat: goat)),
                                );
                                _handleDetailsResult(result, goat['id']?.toString());
                              } else if (value == 'edit') {
                                final originalId = goat['id']?.toString();
                                final editedGoat = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddGoatPage(existingGoat: goat)),
                                );
                                // editedGoat should be a full goat map; handle it
                                if (editedGoat != null && editedGoat is Map<String, dynamic>) {
                                  final idx = goatRecords.indexWhere((g) => g['id']?.toString() == originalId);
                                  if (idx != -1) setState(() => goatRecords[idx] = editedGoat);
                                }
                              } else if (value == 'delete') {
                                _confirmDelete(goat);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'view', child: Text('View Record')),
                              const PopupMenuItem(value: 'edit', child: Text('Edit Record')),
                              const PopupMenuItem(value: 'delete', child: Text('Delete')),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Flexible(
                            child: Text(
                              goat['gender']?.toString() ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700, color: Colors.brown),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        onPressed: () async {
          final newGoat = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddGoatPage()));
          if (newGoat != null && newGoat is Map<String, dynamic>) {
            setState(() => goatRecords.add(newGoat));
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> goat) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Record"),
        content: Text("Are you sure you want to delete goat ${goat['id']}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              // Return deletion info to caller (GoatDetailsPage style)
              Navigator.pop(context, true);
              // Remove directly here as well (keeps UI consistent)
              setState(() {
                goatRecords.removeWhere((g) => g['id']?.toString() == goat['id']?.toString());
              });
            },
          ),
        ],
      ),
    );
  }

  void _confirmMultiDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Selected"),
        content: Text("Are you sure you want to delete ${_selectedIndexes.length} selected records?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                final indexes = _selectedIndexes.toList()..sort((a, b) => b.compareTo(a));
                for (var idx in indexes) {
                  if (idx >= 0 && idx < goatRecords.length) goatRecords.removeAt(idx);
                }
                _selectedIndexes.clear();
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context, List<String> breeds) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(title: Text("Filters", style: TextStyle(fontWeight: FontWeight.bold))),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.calendar_month, color: Colors.green),
              title: const Text("Filter by Date"),
              onTap: () {
                Navigator.pop(context);
                _showDateFilterOptions(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Colors.green),
              title: const Text("Filter by Category"),
              onTap: () {
                Navigator.pop(context);
                _showCategoryFilterOptions(context, breeds);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDateFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            _buildFilterTile("All Time"),
            _buildFilterTile("Last 7 Days"),
            _buildFilterTile("Current Month"),
            _buildFilterTile("Last 3 Months"),
            _buildFilterTile("Last 6 Months"),
            _buildFilterTile("Current Year"),
            _buildFilterTile("Previous Year"),
            ListTile(
              title: const Text("Custom Range"),
              trailing: _selectedFilter == "Custom Range" ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () async {
                Navigator.pop(context);
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now()),
                );
                if (picked != null) {
                  setState(() {
                    _selectedFilter = "Custom Range";
                    customRange = picked;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showCategoryFilterOptions(BuildContext context, List<String> breeds) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              const Text("Filter by Category", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Divider(),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ["All", "Male", "Female"].map((gender) => DropdownMenuItem(value: gender, child: Text(gender))).toList(),
                onChanged: (value) => setState(() => _selectedGender = value!),
                decoration: const InputDecoration(labelText: "Gender"),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedAgeGroup,
                items: ["All", "Kids", "Adults"].map((age) => DropdownMenuItem(value: age, child: Text(age))).toList(),
                onChanged: (value) => setState(() => _selectedAgeGroup = value!),
                decoration: const InputDecoration(labelText: "Age Group"),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedBreed,
                items: breeds.map((breed) => DropdownMenuItem(value: breed, child: Text(breed))).toList(),
                onChanged: (value) => setState(() => _selectedBreed = value!),
                decoration: const InputDecoration(labelText: "Breed"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], foregroundColor: Colors.white),
                child: const Text("Apply Filters"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterTile(String option) {
    return ListTile(
      title: Text(option),
      trailing: _selectedFilter == option ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        setState(() => _selectedFilter = option);
        Navigator.pop(context);
      },
    );
  }
}
