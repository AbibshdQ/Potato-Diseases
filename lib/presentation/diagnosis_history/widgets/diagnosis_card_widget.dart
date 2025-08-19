import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DiagnosisCardWidget extends StatelessWidget {
  final Map<String, dynamic> diagnosis;
  final VoidCallback? onTap;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final VoidCallback? onArchive;

  const DiagnosisCardWidget({
    Key? key,
    required this.diagnosis,
    this.onTap,
    this.onShare,
    this.onDelete,
    this.onArchive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String diseaseName = diagnosis['diseaseName'] ?? 'Unknown Disease';
    final double confidence = (diagnosis['confidence'] ?? 0.0).toDouble();
    final String imageUrl = diagnosis['imageUrl'] ?? '';
    final DateTime date = diagnosis['date'] ?? DateTime.now();
    final String severity = diagnosis['severity'] ?? 'Medium';
    final String treatmentStatus = diagnosis['treatmentStatus'] ?? 'Pending';

    return Dismissible(
      key: Key(diagnosis['id'].toString()),
      background: _buildSwipeBackground(
        alignment: Alignment.centerLeft,
        color: AppTheme.lightTheme.colorScheme.primary,
        icon: 'share',
        label: 'Share',
      ),
      secondaryBackground: _buildSwipeBackground(
        alignment: Alignment.centerRight,
        color: AppTheme.lightTheme.colorScheme.tertiary,
        icon: 'archive',
        label: 'Archive',
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onShare?.call();
        } else if (direction == DismissDirection.endToStart) {
          onArchive?.call();
        }
        return false;
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Leaf thumbnail
                Hero(
                  tag: 'diagnosis_${diagnosis['id']}',
                  child: Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageUrl.isNotEmpty
                          ? CustomImageWidget(
                              imageUrl: imageUrl,
                              width: 15.w,
                              height: 15.w,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: AppTheme.lightTheme.colorScheme.surface,
                              child: CustomIconWidget(
                                iconName: 'eco',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 6.w,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),

                // Diagnosis details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              diseaseName,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildSeverityBadge(severity),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'verified',
                            color: _getConfidenceColor(confidence),
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${(confidence * 100).toStringAsFixed(1)}% confidence',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: _getConfidenceColor(confidence),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _formatDate(date),
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          Spacer(),
                          _buildTreatmentStatusChip(treatmentStatus),
                        ],
                      ),
                    ],
                  ),
                ),

                // More options
                IconButton(
                  onPressed: () => _showMoreOptions(context),
                  icon: CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  padding: EdgeInsets.all(2.w),
                  constraints: BoxConstraints(
                    minWidth: 8.w,
                    minHeight: 8.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({
    required Alignment alignment,
    required Color color,
    required String icon,
    required String label,
  }) {
    return Container(
      color: color.withValues(alpha: 0.1),
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 6.w,
              ),
              SizedBox(height: 0.5.h),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(String severity) {
    Color badgeColor;
    switch (severity.toLowerCase()) {
      case 'high':
        badgeColor = AppTheme.lightTheme.colorScheme.error;
        break;
      case 'medium':
        badgeColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case 'low':
        badgeColor = AppTheme.getSuccessColor(true);
        break;
      default:
        badgeColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        severity,
        style: TextStyle(
          color: badgeColor,
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTreatmentStatusChip(String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'completed':
        statusColor = AppTheme.getSuccessColor(true);
        break;
      case 'in progress':
        statusColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case 'pending':
        statusColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
        break;
      default:
        statusColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontSize: 8.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.75) {
      return AppTheme.getSuccessColor(true);
    } else if (confidence >= 0.6) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                onTap?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context);
                onShare?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'archive',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w,
              ),
              title: Text('Archive'),
              onTap: () {
                Navigator.pop(context);
                onArchive?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              title: Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                onDelete?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
