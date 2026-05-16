import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms_admin_instructor/core/localization/locale_cubit.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/core/routing/router_generator.dart';
import 'package:lms_admin_instructor/core/di/service_locator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lms_admin_instructor/core/theme/app_theme.dart';
import 'package:lms_admin_instructor/core/constants/app_breakpoints.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LocaleCubit>(),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return SafeArea(
            top: true,
            left: false,
            right: false,
            child: ScreenUtilInit(
              designSize:
                  (MediaQuery.of(context).size.width >= AppBreakpoints.tablet)
                      ? const Size(1440, 1024)
                      : const Size(390, 852),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp.router(
                  supportedLocales: const [Locale('en'), Locale('ar')],
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  locale: locale,
                  debugShowCheckedModeBanner: false,
                  title: 'Commit Ma3ana',
                  theme: AppTheme.lightTheme,
                  routerConfig: RouterGenerator.goRouter,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
