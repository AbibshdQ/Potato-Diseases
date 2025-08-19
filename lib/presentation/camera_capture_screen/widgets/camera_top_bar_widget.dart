import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraTopBarWidget extends StatelessWidget {
  final FlashMode currentFlashMode;
  final VoidCallback? onFlashToggle;
  final VoidCallback? onCameraFlip;
  final VoidCallback? onSettingsPressed;
  final bool hasMultipleCameras;

  const CameraTopBarWidget({
    Key? key,
    required this.currentFlashMode,
    this.onFlashToggle,
    this.onCameraFlip,
    this.onSettingsPressed,
    this.hasMultipleCameras = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Flash Control
              if (!kIsWeb) _buildFlashControl(),
              if (kIsWeb) SizedBox(width: 12.w),

              // App Title/Logo
              Text(
                'PotatoLeaf Detector',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Right Controls
              Row(
                children: [
                  // Camera Flip Button
                  if (hasMultipleCameras) _buildCameraFlipButton(),
                  if (hasMultipleCameras) SizedBox(width: 2.w),

                  // Settings Button
                  _buildSettingsButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlashControl() {
    return GestureDetector(
      onTap: onFlashToggle,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.5),
        ),
        child: CustomIconWidget(
          iconName: _getFlashIconName(),
          color: _getFlashIconColor(),
          size: 6.w,
        ),
      ),
    );
  }

  Widget _buildCameraFlipButton() {
    return GestureDetector(
      onTap: onCameraFlip,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.5),
        ),
        child: CustomIconWidget(
          iconName: 'flip_camera_ios',
          color: Colors.white,
          size: 6.w,
        ),
      ),
    );
  }

  Widget _buildSettingsButton() {
    return GestureDetector(
      onTap: onSettingsPressed,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.5),
        ),
        child: CustomIconWidget(
          iconName: 'settings',
          color: Colors.white,
          size: 6.w,
        ),
      ),
    );
  }

  String _getFlashIconName() {
    switch (currentFlashMode) {
      case FlashMode.auto:
        return 'flash_auto';
      case FlashMode.always:
        return 'flash_on';
      case FlashMode.off:
        return 'flash_off';
      case FlashMode.torch:
        return 'flashlight_on';
    }
  }

  Color _getFlashIconColor() {
    switch (currentFlashMode) {
      case FlashMode.auto:
        return AppTheme.getAccentColor(true);
      case FlashMode.always:
      case FlashMode.torch:
        return Colors.yellow;
      case FlashMode.off:
        return Colors.white;
    }
  }
}
