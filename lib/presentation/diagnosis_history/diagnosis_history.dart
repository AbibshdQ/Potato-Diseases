import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:potatoleaf_detector/models/history_model.dart';
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
  bool _isMultiSelectMode = false;
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
    final box = Hive.box<HistoryModel>('historyBox');

    final dataList = box.values.toList().reversed.toList(); // terbaru diatas
    print('ISI BOX HIVE: ${box.values.length}');
    print(box.values.toList());

    _allDiagnoses = dataList
        .map((e) => {
              "id": e.id,
              "diseaseName": e.diseaseName,
              "confidence": e.confidence,
              "imageUrl": e.imagePath,
              "date": e.date,
              "severity": "",
              "treatmentStatus": "",
              "symptoms": [],
              "location": ""
            })
        .toList();

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

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((diagnosis) {
        final diseaseName = (diagnosis['diseaseName'] as String).toLowerCase();
        final symptoms =
            (diagnosis['symptoms'] as List).join(' ').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return diseaseName.contains(query) || symptoms.contains(query);
      }).toList();
    }

    // Apply date range filter
    if (_activeFilters['dateRange'] != null) {
      final DateTimeRange range = _activeFilters['dateRange'];
      filtered = filtered.where((diagnosis) {
        final date = diagnosis['date'] as DateTime;
        return date.isAfter(range.start.subtract(Duration(days: 1))) &&
            date.isBefore(range.end.add(Duration(days: 1)));
      }).toList();
    }

    // Apply disease type filter
    if (_activeFilters['diseaseTypes'] != null &&
        (_activeFilters['diseaseTypes'] as List).isNotEmpty) {
      final List<String> types = _activeFilters['diseaseTypes'];
      filtered = filtered.where((diagnosis) {
        return types.contains(diagnosis['diseaseName']);
      }).toList();
    }

    // Apply confidence filter
    if (_activeFilters['minConfidence'] != null) {
      final double minConfidence = _activeFilters['minConfidence'];
      filtered = filtered.where((diagnosis) {
        return (diagnosis['confidence'] as double) >= minConfidence;
      }).toList();
    }

    // Apply treatment status filter
    if (_activeFilters['treatmentStatuses'] != null &&
        (_activeFilters['treatmentStatuses'] as List).isNotEmpty) {
      final List<String> statuses = _activeFilters['treatmentStatuses'];
      filtered = filtered.where((diagnosis) {
        return statuses.contains(diagnosis['treatmentStatus']);
      }).toList();
    }

    _filteredDiagnoses = filtered;
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
    if (_isMultiSelectMode) {
      _toggleDiagnosisSelection(diagnosis['id']);
    } else {
      Navigator.pushNamed(context, '/disease-analysis-results',
          arguments: diagnosis);
    }
  }

  void _onDiagnosisCardLongPress(Map<String, dynamic> diagnosis) {
    if (!_isMultiSelectMode) {
      setState(() {
        _isMultiSelectMode = true;
        _selectedDiagnoses.add(diagnosis['id']);
      });
    }
  }

  void _toggleDiagnosisSelection(int id) {
    setState(() {
      if (_selectedDiagnoses.contains(id)) {
        _selectedDiagnoses.remove(id);
        if (_selectedDiagnoses.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedDiagnoses.add(id);
      }
    });
  }

  void _cancelMultiSelect() {
    setState(() {
      _isMultiSelectMode = false;
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
            onPressed: () {
              setState(() {
                _allDiagnoses
                    .removeWhere((d) => _selectedDiagnoses.contains(d['id']));
                _applyFiltersAndSearch();
              });
              _cancelMultiSelect();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Diagnoses deleted successfully'),
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
            onPressed: () {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _isMultiSelectMode
          ? null
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
          if (_isMultiSelectMode)
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
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                      itemCount: _filteredDiagnoses.length,
                      itemBuilder: (context, index) {
                        final diagnosis = _filteredDiagnoses[index];
                        final isSelected =
                            _selectedDiagnoses.contains(diagnosis['id']);

                        return GestureDetector(
                          onLongPress: () =>
                              _onDiagnosisCardLongPress(diagnosis),
                          child: Stack(
                            children: [
                              DiagnosisCardWidget(
                                diagnosis: diagnosis,
                                onTap: () => _onDiagnosisCardTap(diagnosis),
                                onShare: () => _shareDiagnosis(diagnosis),
                                onDelete: () => _deleteDiagnosis(diagnosis),
                                onArchive: () => _archiveDiagnosis(diagnosis),
                              ),
                              if (_isMultiSelectMode)
                                Positioned(
                                  top: 2.h,
                                  right: 6.w,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.surface,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme
                                            .lightTheme.colorScheme.outline,
                                      ),
                                    ),
                                    child: Checkbox(
                                      value: isSelected,
                                      onChanged: (value) =>
                                          _toggleDiagnosisSelection(
                                              diagnosis['id']),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
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
