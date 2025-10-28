import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:potatoleaf_detector/models/history_model.dart';
import 'package:potatoleaf_detector/models/disease_model.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/batch_selection_widget.dart';
import './widgets/diagnosis_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/search_filter_widget.dart';

class DiagnosisHistory extends StatefulWidget {
  const DiagnosisHistory({Key? key}) : super(key: key);

  @override
  State<DiagnosisHistory> createState() => _DiagnosisHistoryState();
}

class _DiagnosisHistoryState extends State<DiagnosisHistory> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allDiagnoses = [];
  List<Map<String, dynamic>> _filteredDiagnoses = [];
  Map<String, dynamic> _activeFilters = {};
  Set<int> _selectedDiagnoses = {};
  bool _isMultiSelect = false;
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // void _loadMockData() {
  //   _allDiagnoses = [
  //     {
  //       "id": 1,
  //       "diseaseName": "Early Blight",
  //       "confidence": 0.92,
  //       "imageUrl":
  //           "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=800",
  //       "date": DateTime.now().subtract(Duration(hours: 2)),
  //       "severity": "High",
  //       "treatmentStatus": "Pending",
  //       "symptoms": [
  //         "Dark spots on leaves",
  //         "Yellowing around spots",
  //         "Leaf drop"
  //       ],
  //       "location": "Field A, Section 3"
  //     },
  //     {
  //       "id": 2,
  //       "diseaseName": "Late Blight",
  //       "confidence": 0.87,
  //       "imageUrl":
  //           "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=800",
  //       "date": DateTime.now().subtract(Duration(days: 1)),
  //       "severity": "High",
  //       "treatmentStatus": "In Progress",
  //       "symptoms": [
  //         "Water-soaked lesions",
  //         "White fuzzy growth",
  //         "Rapid spread"
  //       ],
  //       "location": "Field B, Section 1"
  //     },
  //     {
  //       "id": 3,
  //       "diseaseName": "Healthy",
  //       "confidence": 0.95,
  //       "imageUrl":
  //           "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=800",
  //       "date": DateTime.now().subtract(Duration(days: 2)),
  //       "severity": "Low",
  //       "treatmentStatus": "Completed",
  //       "symptoms": [
  //         "No visible symptoms",
  //         "Healthy green color",
  //         "Normal growth"
  //       ],
  //       "location": "Field C, Section 2"
  //     },
  //     {
  //       "id": 4,
  //       "diseaseName": "Bacterial Wilt",
  //       "confidence": 0.78,
  //       "imageUrl":
  //           "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=800",
  //       "date": DateTime.now().subtract(Duration(days: 3)),
  //       "severity": "Medium",
  //       "treatmentStatus": "Pending",
  //       "symptoms": [
  //         "Wilting leaves",
  //         "Brown vascular tissue",
  //         "Stunted growth"
  //       ],
  //       "location": "Field A, Section 1"
  //     },
  //     {
  //       "id": 6,
  //       "diseaseName": "Early Blight",
  //       "confidence": 0.84,
  //       "imageUrl":
  //           "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=800",
  //       "date": DateTime.now().subtract(Duration(days: 5)),
  //       "severity": "Medium",
  //       "treatmentStatus": "Completed",
  //       "symptoms": [
  //         "Concentric rings on leaves",
  //         "Target-like spots",
  //         "Defoliation"
  //       ],
  //       "location": "Field D, Section 4"
  //     },
  //       {
  //       "id": 7,
  //       "diseaseName": "Early Blight",
  //       "confidence": 0.84,
  //       "imageUrl":
  //           "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=800",
  //       "date": DateTime.now().subtract(Duration(days: 5)),
  //       "severity": "Medium",
  //       "treatmentStatus": "Completed",
  //       "symptoms": [
  //         "Concentric rings on leaves",
  //         "Target-like spots",
  //         "Defoliation"
  //       ],
  //       "location": "Field D, Section 4"
  //     },
  //     {
  //       "id": 8,
  //       "diseaseName": "Late Blight",
  //       "confidence": 0.89,
  //       "imageUrl":
  //           "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=800",
  //       "date": DateTime.now().subtract(Duration(days: 7)),
  //       "severity": "High",
  //       "treatmentStatus": "In Progress",
  //       "symptoms": [
  //         "Dark lesions on leaves",
  //         "Fuzzy white growth",
  //         "Rapid spread"
  //       ],
  //       "location": "Field E, Section 2"
  //     },
  //       {
  //       "id": 9,
  //       "diseaseName": "Early Blight",
  //       "confidence": 0.84,
  //       "imageUrl":
  //           "https://images.pexels.com/photos/1459505/pexels-photo-1459505.jpeg?auto=compress&cs=tinysrgb&w=800",
  //       "date": DateTime.now().subtract(Duration(days: 5)),
  //       "severity": "Medium",
  //       "treatmentStatus": "Completed",
  //       "symptoms": [
  //         "Concentric rings on leaves",
  //         "Target-like spots",
  //         "Defoliation"
  //       ],
  //       "location": "Field D, Section 4"
  //     },
  //   ];

  //   _filteredDiagnoses = List.from(_allDiagnoses);
  //   setState(() {});
  // }
  void _loadMockData() async {
    final boxHistory = Hive.box<HistoryModel>('historyBox');
    final boxDisease = Hive.box<DiseaseModel>('diseaseBox');

    final dataList =
        boxHistory.values.toList().reversed.toList(); // terbaru diatas
    print('ISI BOX HIVE: ${boxHistory.values.length}');
    print(boxHistory.values.toList());

    _allDiagnoses = dataList.map((e) {
      final disease =
          e.diseaseKey != null ? boxDisease.get(e.diseaseKey) : null;

      return {
        "id": e.id,
        "diseaseName": disease?.name ?? e.diseaseName ?? 'Success',
        "confidence": (e.confidence ?? 0.0).toDouble(),
        "imageUrl": e.imagePath ?? '',
        "date": e.date,
        "diseaseDetails": disease, // pass full object jika perlu
        // ensure keys used by search/filters always exist
        "symptoms": disease != null
            ? (disease.treatments ?? <String>[]) // fallback
            : <String>[],
        "severity": (() {
          // Try known property first, then attempt a dynamic toMap call if present, otherwise fallback.
          try {
            final s = (e as dynamic).severity;
            if (s != null) return s;
          } catch (_) {}
          try {
            final map = (e as dynamic).toMap?.call();
            if (map != null && map['severity'] != null) return map['severity'];
          } catch (_) {}
          return 'Success';
        })(),
        "treatmentStatus": 'Sueccess', // Placeholder, replace with actual if available
      };
    }).toList();

    _filteredDiagnoses = List.from(_allDiagnoses);
    setState(() {});
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFiltersAndSearch();
    });
  }

  void _applyFiltersAndSearch() {
    List<Map<String, dynamic>> filtered = List.from(_allDiagnoses);

    // Apply search filter (safe access)
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((diagnosis) {
        final diseaseName =
            (diagnosis['diseaseName'] as String? ?? '').toLowerCase();

        final symptomsObj = diagnosis['symptoms'];
        final symptoms = (symptomsObj is List)
            ? symptomsObj.join(' ').toLowerCase()
            : (symptomsObj?.toString().toLowerCase() ?? '');

        return diseaseName.contains(query) || symptoms.contains(query);
      }).toList();
    }

    // Apply date range filter (safe)
    if (_activeFilters['dateRange'] != null) {
      final DateTimeRange range = _activeFilters['dateRange'] as DateTimeRange;
      filtered = filtered.where((diagnosis) {
        final date = diagnosis['date'] as DateTime?;
        if (date == null) return false;
        // inclusive check
        return !date.isBefore(range.start) && !date.isAfter(range.end);
      }).toList();
    }

    // Apply disease type filter
    if (_activeFilters['diseaseTypes'] != null &&
        (_activeFilters['diseaseTypes'] as List).isNotEmpty) {
      final List<String> types =
          (_activeFilters['diseaseTypes'] as List).cast<String>();
      filtered = filtered.where((diagnosis) {
        return types.contains(diagnosis['diseaseName']);
      }).toList();
    }

    // Apply confidence filter (safe)
    if (_activeFilters['minConfidence'] != null) {
      final double minConfidence = _activeFilters['minConfidence'] as double;
      filtered = filtered.where((diagnosis) {
        final conf = (diagnosis['confidence'] as num?)?.toDouble() ?? 0.0;
        return conf >= minConfidence;
      }).toList();
    }

    // Apply treatment status filter
    if (_activeFilters['treatmentStatuses'] != null &&
        (_activeFilters['treatmentStatuses'] as List).isNotEmpty) {
      final List<String> statuses =
          (_activeFilters['treatmentStatuses'] as List).cast<String>();
      filtered = filtered.where((diagnosis) {
        final status = (diagnosis['treatmentStatus'] as String?) ?? 'Success';
        return statuses.contains(status);
      }).toList();
    }

    setState(() {
      _filteredDiagnoses = filtered;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
            _applyFiltersAndSearch();
          });
        },
      ),
    );
  }

  void _onDiagnosisCardTap(Map<String, dynamic> diagnosis) {
    if (_isMultiSelect) {
      _toggleDiagnosisSelection(diagnosis['id']);
    } else {
      Navigator.pushNamed(context, '/disease-analysis-results', arguments: {
        'imagePath': diagnosis['imageUrl'], // Ambil dari Hive/history
        'diseaseName': diagnosis['diseaseName'],
        'confidence': diagnosis['confidence'],
        // ...tambahkan field lain jika perlu
      });
    }
  }

  void _onDiagnosisCardLongPress(Map<String, dynamic> diagnosis) {
    if (!_isMultiSelect) {
      setState(() {
        _isMultiSelect = true;
        _selectedDiagnoses.add(diagnosis['id']);
      });
    }
  }

  void _toggleDiagnosisSelection(int id) {
    setState(() {
      if (_selectedDiagnoses.contains(id)) {
        _selectedDiagnoses.remove(id);
        if (_selectedDiagnoses.isEmpty) {
          _isMultiSelect = false;
        }
      } else {
        _selectedDiagnoses.add(id);
        _isMultiSelect = true;
      }
    });
  }

  void _cancelMultiSelect() {
    setState(() {
      _isMultiSelect = false;
      _selectedDiagnoses.clear();
    });
  }

  void _selectAllDiagnoses() {
    setState(() {
      _selectedDiagnoses =
          _filteredDiagnoses.map((d) => d['id'] as int).toSet();
    });
  }

  void _exportSelectedDiagnoses() {
    // Export functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting ${_selectedDiagnoses.length} diagnoses...'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
    _cancelMultiSelect();
  }

  Future<void> _deleteSelected() async {
    final box = Hive.box<HistoryModel>('historyBox');
    for (final id in _selectedDiagnoses.toList()) {
      final keyToDelete = box.keys.firstWhere(
        (k) => box.get(k)?.id == id,
        orElse: () => null,
      );
      if (keyToDelete != null) {
        final imagePath = box.get(keyToDelete)?.imagePath;
        await box.delete(keyToDelete);
        if (imagePath != null && imagePath.isNotEmpty) {
          try {
            final f = File(imagePath);
            if (await f.exists()) await f.delete();
          } catch (_) {}
        }
      }
    }
    setState(() {
      _selectedDiagnoses.clear();
      _isMultiSelect = false;
      _loadMockData(); // re-load list from Hive
      _applyFiltersAndSearch(); // re-apply active filters/search after reload
    });
  }

  void _deleteSelectedDiagnoses() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Diagnoses'),
        content: Text(
            'Are you sure you want to delete ${_selectedDiagnoses.length} selected diagnoses? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final box = Hive.box<HistoryModel>('historyBox');
              for (final id in _selectedDiagnoses) {
                final keyToDelete = box.keys.firstWhere(
                  (k) => box.get(k)?.id == id,
                  orElse: () => null,
                );

                if (keyToDelete != null) {
                  // Ambil path sebelum delete
                  final imagePath = box.get(keyToDelete)?.imagePath;
                  // Hapus entry di Hive
                  await box.delete(keyToDelete);
                  // Hapus file gambar dari storage (jika ada)
                  if (imagePath != null && imagePath.isNotEmpty) {
                    try {
                      final file = File(imagePath);
                      if (await file.exists()) {
                        await file.delete();
                      }
                    } catch (_) {
                      // ignore file delete error
                    }
                  }
                }
              }

              setState(() {
                _allDiagnoses
                    .removeWhere((d) => _selectedDiagnoses.contains(d['id']));
                _applyFiltersAndSearch();
                _cancelMultiSelect();
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selected diagnoses deleted'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _shareDiagnosis(Map<String, dynamic> diagnosis) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing diagnosis: ${diagnosis['diseaseName']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _deleteDiagnosis(Map<String, dynamic> diagnosis) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Diagnosis'),
        content: Text('Are you sure you want to delete this diagnosis?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final box = Hive.box<HistoryModel>('historyBox');
              final keyToDelete = box.keys.firstWhere(
                (k) => box.get(k)?.id == diagnosis['id'],
                orElse: () => null,
              );
              if (keyToDelete != null) {
                // Hapus file gambar dari storage
                final imagePath = box.get(keyToDelete)?.imagePath;
                if (imagePath != null && imagePath.isNotEmpty) {
                  final file = File(imagePath);
                  if (await file.exists()) {
                    await file.delete();
                  }
                }
                await box.delete(keyToDelete);
              }
              setState(() {
                _allDiagnoses.removeWhere((d) => d['id'] == diagnosis['id']);
                _applyFiltersAndSearch();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Diagnosis deleted successfully'),
                  backgroundColor: AppTheme.getSuccessColor(true),
                ),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _archiveDiagnosis(Map<String, dynamic> diagnosis) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Diagnosis archived: ${diagnosis['diseaseName']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  Future<void> _refreshDiagnoses() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // In a real app, this would fetch fresh data from the server
    _loadMockData();

    setState(() {
      _isLoading = false;
    });
  }

  // helper: cari key Hive untuk history.id dengan aman
  int? _findHistoryKeyById(int id) {
    final box = Hive.box<HistoryModel>('historyBox');
    for (final k in box.keys) {
      final item = box.get(k);
      if (item != null && item.id == id) return k as int;
    }
    return null;
  }

  // Ganti implementasi _buildHistoryList agar memakai _filteredDiagnoses
  Widget _buildHistoryList() {
    // gunakan filtered list (search + filters sudah diaplikasikan ke _filteredDiagnoses)
    return ListView.builder(
      controller: _scrollController,
      itemCount: _filteredDiagnoses.length,
      itemBuilder: (context, index) {
        final item = _filteredDiagnoses[index];
        return DiagnosisCardWidget(
          diagnosis: item,
          onTap: () => _onDiagnosisCardTap(item),
          onLongPress: () => _onDiagnosisCardLongPress(item),
          onShare: () => _shareDiagnosis(item),
          onArchive: () => _archiveDiagnosis(item),
          onDelete: () async {
            final int? keyToDelete = _findHistoryKeyById(item['id'] as int);
            if (keyToDelete != null) {
              final box = Hive.box<HistoryModel>('historyBox');
              final imagePath = box.get(keyToDelete)?.imagePath;
              await box.delete(keyToDelete);
              if (imagePath != null && imagePath.isNotEmpty) {
                try {
                  final f = File(imagePath);
                  if (await f.exists()) await f.delete();
                } catch (_) {}
              }
              // reload data and reapply filters/search
              _loadMockData();
              _applyFiltersAndSearch();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _isMultiSelect
          ? AppBar(
              title: Text('${_selectedDiagnoses.length} selected'),
              backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
              foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
              elevation: AppTheme.lightTheme.appBarTheme.elevation,
              actions: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Delete selected'),
                        content:
                            Text('Delete ${_selectedDiagnoses.length} items?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Cancel')),
                          TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Delete')),
                        ],
                      ),
                    );
                    if (confirm == true) await _deleteSelected();
                  },
                ),
              ],
            )
          : AppBar(
              title: Text('Diagnosis History'),
              backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
              foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
              elevation: AppTheme.lightTheme.appBarTheme.elevation,
              actions: [
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/camera-capture-screen'),
                  icon: CustomIconWidget(
                    iconName: 'camera_alt',
                    color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
                    size: 6.w,
                  ),
                ),
              ],
            ),
      body: Column(
        children: [
          if (_isMultiSelect)
            BatchSelectionWidget(
              selectedCount: _selectedDiagnoses.length,
              onCancel: _cancelMultiSelect,
              onExport: _exportSelectedDiagnoses,
              onDelete: _deleteSelectedDiagnoses,
              onSelectAll: _selectAllDiagnoses,
            )
          else
            SearchFilterWidget(
              onSearchChanged: _onSearchChanged,
              onFilterTap: _showFilterBottomSheet,
              hasActiveFilters: _activeFilters.isNotEmpty,
            ),
          Expanded(
            child: _filteredDiagnoses.isEmpty
                ? _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                    ? _buildNoResultsWidget()
                    : EmptyStateWidget(
                        onCapturePressed: () => Navigator.pushNamed(
                            context, '/camera-capture-screen'),
                      )
                : RefreshIndicator(
                    onRefresh: _refreshDiagnoses,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: _buildHistoryList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 15.w,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Results Found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search or filters to find what you\'re looking for.',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _activeFilters.clear();
                  _searchController.clear();
                  _applyFiltersAndSearch();
                });
              },
              child: Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Removed erroneous standalone build function that referenced undefined 'diagnosis'.
