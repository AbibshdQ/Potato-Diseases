import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../widgets/custom_image_widget.dart' as custom_image;

class LeafImageHeader extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onBackPressed;

  const LeafImageHeader({
    Key? key,
    this.imageUrl,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('LeafImageHeader imageUrl: $imageUrl');
    Widget imageWidget;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('http')) {
        imageWidget = custom_image.CustomImageWidget(
          imageUrl: imageUrl!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );
      } else if (File(imageUrl!).existsSync()) {
        imageWidget = custom_image.CustomImageWidget(
          imageUrl: imageUrl!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );
      } else {
        imageWidget = Container(
          color: AppTheme.lightTheme.colorScheme.surface,
          child: Center(
            child: CustomIconWidget(
              iconName: 'image',
              color: Colors.white.withOpacity(0.2),
              size: 10.w,
            ),
          ),
        );
      }
    } else {
      imageWidget = Container(
        color: AppTheme.lightTheme.colorScheme.surface,
        child: Center(
          child: CustomIconWidget(
            iconName: 'image',
            color: Colors.white.withOpacity(0.2),
            size: 10.w,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 18.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background image or placeholder
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: imageWidget,
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Header content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onBackPressed,
                        child: Container(
                          padding: EdgeInsets.all(1.5.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: 'arrow_back',
                            color: Colors.white,
                            size: 6.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Analysis Results',
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                    ],
                  ),
                  SizedBox(height: 0.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Usage example
/*
LeafImageHeader(
  imageUrl: _diagnosisData['imageUrl'],
  onBackPressed: () => Navigator.pop(context),
),
*/
