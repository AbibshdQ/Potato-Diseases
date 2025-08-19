import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/interactive_demo_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/skip_button_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  // Mock data for onboarding screens
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Smart Disease Detection",
      "description":
          "Instantly identify potato leaf diseases using your smartphone camera. Get accurate AI-powered diagnosis in seconds, right in your field.",
      "imageUrl":
          "https://images.pexels.com/photos/4503273/pexels-photo-4503273.jpeg?auto=compress&cs=tinysrgb&w=800",
      "demoType": "camera",
    },
    {
      "title": "Comprehensive Disease Library",
      "description":
          "Access detailed information about early blight, late blight, and healthy leaf identification with confidence scores and visual guides.",
      "imageUrl":
          "https://images.unsplash.com/photo-1416879595882-3373a0480b5b?auto=format&fit=crop&w=800&q=80",
      "demoType": "disease_gallery",
    },
    {
      "title": "Expert Treatment Guidance",
      "description":
          "Receive personalized treatment recommendations, prevention tips, and connect with agricultural experts for professional consultation.",
      "imageUrl":
          "https://images.pixabay.com/photo/2016/08/09/21/54/yellowstone-national-park-1581879_960_720.jpg",
      "demoType": "treatment",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    HapticFeedback.selectionClick();
  }

  void _skipOnboarding() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacementNamed(context, '/camera-capture-screen');
  }

  void _getStarted() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacementNamed(context, '/camera-capture-screen');
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.lightTheme.colorScheme.surface,
                  AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.8),
                ],
              ),
            ),
          ),

          // Main content with PageView
          Column(
            children: [
              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _totalPages,
                  itemBuilder: (context, index) {
                    final data = _onboardingData[index];
                    return Column(
                      children: [
                        // Main onboarding page
                        Expanded(
                          child: OnboardingPageWidget(
                            title: data["title"] as String,
                            description: data["description"] as String,
                            imageUrl: data["imageUrl"] as String,
                            isLastPage: index == _totalPages - 1,
                            onGetStarted: _getStarted,
                          ),
                        ),

                        // Interactive demo section
                        if (index < _totalPages - 1) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Column(
                              children: [
                                Text(
                                  'Try it yourself',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                InteractiveDemoWidget(
                                  demoType: data["demoType"] as String,
                                ),
                                SizedBox(height: 3.h),
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),

              // Page indicator
              Container(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: PageIndicatorWidget(
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                ),
              ),
            ],
          ),

          // Skip button (top-right)
          SkipButtonWidget(onSkip: _skipOnboarding),

          // Swipe gesture hint for mobile
          if (_currentPage < _totalPages - 1)
            Positioned(
              bottom: 12.h,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _nextPage,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Swipe or tap to continue',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'arrow_forward_ios',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        size: 4.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
