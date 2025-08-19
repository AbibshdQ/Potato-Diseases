import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/camera_capture_screen/PotatoLeafUploadScreen.dart';
import '../presentation/diagnosis_history/diagnosis_history.dart';
import '../presentation/treatment_recommendations/treatment_recommendations.dart';
import '../presentation/disease_analysis_results/disease_analysis_results.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String cameraCaptureScreen = '/camera-capture-screen';
  static const String diagnosisHistory = '/diagnosis-history';
  static const String treatmentRecommendations = '/treatment-recommendations';
  static const String diseaseAnalysisResults = '/disease-analysis-results';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    cameraCaptureScreen: (context) => const PotatoLeafUploadScreen(),
    diagnosisHistory: (context) => const DiagnosisHistory(),
    treatmentRecommendations: (context) => const TreatmentRecommendations(),
    diseaseAnalysisResults: (context) => const DiseaseAnalysisResults(),
    // TODO: Add your other routes here
  };
}
