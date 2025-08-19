import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:potatoleaf_detector/models/history_model.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons.dart';
import './widgets/disease_result_card.dart';
import './widgets/expandable_info_section.dart';
import './widgets/leaf_image_header.dart';
import './widgets/prevention_content.dart';
import './widgets/related_diseases_section.dart';
import './widgets/symptoms_content.dart';
import './widgets/treatment_content.dart';

class DiseaseAnalysisResults extends StatefulWidget {
  const DiseaseAnalysisResults({Key? key}) : super(key: key);

  @override
  State<DiseaseAnalysisResults> createState() => _DiseaseAnalysisResultsState();
}

class _DiseaseAnalysisResultsState extends State<DiseaseAnalysisResults> {
  late ScrollController _scrollController;
  bool _isHeaderVisible = true;

  // Mock diagnosis data
  final Map<String, dynamic> _diagnosisData = {
    "diseaseName": "Early Blight (Alternaria solani)",
    "confidence": 87.3,
    "severity": "early",
    "imageUrl":
        "https://images.pexels.com/photos/4750274/pexels-photo-4750274.jpeg",
    "analysisDate": "2025-01-23",
    "plantPart": "Leaves",
    "riskLevel": "Medium"
  };

  final List<Map<String, dynamic>> _symptoms = [
    {
      "title": "Dark Brown Spots",
      "description":
          "Small, dark brown spots with concentric rings appearing on older leaves first. These spots gradually enlarge and may have a target-like appearance.",
      "severity": "moderate",
      "imageUrl":
          "https://images.pexels.com/photos/4750274/pexels-photo-4750274.jpeg"
    },
    {
      "title": "Yellowing Around Spots",
      "description":
          "Yellow halos or chlorotic areas surrounding the brown spots, indicating tissue death and stress response.",
      "severity": "mild",
      "imageUrl":
          "https://images.pexels.com/photos/6231887/pexels-photo-6231887.jpeg"
    },
    {
      "title": "Leaf Drop",
      "description":
          "Premature dropping of affected leaves, starting from the bottom of the plant and progressing upward.",
      "severity": "severe",
      "imageUrl":
          "https://images.pexels.com/photos/4750274/pexels-photo-4750274.jpeg"
    }
  ];

  final List<Map<String, dynamic>> _treatments = [
    {
      "step": 1,
      "title": "Remove Affected Leaves",
      "description":
          "Immediately remove and destroy all infected leaves to prevent spore spread. Do not compost infected material.",
      "product": "Garden Pruning Shears",
      "dosage": "N/A",
      "frequency": "As needed",
      "priority": "high"
    },
    {
      "step": 2,
      "title": "Apply Fungicide",
      "description":
          "Use a copper-based fungicide or chlorothalonil to control the spread of the disease.",
      "product": "Copper Sulfate Fungicide",
      "dosage": "2-3 tablespoons per gallon",
      "frequency": "Every 7-10 days",
      "priority": "high"
    },
    {
      "step": 3,
      "title": "Improve Air Circulation",
      "description":
          "Ensure proper spacing between plants and remove weeds to improve airflow around potato plants.",
      "product": "Garden Hoe",
      "dosage": "N/A",
      "frequency": "Weekly maintenance",
      "priority": "medium"
    },
    {
      "step": 4,
      "title": "Water Management",
      "description":
          "Water at soil level to avoid wetting leaves. Use drip irrigation or soaker hoses when possible.",
      "product": "Drip Irrigation System",
      "dosage": "1-1.5 inches per week",
      "frequency": "2-3 times per week",
      "priority": "medium"
    }
  ];

  final List<Map<String, dynamic>> _preventionTips = [
    {
      "title": "Crop Rotation",
      "description":
          "Rotate potatoes with non-solanaceous crops for at least 3 years to break disease cycles.",
      "season": "spring",
      "iconName": "autorenew"
    },
    {
      "title": "Resistant Varieties",
      "description":
          "Plant potato varieties with natural resistance to early blight such as 'Iron Duke' or 'Mountain Fresh Plus'.",
      "season": "spring",
      "iconName": "shield"
    },
    {
      "title": "Proper Spacing",
      "description":
          "Maintain adequate spacing between plants (12-15 inches) to ensure good air circulation.",
      "season": "summer",
      "iconName": "straighten"
    },
    {
      "title": "Mulching",
      "description":
          "Apply organic mulch around plants to reduce soil splash and maintain consistent moisture.",
      "season": "summer",
      "iconName": "grass"
    },
    {
      "title": "Fall Cleanup",
      "description":
          "Remove all plant debris and fallen leaves at the end of the growing season.",
      "season": "fall",
      "iconName": "cleaning_services"
    }
  ];

