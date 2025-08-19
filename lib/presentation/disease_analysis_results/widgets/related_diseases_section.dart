import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RelatedDiseasesSection extends StatelessWidget {
  final List<Map<String, dynamic>> relatedDiseases;

  const RelatedDiseasesSection({
    Key? key,
    required this.relatedDiseases,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'compare',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Similar Diseases',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Compare with other common potato diseases:',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 25.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: relatedDiseases.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final disease = relatedDiseases[index];
                return _buildDiseaseCard(
                  disease['name'] ?? '',
                  disease['similarity'] ?? 0.0,
                  disease['imageUrl'] ?? '',
                  disease['keySymptom'] ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard(
      String name, double similarity, String imageUrl, String keySymptom) {
    return Container(
      width: 40.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Container(
            height: 12.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.1),
            ),
            child: imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: CustomImageWidget(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: CustomIconWidget(
                      iconName: 'image',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 8.w,
                    ),
                  ),
          ),

          // Content section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Similarity badge
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getSimilarityColor(similarity)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${similarity.toStringAsFixed(0)}% similar',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getSimilarityColor(similarity),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),

                  // Disease name
                  Text(
                    name,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // Key symptom
                  if (keySymptom.isNotEmpty) ...[
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'fiber_manual_record',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 2.w,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            keySymptom,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSimilarityColor(double similarity) {
    if (similarity >= 80) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (similarity >= 60) {
      return AppTheme.getAccentColor(true);
    } else {
      return AppTheme.getSuccessColor(true);
    }
  }
}
