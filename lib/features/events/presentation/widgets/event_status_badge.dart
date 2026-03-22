import 'package:flutter/material.dart';
import 'package:local_happens/features/events/domain/entities/event_status.dart';

class EventStatusBadge extends StatelessWidget {
  final EventStatus status;

  const EventStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final badgeData = _getBadgeData(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeData.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeData.textColor.withAlpha(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeData.iconData, size: 14, color: badgeData.textColor),
          const SizedBox(width: 4),
          Text(
            badgeData.text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badgeData.textColor,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeData _getBadgeData(EventStatus status) {
    switch (status) {
      case EventStatus.pending:
        return _BadgeData(
          backgroundColor: Colors.orange[50]!,
          textColor: Colors.orange[800]!,
          iconData: Icons.schedule,
          text: 'На модерації',
        );
      case EventStatus.approved:
        return _BadgeData(
          backgroundColor: Colors.green[50]!,
          textColor: Colors.green[800]!,
          iconData: Icons.check_circle_outline,
          text: 'Схвалено',
        );
      case EventStatus.rejected:
        return _BadgeData(
          backgroundColor: Colors.red[50]!,
          textColor: Colors.red[800]!,
          iconData: Icons.cancel_outlined,
          text: 'Відхилено',
        );
    }
  }
}

class _BadgeData {
  final Color backgroundColor;
  final Color textColor;
  final IconData iconData;
  final String text;

  _BadgeData({
    required this.backgroundColor,
    required this.textColor,
    required this.iconData,
    required this.text,
  });
}
