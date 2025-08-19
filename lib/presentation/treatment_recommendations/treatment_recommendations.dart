import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/immediate_action_card_widget.dart';
import './widgets/interactive_checklist_widget.dart';
import './widgets/prevention_measures_widget.dart';
import './widgets/product_recommendation_card_widget.dart';
import './widgets/treatment_header_widget.dart';
import './widgets/weather_integration_widget.dart';

class TreatmentRecommendations extends StatefulWidget {
  const TreatmentRecommendations({Key? key}) : super(key: key);

  @override
  State<TreatmentRecommendations> createState() =>
      _TreatmentRecommendationsState();
}

class _TreatmentRecommendationsState extends State<TreatmentRecommendations> {
  bool isFavorited = false;

  // Mock data for treatment recommendations
  final Map<String, dynamic> diseaseInfo = {
    "name": "Early Blight (Alternaria solani)",
    "severity": "Moderate",
    "severityColor": Colors.orange,
  };

  final List<Map<String, dynamic>> immediateActions = [
    {
      "title": "Remove Infected Leaves",
      "description":
          "Carefully remove all leaves showing brown spots with concentric rings. Dispose of infected material away from healthy plants.",
      "timing": "Within 24 hours",
    },
    {
      "title": "Apply Fungicide Treatment",
      "description":
          "Spray copper-based fungicide on all plant surfaces, focusing on lower leaves where infection typically starts.",
      "timing": "Early morning or evening",
    },
    {
      "title": "Improve Air Circulation",
      "description":
          "Prune lower branches and ensure proper spacing between plants to reduce humidity around foliage.",
      "timing": "After fungicide application",
    },
    {
      "title": "Adjust Watering Schedule",
      "description":
          "Water at soil level to avoid wetting leaves. Reduce frequency but increase depth of watering.",
      "timing": "Ongoing",
    },
  ];

  final List<Map<String, dynamic>> productRecommendations = [
    {
      "name": "Copper Fungicide Pro",
      "manufacturer": "AgriChem Solutions",
      "image":
          "https://images.pexels.com/photos/4022092/pexels-photo-4022092.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.5,
      "price": "\$24.99 - \$39.99",
      "effectiveness": "95% Success Rate",
      "supplier": "Green Valley Farm Supply - 2.3 miles away",
    },
    {
      "name": "BioDefend Organic",
      "manufacturer": "Natural Crop Care",
      "image":
          "https://images.pexels.com/photos/4022092/pexels-photo-4022092.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.2,
      "price": "\$32.50 - \$48.00",
      "effectiveness": "88% Success Rate",
      "supplier": "Organic Farmers Co-op - 4.1 miles away",
    },
    {
      "name": "FungiFighter Max",
      "manufacturer": "CropGuard Industries",
      "image":
          "https://images.pexels.com/photos/4022092/pexels-photo-4022092.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.7,
      "price": "\$28.75 - \$42.25",
      "effectiveness": "92% Success Rate",
      "supplier": "Agricultural Supply Center - 1.8 miles away",
    },
  ];

  final List<Map<String, dynamic>> preventionMeasures = [
    {
      "icon": "water_drop",
      "title": "Proper Irrigation Management",
      "description":
          "Use drip irrigation or soaker hoses to keep water off leaves and reduce humidity around plants.",
    },
    {
      "icon": "air",
      "title": "Improve Air Circulation",
      "description":
          "Space plants adequately and prune lower branches to promote airflow and reduce moisture retention.",
    },
    {
      "icon": "compost",
      "title": "Soil Health Maintenance",
      "description":
          "Apply organic compost and maintain proper soil pH (6.0-6.8) to strengthen plant immunity.",
    },
    {
      "icon": "rotate_right",
      "title": "Crop Rotation Practice",
      "description":
          "Rotate potato crops with non-solanaceous plants every 3-4 years to break disease cycles.",
    },
  ];

  final List<Map<String, dynamic>> seasonalCalendar = [
    {
      "season": "Spring",
      "icon": "local_florist",
      "action": "Apply preventive copper spray before planting",
      "isCurrent": false,
    },
    {
      "season": "Summer",
      "icon": "wb_sunny",
      "action": "Monitor weekly, increase watering frequency",
      "isCurrent": true,
    },
    {
      "season": "Fall",
      "icon": "eco",
      "action": "Harvest early, clean up plant debris",
      "isCurrent": false,
    },
    {
      "season": "Winter",
      "icon": "ac_unit",
      "action": "Plan crop rotation, order resistant varieties",
      "isCurrent": false,
    },
  ];

  final Map<String, dynamic> weatherData = {
    "condition": "Partly Cloudy",
    "temperature": 78,
    "humidity": 65,
    "windSpeed": "8 mph",
    "isOptimal": true,
  };

