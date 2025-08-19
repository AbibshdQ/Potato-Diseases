import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraControlsWidget extends StatelessWidget {
  final VoidCallback? onCapturePressed;
  final VoidCallback? onGalleryPressed;
  final VoidCallback? onHistoryPressed;
  final bool isCapturing;
  final String? lastImagePath;

  const CameraControlsWidget({
    Key? key,
    this.onCapturePressed,
    this.onGalleryPressed,
    this.onHistoryPressed,
    this.isCapturing = false,
    this.lastImagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gallery Access Button
            _buildControlButton(
              onPressed: onGalleryPressed,
              child: Stack(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      color: Colors.grey[800],
                    ),
                    child: lastImagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CustomImageWidget(
                              imageUrl: lastImagePath!,
                              width: 12.w,
                              height: 12.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : CustomIconWidget(
                            iconName: 'photo_library',
                            color: Colors.white,
                            size: 6.w,
                          ),
                  ),
                ],
              ),
            ),

            // Main Capture Button
            _buildCaptureButton(),

            // History/Recent Diagnoses Button
            _buildControlButton(
              onPressed: onHistoryPressed,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.5),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'history',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: isCapturing ? null : onCapturePressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: 18.w,
        height: 18.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCapturing ? AppTheme.getAccentColor(true) : Colors.white,
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: isCapturing
            ? Center(
                child: SizedBox(
                  width: 6.w,
                  height: 6.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.primaryColor,
                size: 8.w,
              ),
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.3),
        ),
        child: child,
      ),
    );
  }
}
