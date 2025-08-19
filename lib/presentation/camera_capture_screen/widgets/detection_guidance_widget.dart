import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum DetectionStatus {
  optimal,
  poorLighting,
  wrongAngle,
  tooFar,
  tooClose,
  noLeaf,
}

class DetectionGuidanceWidget extends StatelessWidget {
  final DetectionStatus status;
  final double confidence;

  const DetectionGuidanceWidget({
    Key? key,
    required this.status,
    this.confidence = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 15.h,
      left: 4.w,
      right: 4.w,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: _getBackgroundColor().withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: _getStatusIcon(),
              color: _getIconColor(),
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getStatusTitle(),
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_getStatusMessage().isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      _getStatusMessage(),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                  if (status == DetectionStatus.optimal && confidence > 0) ...[
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Text(
                          'Confidence: ',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        Text(
                          '${(confidence * 100).toStringAsFixed(1)}%',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case DetectionStatus.optimal:
        return AppTheme.getSuccessColor(true);
      case DetectionStatus.poorLighting:
      case DetectionStatus.wrongAngle:
      case DetectionStatus.tooFar:
      case DetectionStatus.tooClose:
        return AppTheme.getAccentColor(true);
      case DetectionStatus.noLeaf:
        return AppTheme.lightTheme.colorScheme.error;
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case DetectionStatus.optimal:
        return AppTheme.getSuccessColor(true);
      case DetectionStatus.poorLighting:
      case DetectionStatus.wrongAngle:
      case DetectionStatus.tooFar:
      case DetectionStatus.tooClose:
        return AppTheme.getAccentColor(true);
      case DetectionStatus.noLeaf:
        return AppTheme.lightTheme.colorScheme.error;
    }
  }

  Color _getIconColor() {
    return Colors.white;
  }

  String _getStatusIcon() {
    switch (status) {
      case DetectionStatus.optimal:
        return 'check_circle';
      case DetectionStatus.poorLighting:
        return 'wb_sunny';
      case DetectionStatus.wrongAngle:
        return 'rotate_right';
      case DetectionStatus.tooFar:
        return 'zoom_in';
      case DetectionStatus.tooClose:
        return 'zoom_out';
      case DetectionStatus.noLeaf:
        return 'warning';
    }
  }

  String _getStatusTitle() {
    switch (status) {
      case DetectionStatus.optimal:
        return 'Perfect! Ready to capture';
      case DetectionStatus.poorLighting:
        return 'Improve lighting';
      case DetectionStatus.wrongAngle:
        return 'Adjust angle';
      case DetectionStatus.tooFar:
        return 'Move closer';
      case DetectionStatus.tooClose:
        return 'Move back';
      case DetectionStatus.noLeaf:
        return 'No leaf detected';
    }
  }

  String _getStatusMessage() {
    switch (status) {
      case DetectionStatus.optimal:
        return 'Leaf positioned correctly for analysis';
      case DetectionStatus.poorLighting:
        return 'Use flash or find better lighting';
      case DetectionStatus.wrongAngle:
        return 'Hold camera parallel to leaf surface';
      case DetectionStatus.tooFar:
        return 'Get closer to fill the frame';
      case DetectionStatus.tooClose:
        return 'Step back to see the entire leaf';
      case DetectionStatus.noLeaf:
        return 'Point camera at a potato leaf';
    }
  }
}