  final List<String> treatmentAlerts = [
    "Current conditions are ideal for fungicide application",
    "Low wind speed ensures effective spray coverage",
    "Moderate humidity reduces risk of leaf burn",
  ];

  final List<Map<String, dynamic>> checklistItems = [
    {
      "title": "Remove infected plant material",
      "description":
          "Cut and dispose of all leaves showing early blight symptoms",
      "completed": false,
      "dueDate": "Today",
    },
    {
      "title": "Apply first fungicide treatment",
      "description": "Spray copper-based fungicide on all plant surfaces",
      "completed": false,
      "dueDate": "Within 24 hours",
    },
    {
      "title": "Adjust irrigation system",
      "description": "Switch to drip irrigation or soaker hoses",
      "completed": false,
      "dueDate": "This week",
    },
    {
      "title": "Monitor plant recovery",
      "description": "Check for new symptoms and treatment effectiveness",
      "completed": false,
      "dueDate": "Daily for 2 weeks",
    },
    {
      "title": "Schedule follow-up treatment",
      "description": "Plan second fungicide application if needed",
      "completed": false,
      "dueDate": "In 7-10 days",
    },
  ];

  void _handleProductTap(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomImageWidget(
                            imageUrl: product['image'] as String,
                            width: 20.w,
                            height: 20.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'] as String,
                                style: AppTheme
                                    .lightTheme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                product['manufacturer'] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                product['price'] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme.lightTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Application Instructions',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Mix 2-3 tablespoons per gallon of water. Apply every 7-14 days during growing season. Spray in early morning or evening to avoid leaf burn. Ensure complete coverage of all plant surfaces.',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Safety Precautions',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Wear protective clothing, gloves, and eye protection. Do not apply during windy conditions. Keep away from children and pets. Wait 24 hours before harvesting treated crops.',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 3.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Redirecting to supplier...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text('Contact Supplier'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleChecklistItemChecked(int index, bool isChecked) {
    // Handle checklist item completion
    if (isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task completed! Great progress.'),
          duration: Duration(seconds: 2),
          backgroundColor: AppTheme.getSuccessColor(true),
        ),
      );
    }
  }

  void _handleShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Treatment plan shared successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleSaveToFavorites() {
    setState(() {
      isFavorited = !isFavorited;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(isFavorited ? 'Added to favorites' : 'Removed from favorites'),
        duration: Duration(seconds: 2),
        backgroundColor: isFavorited ? AppTheme.getSuccessColor(true) : null,
      ),
    );
  }

  void _handleSetReminder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Treatment Reminder'),
        content: Text(
            'When would you like to be reminded about your next treatment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reminder set for tomorrow at 8:00 AM'),
                  duration: Duration(seconds: 2),
                  backgroundColor: AppTheme.getSuccessColor(true),
                ),
              );
            },
            child: Text('Tomorrow'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reminder set for next week'),
                  duration: Duration(seconds: 2),
                  backgroundColor: AppTheme.getSuccessColor(true),
                ),
              );
            },
            child: Text('Next Week'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Treatment Plan'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/diagnosis-history');
            },
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TreatmentHeaderWidget(
            diseaseName: diseaseInfo['name'] as String,
            severityLevel: diseaseInfo['severity'] as String,
            severityColor: diseaseInfo['severityColor'] as Color,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 1.h),
                  ImmediateActionCardWidget(
                    actionSteps: immediateActions,
                    isUrgent: true,
                    countdownTimer: "6 hours remaining",
                  ),
                  SizedBox(height: 1.h),
                  WeatherIntegrationWidget(
                    weatherData: weatherData,
                    treatmentAlerts: treatmentAlerts,
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Text(
                      'Recommended Products',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),
                  ...productRecommendations.map((product) {
                    return ProductRecommendationCardWidget(
                      product: product,
                      onTap: () => _handleProductTap(product),
                    );
                  }).toList(),
                  SizedBox(height: 1.h),
                  InteractiveChecklistWidget(
                    checklistItems: checklistItems,
                    onItemChecked: _handleChecklistItemChecked,
                  ),
                  SizedBox(height: 1.h),
                  PreventionMeasuresWidget(
                    preventionMeasures: preventionMeasures,
                    seasonalCalendar: seasonalCalendar,
                  ),
                  SizedBox(height: 10.h), // Space for bottom actions
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: ActionButtonsWidget(
        onShare: _handleShare,
        onSaveToFavorites: _handleSaveToFavorites,
        onSetReminder: _handleSetReminder,
        isFavorited: isFavorited,
      ),
    );
  }
}
