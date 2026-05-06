import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/core/routing/app_routes.dart';
import 'package:lms_admin_instructor/features/auth/presentation/bloc/auth_admin_bloc.dart';
import 'package:lms_admin_instructor/features/widgets/search_bar.dart';

class CustomNavBar extends StatefulWidget {
  final String? hint;
  const CustomNavBar({super.key, this.hint});

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
            CustomSearchBarr(
              w: 383,
              h: 40,
              hint: widget.hint ?? context.tr('search_instructors_hint'),
              controller: TextEditingController(),
              prefixIcon: Icons.search,
              r: 30,
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                // هنا هحط منطق تغيير الثيم
              },
            ),
            SizedBox(width: 8.w),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {},
            ),
            SizedBox(width: 8.w),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {},
            ),
            SizedBox(width: 8.w),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  context.go(AppRoutes.loginScreen);
                }
                if (state is AuthError) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              child: IconButton(
                icon: const Icon(Icons.logout_outlined),
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
