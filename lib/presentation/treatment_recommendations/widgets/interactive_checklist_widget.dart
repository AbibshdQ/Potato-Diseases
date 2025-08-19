import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InteractiveChecklistWidget extends StatefulWidget {
  final List<Map<String, dynamic>> checklistItems;
  final Function(int, bool) onItemChecked;

  const InteractiveChecklistWidget({
    Key? key,
    required this.checklistItems,
    required this.onItemChecked,
  }) : super(key: key);

  @override
  State<InteractiveChecklistWidget> createState() =>
      _InteractiveChecklistWidgetState();
}

class _InteractiveChecklistWidgetState
    extends State<InteractiveChecklistWidget> {
  late List<bool> checkedItems;

  @override
  void initState() {
    super.initState();
    checkedItems =
        widget.checklistItems.map((item) => item['completed'] as bool).toList();
  }

  double get completionPercentage {
    if (checkedItems.isEmpty) return 0.0;
    int completedCount = checkedItems.where((item) => item).length;
    return completedCount / checkedItems.length;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'checklist',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Treatment Progress',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${(completionPercentage * 100).toInt()}%',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.getSuccessColor(true),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            Container(
              width: double.infinity,
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: completionPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.getSuccessColor(true),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            ...widget.checklistItems.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> item = entry.value;
              bool isChecked = checkedItems[index];

              return Container(
                margin: EdgeInsets.only(bottom: 1.5.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isChecked
                      ? AppTheme.getSuccessColor(true).withValues(alpha: 0.05)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isChecked
                        ? AppTheme.getSuccessColor(true).withValues(alpha: 0.3)
                        : AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          checkedItems[index] = !checkedItems[index];
                        });
                        widget.onItemChecked(index, checkedItems[index]);
                      },
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: isChecked
                              ? AppTheme.getSuccessColor(true)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isChecked
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme.lightTheme.dividerColor,
                            width: 2,
                          ),
                        ),
                        child: isChecked
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 4.w,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              decoration:
                                  isChecked ? TextDecoration.lineThrough : null,
                              color: isChecked
                                  ? AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            item['description'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              decoration:
                                  isChecked ? TextDecoration.lineThrough : null,
                              color: isChecked
                                  ? AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item['dueDate'] != null) ...[
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'schedule',
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  size: 3.5.w,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Due: ${item['dueDate'] as String}',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
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
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
