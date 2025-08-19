import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherIntegrationWidget extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  final List<String> treatmentAlerts;

  const WeatherIntegrationWidget({
    Key? key,
    required this.weatherData,
    required this.treatmentAlerts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String condition = weatherData['condition'] as String;
    final int temperature = weatherData['temperature'] as int;
    final int humidity = weatherData['humidity'] as int;
    final String windSpeed = weatherData['windSpeed'] as String;
    final bool isOptimalCondition = weatherData['isOptimal'] as bool;

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
                  iconName: 'wb_sunny',
                  color: AppTheme.getAccentColor(true),
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Weather Conditions',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.getAccentColor(true),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: isOptimalCondition
                        ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.error
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isOptimalCondition ? 'Optimal' : 'Caution',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: isOptimalCondition
                          ? AppTheme.getSuccessColor(true)
                          : AppTheme.lightTheme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'thermostat',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 5.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '${temperature}°F',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Temperature',
                          style: AppTheme.lightTheme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'water_drop',
                          color: Colors.blue,
                          size: 5.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '$humidity%',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Humidity',
                          style: AppTheme.lightTheme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'air',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 5.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          windSpeed,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Wind',
                          style: AppTheme.lightTheme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isOptimalCondition
                    ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
                    : AppTheme.getAccentColor(true).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isOptimalCondition
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.getAccentColor(true),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName:
                            isOptimalCondition ? 'check_circle' : 'warning',
                        color: isOptimalCondition
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.getAccentColor(true),
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Treatment Window',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isOptimalCondition
                              ? AppTheme.getSuccessColor(true)
                              : AppTheme.getAccentColor(true),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  ...treatmentAlerts.map((alert) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 0.5.h),
                      child: Text(
                        '• $alert',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
