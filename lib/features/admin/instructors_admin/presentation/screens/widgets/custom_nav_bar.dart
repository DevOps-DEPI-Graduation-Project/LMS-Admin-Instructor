import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/features/widgets/search_bar.dart';

class CustomNavBar extends StatefulWidget {
  final String? hint;
  final bool showSearch;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;

  const CustomNavBar({
    super.key,
    this.hint,
    this.showSearch = true,
    this.searchController,
    this.onSearchChanged,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 13.h),
        child: Row(
          children: [
            if (widget.showSearch)
              CustomSearchBarr(
                w: 383,
                h: 40,
                hint: widget.hint ?? context.tr('search_instructors_hint'),
                controller: widget.searchController ?? TextEditingController(),
                onChanged: widget.onSearchChanged,
                prefixIcon: Icons.search,
                r: 30,
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
