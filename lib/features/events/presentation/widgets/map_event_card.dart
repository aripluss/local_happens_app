import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:local_happens/core/constants/app_colors.dart';
import 'package:local_happens/core/constants/app_text_styles.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapEventCard extends StatelessWidget {
  const MapEventCard({
    super.key,
    required this.event,
    required this.cityName,
    required this.onTap,
  });

  final Event event;
  final String cityName;
  final VoidCallback onTap;

  String _getMonthName(int month) {
    const months = [
      'січ.',
      'лют.',
      'берез.',
      'квіт.',
      'трав.',
      'черв.',
      'лип.',
      'серп.',
      'вер.',
      'жовт.',
      'лист.',
      'груд.',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final date = '${event.date.day} ${_getMonthName(event.date.month)}';
    final time =
        '${event.date.hour.toString().padLeft(2, '0')}:${event.date.minute.toString().padLeft(2, '0')}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 88,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.background.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, -1),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: event.imageUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 64,
                    height: 64,
                    color: AppColors.secondaryBackground,
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 64,
                    height: 64,
                    color: AppColors.secondaryBackground,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'lib/assets/icons/calendar.svg',
                          width: 12,
                          height: 12,
                          colorFilter: const ColorFilter.mode(
                            AppColors.mutedForeground,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(date, style: AppTextStyles.bodySmall),
                        const SizedBox(width: 4),
                        const Text('·', style: AppTextStyles.bodySmall),
                        const SizedBox(width: 4),
                        Text(time, style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'lib/assets/icons/location.svg',
                          width: 12,
                          height: 12,
                          colorFilter: const ColorFilter.mode(
                            AppColors.mutedForeground,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            cityName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
