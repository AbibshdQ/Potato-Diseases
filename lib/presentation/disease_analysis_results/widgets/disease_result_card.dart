import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DiseaseResultCard extends StatelessWidget {
  final Map<String, dynamic> diagnosisData;

  const DiseaseResultCard({
    Key? key,
    required this.diagnosisData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String diseaseName =
        diagnosisData['diseaseName'] ?? 'Unknown Disease';
    final double confidence = (diagnosisData['confidence'] ?? 0.0).toDouble();
    final String severity = diagnosisData['severity'] ?? 'unknown';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'local_florist',
                  color: _getSeverityColor(severity),
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Disease Identification',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              diseaseName,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confidence Score',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${confidence.toStringAsFixed(1)}%',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getConfidenceColor(confidence),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(severity).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getSeverityColor(severity),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: _getSeverityIcon(severity),
                        color: _getSeverityColor(severity),
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        _getSeverityLabel(severity),
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: _getSeverityColor(severity),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              height: 1.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0.5.h),
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: confidence / 100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.5.h),
                    color: _getConfidenceColor(confidence),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'healthy':
        return AppTheme.getSuccessColor(true);
      case 'early':
      case 'mild':
        return AppTheme.getAccentColor(true);
      case 'severe':
      case 'critical':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) {
      return AppTheme.getSuccessColor(true);
    } else if (confidence >= 60) {
      return AppTheme.getAccentColor(true);
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  String _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'healthy':
        return 'check_circle';
      case 'early':
      case 'mild':
        return 'warning';
      case 'severe':
      case 'critical':
        return 'error';
      default:
        return 'help';
    }
  }

  String _getSeverityLabel(String severity) {
    switch (severity.toLowerCase()) {
      case 'healthy':
        return 'Healthy';
      case 'early':
        return 'Early Stage';
      case 'mild':
        return 'Mild';
      case 'severe':
        return 'Severe';
      case 'critical':
        return 'Critical';
      default:
        return 'Unknown';
    }
  }
}
