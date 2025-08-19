import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BatchSelectionWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onCancel;
  final VoidCallback onExport;
  final VoidCallback onDelete;
  final VoidCallback onSelectAll;

  const BatchSelectionWidget({
    Key? key,
    required this.selectedCount,
    required this.onCancel,
    required this.onExport,
    required this.onDelete,
    required this.onSelectAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              onPressed: onCancel,
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                '$selectedCount selected',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: onSelectAll,
              child: Text(
                'Select All',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            IconButton(
              onPressed: onExport,
              icon: CustomIconWidget(
                iconName: 'file_download',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
              tooltip: 'Export',
            ),
            IconButton(
              onPressed: onDelete,
              icon: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