  final List<Map<String, dynamic>> _relatedDiseases = [
    {
      "name": "Late Blight",
      "similarity": 75.0,
      "imageUrl":
          "https://images.pexels.com/photos/6231887/pexels-photo-6231887.jpeg",
      "keySymptom": "Water-soaked lesions"
    },
    {
      "name": "Bacterial Wilt",
      "similarity": 45.0,
      "imageUrl":
          "https://images.pexels.com/photos/4750274/pexels-photo-4750274.jpeg",
      "keySymptom": "Wilting without spots"
    },
    {
      "name": "Verticillium Wilt",
      "similarity": 35.0,
      "imageUrl":
          "https://images.pexels.com/photos/6231887/pexels-photo-6231887.jpeg",
      "keySymptom": "V-shaped yellowing"
    }
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bool isVisible = _scrollController.offset < 100;
    if (isVisible != _isHeaderVisible) {
      setState(() {
        _isHeaderVisible = isVisible;
      });
    }
  }

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  final args = ModalRoute.of(context)?.settings.arguments as Map?;
  if (args != null) {
    _diagnosisData['imageUrl'] = args['imagePath'];
    _diagnosisData['diseaseName'] = args['diseaseName'];
    _diagnosisData['confidence'] = args['confidence'];
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Sticky header
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isHeaderVisible ? 25.h : 12.h,
            child: LeafImageHeader(
              imageUrl: _diagnosisData['imageUrl'],
              onBackPressed: () => Navigator.pop(context),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Disease result card
                  DiseaseResultCard(diagnosisData: _diagnosisData),

                  SizedBox(height: 2.h),

                  // Symptoms section
                  ExpandableInfoSection(
                    title: 'Disease Symptoms',
                    iconName: 'visibility',
                    initiallyExpanded: true,
                    content: SymptomsContent(symptoms: _symptoms),
                  ),

                  SizedBox(height: 1.h),

                  // Treatment section
                  ExpandableInfoSection(
                    title: 'Treatment Recommendations',
                    iconName: 'medical_services',
                    content: TreatmentContent(treatments: _treatments),
                  ),

                  SizedBox(height: 1.h),

                  // Prevention section
                  ExpandableInfoSection(
                    title: 'Prevention Tips',
                    iconName: 'shield',
                    content: PreventionContent(preventionTips: _preventionTips),
                  ),

                  SizedBox(height: 2.h),

                  // Related diseases section
                  RelatedDiseasesSection(relatedDiseases: _relatedDiseases),

                  SizedBox(height: 2.h),

                  // Action buttons
                  ActionButtons(
                    diagnosisData: _diagnosisData,
                    onShare: _shareResults,
                    onSaveToHistory: _saveToHistory,
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/camera-capture-screen'),
        backgroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
        child: CustomIconWidget(
          iconName: 'camera_alt',
          color:
              AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor ??
                  Colors.white,
          size: 6.w,
        ),
      ),
    );
  }

  void _shareResults() {
    final String shareText = _generateShareText();
    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.getSuccessColor(true),
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Diagnosis report copied to clipboard and ready to share!',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.getSuccessColor(true),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _saveToHistory() async {
    final box = Hive.box<HistoryModel>('historyBox');

    // Ambil path gambar dari arguments (yang dikirim dari PotatoLeafUploadScreen)
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String imagePath = args?['imagePath'] ?? '';

    final history = HistoryModel()
      ..id = DateTime.now().millisecondsSinceEpoch
      ..diseaseName = _diagnosisData['diseaseName']
      ..confidence = (_diagnosisData['confidence'] ?? 0.0).toDouble()
      ..imagePath = imagePath
      ..date = DateTime.now();

    await box.add(history);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'bookmark_added',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Diagnosis saved to your history successfully!',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  String _generateShareText() {
    final String diseaseName =
        _diagnosisData['diseaseName'] ?? 'Unknown Disease';
    final double confidence = (_diagnosisData['confidence'] ?? 0.0).toDouble();
    final String severity = _diagnosisData['severity'] ?? 'unknown';
    final String analysisDate =
        _diagnosisData['analysisDate'] ?? 'Unknown Date';

    return '''
🌱 PotatoLeaf Disease Analysis Report 🌱

📊 Disease Identified: $diseaseName
🎯 Confidence Score: ${confidence.toStringAsFixed(1)}%
⚠️ Severity Level: ${severity.toUpperCase()}
📅 Analysis Date: $analysisDate

🔍 Key Symptoms:
${_symptoms.map((s) => '• ${s['title']}: ${s['description']}').join('\n')}

💊 Treatment Priority:
${_treatments.where((t) => t['priority'] == 'high').map((t) => '• ${t['title']}: ${t['description']}').join('\n')}

🛡️ Prevention Tips:
${_preventionTips.take(3).map((p) => '• ${p['title']}: ${p['description']}').join('\n')}

Generated by PotatoLeaf Detector App
#Agriculture #PlantHealth #PotatoFarming
    ''';
  }
}
