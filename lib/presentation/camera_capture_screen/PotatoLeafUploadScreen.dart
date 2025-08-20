import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:potatoleaf_detector/services/potato_classifier.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class PotatoLeafUploadScreen extends StatefulWidget {
  const PotatoLeafUploadScreen({Key? key}) : super(key: key);

  @override
  State<PotatoLeafUploadScreen> createState() => _PotatoLeafUploadScreenState();
}

class _PotatoLeafUploadScreenState extends State<PotatoLeafUploadScreen>
    with TickerProviderStateMixin {
  // Image related variables
  File? capturedLeafImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploading = false;
  bool _isAnalyzing = false;

  // Animation controllers
  late AnimationController _uploadAnimationController;
  late AnimationController _pulseAnimationController;

  // Recent diagnoses for history display
  final List<Map<String, dynamic>> _recentDiagnoses = [
    {
      "id": 1,
      "disease": "Early Blight",
      "confidence": 89,
      "timestamp": "2 jam lalu",
      "severity": "Sedang",
      "treatment": "Aplikasi fungisida berbasis tembaga",
    },
    {
      "id": 2,
      "disease": "Daun Sehat",
      "confidence": 95,
      "timestamp": "1 hari lalu",
      "severity": "Normal",
      "treatment": "Lanjutkan perawatan rutin",
    },
    {
      "id": 3,
      "disease": "Late Blight",
      "confidence": 76,
      "timestamp": "2 hari lalu",
      "severity": "Parah",
      "treatment": "Segera aplikasi fungisida sistemik",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _uploadAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _uploadAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  Future<void> _selectFromCamera() async {
    try {
      // Request camera permission
      if (!await _requestCameraPermission()) {
        _showPermissionDialog('Kamera');
        return;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        setState(() {
          capturedLeafImage = File(image.path);
        });
        HapticFeedback.heavyImpact();
        _uploadAnimationController.forward();
        _analyzeImage();
      }
    } catch (e) {
      debugPrint('Camera capture error: $e');
      _showErrorDialog('Gagal mengambil foto dari kamera');
    }
  }

  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          capturedLeafImage = File(image.path);
        });
        HapticFeedback.mediumImpact();
        _uploadAnimationController.forward();
        _analyzeImage();
      }
    } catch (e) {
      debugPrint('Gallery selection error: $e');
      _showErrorDialog('Gagal mengambil foto dari galeri');
    }
  }


Future<void> _analyzeImage() async {
  if (capturedLeafImage == null) return;

  setState(() => _isAnalyzing = true);

  final classifier = PotatoClassifier();
  await classifier.loadModel();
  final result = await classifier.predict(capturedLeafImage!);

  setState(() => _isAnalyzing = false);

  Navigator.pushNamed(
    context,
    '/disease-analysis-results',
    arguments: {
      'imagePath': capturedLeafImage!.path,
      'diseaseName': result['className'],
      'confidence': result['confidence'],
    },
  );
}


  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  void _showPermissionDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Izin $permissionType Diperlukan'),
        content: Text(
            'Aplikasi membutuhkan izin $permissionType untuk menganalisis daun kentang. Silakan berikan izin di pengaturan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Pengaturan'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terjadi Kesalahan'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _removeSelectedImage() {
    setState(() {
      capturedLeafImage = null;
      _isAnalyzing = false;
    });
    _uploadAnimationController.reverse();
    HapticFeedback.lightImpact();
  }

  void _openDiagnosisHistory() {
    Navigator.pushNamed(context, '/diagnosis-history');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Deteksi Penyakit Daun Kentang',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _openDiagnosisHistory,
            icon: Icon(
              Icons.history,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Info
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cara Menggunakan',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Ambil foto daun kentang yang jelas dari dekat dan fokus untuk hasil analisis yang akurat',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // Upload Area
            AnimatedBuilder(
              animation: _uploadAnimationController,
              builder: (context, child) {
                return Container(
                  height: capturedLeafImage != null ? 50.h : 35.h,
                  decoration: BoxDecoration(
                    color: capturedLeafImage != null
                        ? Colors.transparent
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: capturedLeafImage != null
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.dividerColor,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: capturedLeafImage != null
                      ? _buildSelectedImageView()
                      : _buildUploadArea(),
                );
              },
            ),

            SizedBox(height: 3.h),

            // Upload Buttons
            if (capturedLeafImage == null) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _selectFromCamera,
                      icon: Icon(Icons.camera_alt, size: 6.w),
                      label: Text(
                        'Ambil Foto',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _selectFromGallery,
                      icon: Icon(Icons.photo_library, size: 6.w),
                      label: Text(
                        'Dari Galeri',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.lightTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              color: AppTheme.lightTheme.primaryColor),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Action buttons when image is selected
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isAnalyzing ? null : _removeSelectedImage,
                      icon: Icon(Icons.refresh, size: 6.w),
                      label: Text(
                        'Ganti Foto',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.grey[700],
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isAnalyzing ? null : _analyzeImage,
                      icon: _isAnalyzing
                          ? SizedBox(
                              width: 5.w,
                              height: 5.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Icon(Icons.analytics, size: 6.w),
                      label: Text(
                        _isAnalyzing ? 'Menganalisis...' : 'Analisis Sekarang',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: 4.h),

            // Recent Diagnoses
            if (_recentDiagnoses.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Diagnosis Terakhir',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _openDiagnosisHistory,
                    child: Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              ...List.generate(
                _recentDiagnoses.take(3).length,
                (index) => _buildDiagnosisCard(_recentDiagnoses[index]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    return AnimatedBuilder(
      animation: _pulseAnimationController,
      builder: (context, child) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.cloud_upload_outlined,
                  size: 20.w,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Upload Foto Daun Kentang',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Pilih foto dari kamera atau galeri\nuntuk mendeteksi penyakit daun kentang',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedImageView() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: FileImage(capturedLeafImage!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (_isAnalyzing)
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Menganalisis daun kentang...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          top: 2.w,
          right: 2.w,
          child: GestureDetector(
            onTap: _removeSelectedImage,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 5.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiagnosisCard(Map<String, dynamic> diagnosis) {
    Color severityColor = diagnosis['severity'] == 'Normal'
        ? Colors.green
        : diagnosis['severity'] == 'Sedang'
            ? Colors.orange
            : Colors.red;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              diagnosis['disease'] == 'Daun Sehat'
                  ? Icons.check_circle
                  : Icons.warning,
              color: severityColor,
              size: 7.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  diagnosis['disease'],
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      '${diagnosis['confidence']}% akurat',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: severityColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      width: 1,
                      height: 12,
                      color: Colors.grey[300],
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      diagnosis['timestamp'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
            size: 6.w,
          ),
        ],
      ),
    );
  }
}
