import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms_admin_instructor/core/extensions/context_extensions.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/root/models/nav_items.dart';

class AdminSidebar extends StatelessWidget {
  final List<NavItemModel> navItems;
  final int selectedIndex;
  final Function(int) onItemTap;

  const AdminSidebar({
    super.key,
    required this.navItems,
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: context.colorScheme.onSurface.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(28.w, 32.h, 28.w, 24.h),
            child: Text(
              context.tr('lms_admin'),
              style: context.textTheme.displaySmall?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            color: context.colorScheme.onSurface.withValues(alpha: 0.1),
            height: 1,
            thickness: 1,
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: navItems.take(5).map((item) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: ResponsiveNavItem(
                    icon: item.icon,
                    label: item.label,
                    index: item.index,
                    isSelected: selectedIndex == item.index,
                    onTap: () => onItemTap(item.index),
                  ),
                );
              }).toList(),
            ),
          ),
          const Spacer(),
          Divider(
            color: context.colorScheme.onSurface.withValues(alpha: 0.1),
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 16.h),
                ResponsiveNavItem(
                  icon: navItems[5].icon,
                  label: navItems[5].label,
                  index: navItems[5].index,
                  isSelected: selectedIndex == navItems[5].index,
                  onTap: () => onItemTap(navItems[5].index),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const ResponsiveNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: isSelected
            ? context.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 22.sp,
                ),
                SizedBox(width: 12.w),
                Flexible(
                  child: Text(
                    context.tr(label),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? context.colorScheme.primary
                          : context.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
