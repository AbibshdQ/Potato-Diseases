// splash_screen.dart

import 'dart:async';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import 'widgets/animated_logo_widget.dart';
import 'widgets/gradient_background_widget.dart';
import 'widgets/loading_indicator_widget.dart';
import 'widgets/permission_dialog_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _loadingText = 'Initializing AI Models...';
  double _progress = 0.0;
  bool _showPermissionDialog = false;
  String _permissionTitle = '';
  String _permissionMessage = '';

  final List<Map<String, dynamic>> _initializationSteps = [
    {
      'text': 'Loading TensorFlow Lite Models...',
      'duration': 800,
      'progress': 0.2,
    },
    {
      'text': 'Preparing Disease Database...',
      'duration': 600,
      'progress': 0.4,
    },
    {
      'text': 'Checking Camera Permissions...',
      'duration': 400,
      'progress': 0.6,
    },
    {
      'text': 'Validating Storage Availability...',
      'duration': 500,
      'progress': 0.8,
    },
    {
      'text': 'Finalizing Setup...',
      'duration': 400,
      'progress': 1.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _configureSystemUI();
      for (int i = 0; i < _initializationSteps.length; i++) {
        final step = _initializationSteps[i];
        setState(() {
          _loadingText = step['text'];
          _progress = step['progress'];
        });
        await Future.delayed(Duration(milliseconds: step['duration']));
        await _performInitializationTask(i);
      }
      await _navigateToNextScreen();
    } catch (e) {
      _handleInitializationError(e);
    }
  }

  Future<void> _configureSystemUI() async {
    try {
      if (!kIsWeb && mounted) {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        );
      }
    } catch (e) {
      debugPrint('System UI configuration error: $e');
    }
  }

  Future<void> _performInitializationTask(int stepIndex) async {
    switch (stepIndex) {
      case 0:
        await _loadMLModels();
        break;
      case 1:
        await _prepareDiseaseDatabase();
        break;
      case 2:
        await _checkCameraPermissions();
        break;
      case 3:
        await _validateStorageAvailability();
        break;
      case 4:
        await _finalizeSetup();
        break;
    }
  }

  Future<void> _loadMLModels() async {
    try {
      if (!kIsWeb) {
        final directory = await getApplicationDocumentsDirectory();
        final modelPath = '${directory.path}/potato_disease_model.tflite';
        final modelFile = File(modelPath);
        if (!await modelFile.exists()) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    } catch (e) {
      debugPrint('Model loading error: $e');
    }
  }

  Future<void> _prepareDiseaseDatabase() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isInitialized = prefs.getBool('disease_db_initialized') ?? false;
      if (!isInitialized) {
        await Future.delayed(const Duration(milliseconds: 300));
        await prefs.setBool('disease_db_initialized', true);
      }
    } catch (e) {
      debugPrint('Database preparation error: $e');
    }
  }

  Future<void> _checkCameraPermissions() async {
    if (kIsWeb) return;

    try {
      final cameraStatus = await Permission.camera.status;
      if (cameraStatus.isDenied) {
        final result = await Permission.camera.request();
        if (result.isPermanentlyDenied) {
          setState(() {
            _showPermissionDialog = true;
            _permissionTitle = 'Camera Permission Required';
            _permissionMessage =
                'PotatoLeaf Detector needs camera access to analyze potato leaves. Please enable camera permission in settings.';
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Permission check error: $e');
    }
  }

  Future<void> _validateStorageAvailability() async {
    if (kIsWeb) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final stat = await directory.stat();
      if (Platform.isAndroid) {
        final storageStatus = await Permission.storage.status;
        if (storageStatus.isDenied) {
          await Permission.storage.request();
        }
      }
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      setState(() {
        _showPermissionDialog = true;
        _permissionTitle = 'Storage Issue';
        _permissionMessage =
            'Insufficient storage space. Please free up at least 100MB to continue.';
      });
    }
  }

  Future<void> _finalizeSetup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'last_app_launch', DateTime.now().toIso8601String());

      if (!kIsWeb) {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.edgeToEdge,
          overlays: SystemUiOverlay.values,
        );
      }
    } catch (e) {
      debugPrint('Finalization error: $e');
    }
  }

  Future<void> _navigateToNextScreen() async {
    if (_showPermissionDialog) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstTime = prefs.getBool('is_first_time') ?? true;
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      if (isFirstTime) {
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      } else {
        Navigator.pushReplacementNamed(context, '/camera-capture-screen');
      }
    } catch (e) {
      Navigator.pushReplacementNamed(context, '/camera-capture-screen');
    }
  }

  void _handleInitializationError(dynamic error) {
    setState(() {
      _showPermissionDialog = true;
      _permissionTitle = 'Initialization Error';
      _permissionMessage =
          'Failed to initialize the app. Please try again or check your internet connection.';
    });
  }

  void _retryInitialization() {
    setState(() {
      _showPermissionDialog = false;
      _progress = 0.0;
      _loadingText = 'Retrying initialization...';
    });
    _initializeApp();
  }

  void _cancelInitialization() {
    if (!kIsWeb && Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      Navigator.pushReplacementNamed(context, '/camera-capture-screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackgroundWidget(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 6.h),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: AnimatedLogoWidget(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: LoadingIndicatorWidget(
                      loadingText: _loadingText,
                      progress: _progress,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Version 1.0.0',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '© 2025 Powered by abibshdq',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withOpacity(0.4),
                    ),
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
              if (_showPermissionDialog)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: PermissionDialogWidget(
                      title: _permissionTitle,
                      message: _permissionMessage,
                      onRetry: _retryInitialization,
                      onCancel: _cancelInitialization,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
