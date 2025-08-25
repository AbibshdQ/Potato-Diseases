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

  // Data untuk Early Blight
  final List<Map<String, dynamic>> _earlyBlightTreatments = [
    {
      "step": 1,
      "title": "Pengendalian Secara Mekanik",
      "description":
          "Pengendalian secara mekanik dengan mengumpulkan bagian tanaman yang terserang dan memusnahkan bagian tanaman tersebut.",
      "product": "Garden Pruning Shears",
      "dosage": "N/A",
      "frequency": "As needed",
      "priority": "high"
    },
     {
      "step": 2,
      "title": "Pengedalian Biologis",
      "description":
          "Penggunaan Jamur Antagonis seperti jenis jamur Trichoderma harzianum bersifat antagonis terhadap jamur penyebab penyakit.",
      "product": "Tricoderma",
      "dosage": "2 g per liter air",
      "frequency": "1-2 minggu sekali",
      "priority": "medium"
    },
    {
      "step": 3,
      "title": "Gunakan Fungisida",
      "description":
          "Gunakan fungisida berbahan dasar mangkozeb atau klorotalonil untuk mengendalikan penyebaran penyakit.",
      "product": "Daconil 75WP, Mancozeb 80WP",
      "dosage": "2-3 Sendok makan per tangki 100 liter",
      "frequency": "Setiap 7-10 hari (tergantung pada kondisi cuaca)",
      "priority": "low"
    },
    // {
    //   "step": 4,
    //   "title": "Pengelolaan Air ",
    //   "description":
    //       "Siram setinggi permukaan tanah agar daun tidak basah. Gunakan irigasi tetes atau selang penyiraman jika memungkinkan, untuk mengurangi kelembapan daun dan spora jamur.",
    //   "product": "Drip Irrigation System",
    //   "dosage": "1-1.5 inches per week",
    //   "frequency": "2-3 times per week",
    //   "priority": "medium"
    // }
  ];

  final List<Map<String, dynamic>> _earlyBlightPrevention = [
    {
      "title": "Rotasi Tanaman",
      "description":
          "Lakukan rotasi dengan tanaman non-solanaceae (bawang, jagung, kacang) minimal 2-3 tahun untuk memutus siklus penyakit, atau gunakan varietes sejenis AR 08 Agrihorti atau AR 07 Agrihorti",
      "iconName": "autorenew"
    },
    {
      "title": "Gunakan Bibit Sehat",
      "description":
          "Tanam benih kentang bersertifikat dan bebas penyakit untuk mencegah infeksi sejak awal.",
      "iconName": "verified"
    },
    {
      "title": "Jarak Tanam Cukup",
      "description":
          "Atur jarak tanam 25-30 cm antar tanaman agar sirkulasi udara baik dan daun cepat kering setelah hujan.",
      "iconName": "straighten"
    },
    {
      "title": "Penyiraman Tepat",
      "description":
          "Siram langsung ke tanah, hindari membasahi daun. Lakukan pagi hari agar daun cepat kering.",
      "iconName": "water_drop"
    },
    {
      "title": "Sanitasi Lahan",
      "description":
          "Bersihkan sisa tanaman sakit dan gulma di lahan, terutama setelah panen, untuk menekan sumber inokulum.",
      "iconName": "cleaning_services"
    }
  ];

  // Data untuk Late Blight
  final List<Map<String, dynamic>> _lateBlightTreatments = [
    {
      "step": 1,
      "title": "Buang Tanaman Terinfeksi",
      "description":
          "Cabut dan musnahkan tanaman yang terinfeksi berat untuk mencegah penyebaran penyakit.",
      "product": "Garden Gloves",
      "dosage": "N/A",
      "frequency": "Segera setelah terdeteksi",
      "priority": "high"
    },
        {
      "step": 2,
      "title": "Perbaiki Drainase",
      "description":
          "Pastikan drainase lahan baik agar air tidak menggenang dan kelembapan tidak tinggi.",
      "product": "Drainage Tools",
      "dosage": "N/A",
      "frequency": "Cek rutin",
      "priority": "medium"
    },
    {
      "step": 3,
      "title": "Aplikasi Fungisida Sistemik",
      "description":
          "Gunakan fungisida berbahan aktif Dimetomorf atau Klorotalonil, sesuai dosis anjuran.",
      "product": "Dimetomorf",
      "dosage": "Sesuai label produk(anjuran produk)",
      "frequency": "Setiap 7-10 hari saat cuaca lembab",
      "priority": "low"
    },
  ];

  final List<Map<String, dynamic>> _lateBlightPrevention = [
    {
      "title": "Tanam Varietas Tahan",
      "description":
          "Pilih varietas kentang yang tahan terhadap penyakit late blight seperti GM 08, Sarpo Mira, dan Setanta.",
      "iconName": "eco"
    },
    {
      "title": "Pengaturan Waktu Tanam",
      "description":
          "Tanam pada awal musim kemarau untuk menghindari puncak kelembapan.",
      "iconName": "calendar_today"
    },
    {
      "title": "Sanitasi Lahan",
      "description": "Bersihkan sisa tanaman dan gulma sebelum tanam.",
      "iconName": "cleaning_services"
    },
    {
      "title": "Rotasi Tanaman",
      "description":
          "Lakukan rotasi dengan tanaman non-solanaceae minimal 2 tahun.",
      "iconName": "autorenew"
    }
  ];

  // Data untuk Healthy
  final List<Map<String, dynamic>> _healthyTreatments = [
    {
      "step": 1,
      "title": "Tanaman Sehat",
      "description":
          "Tanaman kentang Anda sehat. Lanjutkan pemantauan rutin dan praktik budidaya yang baik.",
      "product": "-",
      "dosage": "-",
      "frequency": "Rutin",
      "priority": "low"
    }
  ];

  final List<Map<String, dynamic>> _healthyPrevention = [
    {
      "title": "Pemantauan Rutin",
      "description":
          "Periksa tanaman secara berkala untuk mendeteksi gejala penyakit sejak dini.",
      "iconName": "search"
    },
    {
      "title": "Praktik Budidaya Baik",
      "description":
          "Lanjutkan rotasi tanaman, penggunaan bibit sehat, dan sanitasi lahan.",
      "iconName": "verified"
    }
  ];

  // Getter untuk memilih data sesuai diagnosis
  List<Map<String, dynamic>> get _selectedTreatments {
    final name = (_diagnosisData['diseaseName'] ?? '').toString().toLowerCase();
    if (name.contains('early blight')) return _earlyBlightTreatments;
    if (name.contains('late blight')) return _lateBlightTreatments;
    if (name.contains('healthy')) return _healthyTreatments;
    return [];
  }

  List<Map<String, dynamic>> get _selectedPrevention {
    final name = (_diagnosisData['diseaseName'] ?? '').toString().toLowerCase();
    if (name.contains('early blight')) return _earlyBlightPrevention;
    if (name.contains('late blight')) return _lateBlightPrevention;
    if (name.contains('healthy')) return _healthyPrevention;
    return [];
  }

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
          // Sticky header, lebih kecil agar tidak makan ruang
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isHeaderVisible ? 18.h : 10.h, // <= Ubah di sini!
            child: LeafImageHeader(
              imageUrl: _diagnosisData['imageUrl'],
              onBackPressed: () => Navigator.pop(context),
            ),
          ),

          // Konten utama scrollable
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: 2.h), // Tambah padding bawah agar tidak mentok
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 2.h),

                    // Disease result card
                    DiseaseResultCard(diagnosisData: _diagnosisData),

                    // SizedBox(height: 2.h),

                    // Treatment section
                    ExpandableInfoSection(
                      title: 'Treatment Recommendations',
                      iconName: 'medical_services',
                      initiallyExpanded: true,
                      content:
                          TreatmentContent(treatments: _selectedTreatments),
                    ),

                    SizedBox(height: 1.h),

                    // Prevention section
                    ExpandableInfoSection(
                      title: 'Prevention Tips',
                      iconName: 'shield',
                      content: PreventionContent(
                          preventionTips: _selectedPrevention),
                    ),

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
              iconName: 'copy_all',
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
${_selectedTreatments.where((t) => t['priority'] == 'high').map((t) => '• ${t['title']}: ${t['description']}').join('\n')}

🛡️ Prevention Tips:
${_selectedPrevention.take(3).map((p) => '• ${p['title']}: ${p['description']}').join('\n')}

Generated by PotatoLeaf Detector App
#Agriculture #PlantHealth #PotatoFarming
    ''';
  }
}
