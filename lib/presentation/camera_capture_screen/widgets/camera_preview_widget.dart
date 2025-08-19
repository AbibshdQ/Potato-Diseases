import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController? cameraController;
  final bool isInitialized;
  final VoidCallback? onTapToFocus;
  final Offset? focusPoint;

  const CameraPreviewWidget({
    Key? key,
    required this.cameraController,
    required this.isInitialized,
    this.onTapToFocus,
    this.focusPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isInitialized || cameraController == null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(height: 2.h),
              Text(
                'Initializing Camera...',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTapUp: (details) {
        if (onTapToFocus != null) {
          onTapToFocus!();
        }
      },
      child: Stack(
        children: [
          // Camera Preview
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(cameraController!),
          ),

          // Leaf Detection Guidelines Overlay
          _buildLeafDetectionOverlay(),

          // Focus Ring
          if (focusPoint != null) _buildFocusRing(),

          // Viewfinder Frame
          _buildViewfinderFrame(),
        ],
      ),
    );
  }

  Widget _buildLeafDetectionOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.getSuccessColor(true).withValues(alpha: 0.6),
            width: 2,
          ),
        ),
        child: Center(
          child: Container(
            width: 70.w,
            height: 40.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.getSuccessColor(true),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Corner indicators
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: AppTheme.getSuccessColor(true), width: 3),
                        left: BorderSide(
                            color: AppTheme.getSuccessColor(true), width: 3),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: AppTheme.getSuccessColor(true), width: 3),
                        right: BorderSide(
                            color: AppTheme.getSuccessColor(true), width: 3),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: AppTheme.getSuccessColor(true), width: 3),
                        left: BorderSide(
                            color: AppTheme.getSuccessColor(true), width: 3),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: AppTheme.getSuccessColor(true), width: 3),
                        right: BorderSide(
                            color: AppTheme.getSuccessColor(true), width: 3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFocusRing() {
    return Positioned(
      left: focusPoint!.dx - 30,
      top: focusPoint!.dy - 30,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.getAccentColor(true),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildViewfinderFrame() {
    return Positioned.fill(
      child: Container(
        margin: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: Container()),
                  Container(
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: Container()),
                  Container(
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
