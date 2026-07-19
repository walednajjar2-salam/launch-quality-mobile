import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/widgets/animated_card.dart';
import '../theme/widgets/luxury_background.dart';
import '../widgets/custom_app_bar.dart';

/// Notifications center screen.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotificationData> _notifications = [
    _NotificationData(
      id: '1',
      icon: Icons.payment_rounded,
      title: 'دفعة إيجار مستلمة',
      body: 'تم استلام دفعة إيجار بقيمة 450 OMR من الوحدة 201',
      time: 'منذ 10 دقائق',
      accent: AppColors.success,
      isRead: false,
    ),
    _NotificationData(
      id: '2',
      icon: Icons.build_rounded,
      title: 'طلب صيانة جديد',
      body: 'تم إرسال طلب صيانة للوحدة 105 - تسريب مياه',
      time: 'منذ ساعة',
      accent: AppColors.warning,
      isRead: false,
    ),
    _NotificationData(
      id: '3',
      icon: Icons.warning_rounded,
      title: 'إيجار متأخر',
      body: 'إيجار الوحدة 308 متأخر منذ 5 أيام',
      time: 'منذ 3 ساعات',
      accent: AppColors.danger,
      isRead: false,
    ),
    _NotificationData(
      id: '4',
      icon: Icons.home_rounded,
      title: 'عقد منتهي قريباً',
      body: 'ينتهي عقد الوحدة 412 خلال 30 يوماً',
      time: 'منذ يوم',
      accent: AppColors.info,
      isRead: true,
    ),
    _NotificationData(
      id: '5',
      icon: Icons.person_add_rounded,
      title: 'مستأجر جديد',
      body: 'تم تسجيل مستأجر جديد: أحمد العبدلي - الوحدة 307',
      time: 'منذ يومين',
      accent: AppColors.gold,
      isRead: true,
    ),
    _NotificationData(
      id: '6',
      icon: Icons.receipt_long_rounded,
      title: 'فاتورة صادرة',
      body: 'تم إصدار فاتورة لشهر يوليو للوحدة 203',
      time: 'منذ 3 أيام',
      accent: AppColors.turquoise,
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _markRead(String id) {
    setState(() {
      final n = _notifications.firstWhere((n) => n.id == id);
      n.isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: 'الإشعارات',
          subtitle: _unreadCount > 0 ? '$_unreadCount غير مقروء' : 'لا توجد إشعارات جديدة',
          showBack: true,
          actions: [
            if (_unreadCount > 0)
              TextButton(
                onPressed: _markAllRead,
                child: const Text(
                  'قراءة الكل',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        body: LuxuryBackground(
          child: SafeArea(
            top: false,
            child: _notifications.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications_off_outlined,
                            color: AppColors.textMuted, size: 56),
                        SizedBox(height: AppSpacing.md),
                        Text('لا توجد إشعارات',
                            style: TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final n = _notifications[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Opacity(
                          opacity: n.isRead ? 0.65 : 1.0,
                          child: AnimatedCard(
                            accent: n.accent,
                            onTap: () => _markRead(n.id),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.base,
                              vertical: AppSpacing.md,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: AppSpacing.avatarMd,
                                  height: AppSpacing.avatarMd,
                                  decoration: BoxDecoration(
                                    color: n.accent.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusSm),
                                  ),
                                  child: Icon(n.icon,
                                      color: n.accent,
                                      size: AppSpacing.iconSm),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              n.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontWeight: n.isRead
                                                        ? FontWeight.normal
                                                        : FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          if (!n.isRead)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: AppColors.gold,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        n.body,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: AppColors.textMuted),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        n.time,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                                color: AppColors.textDisabled),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

class _NotificationData {
  _NotificationData({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    required this.accent,
    required this.isRead,
  });

  final String id;
  final IconData icon;
  final String title;
  final String body;
  final String time;
  final Color accent;
  bool isRead;
}
