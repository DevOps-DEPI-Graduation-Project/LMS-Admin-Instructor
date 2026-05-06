import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_admin_instructor/core/extensions/context_extensions.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/core/routing/app_routes.dart';
import 'package:lms_admin_instructor/features/admin/students_admin/presentation/bloc/student_admin_bloc.dart';
import 'package:lms_admin_instructor/features/admin/students_admin/presentation/bloc/student_admin_event.dart';
import 'package:lms_admin_instructor/features/admin/students_admin/presentation/bloc/student_admin_state.dart';
import 'package:lms_admin_instructor/features/widgets/custom_card_status_info/custom_card_status_info_desktop.dart';
import 'package:lms_admin_instructor/features/widgets/custom_data_table/custom_data_table.dart';
import 'package:lms_admin_instructor/features/widgets/custom_data_table/custom_data_table_model.dart';
import 'package:lms_admin_instructor/features/admin/instructors_admin/presentation/screens/widgets/custom_nav_bar.dart';

class StudentAdminDesktopScreen extends StatefulWidget {
  const StudentAdminDesktopScreen({super.key});

  @override
  State<StudentAdminDesktopScreen> createState() =>
      _StudentAdminDesktopScreenState();
}

class _StudentAdminDesktopScreenState extends State<StudentAdminDesktopScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<StudentAdminBloc>().add(GetStudentsAdminEvent(page: 1));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      final state = context.read<StudentAdminBloc>().state;
      if (state is StudentAdminLoaded && !state.isPaginationLoading) {
        context.read<StudentAdminBloc>().add(
          GetStudentsAdminEvent(
            page: state.studentAdminUIModel.currentPage + 1,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<StudentAdminBloc>().add(
        GetStudentsAdminEvent(page: 1, search: query),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.primary.withValues(alpha: 0.005),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: CustomNavBar(
          hint: context.tr('search_by_name'),
          controller: _searchController,
          onSearch: _onSearchChanged,
        ),
        toolbarHeight: 70.h,
      ),
      body: Padding(
        padding: EdgeInsets.all(40.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('manage_students'),
              style: context.textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
            ),
            Text(
              context.tr("create_update_manage_student_profiles_assignments"),
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 32.h),
            BlocBuilder<StudentAdminBloc, StudentAdminState>(
              buildWhen: (previous, current) => current is StudentAdminLoaded,
              builder: (context, state) {
                return Row(
                  children: [
                    CustomCardStatusInfoDesktop(
                      title: context.tr('total_students'),
                      value: state is StudentAdminLoaded
                          ? state.studentAdminUIModel.totalEnrollments
                                .toString()
                          : '??',
                      icon: Icons.people_outline,
                      color: context.colorScheme.primary,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 32.h),
            Expanded(
              child: BlocBuilder<StudentAdminBloc, StudentAdminState>(
                builder: (context, state) {
                  if (state is StudentAdminLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is StudentAdminError) {
                    return Center(child: Text(state.message));
                  } else if (state is StudentAdminLoaded) {
                    return CustomDataTable(
                      headers: [
                        context.tr('student_name'),
                        context.tr('email_label'),
                        context.tr('status'),
                        context.tr('verified'),
                      ],
                      columnFlex: const [3, 4, 2, 2],
                      data: state.studentAdminUIModel.students
                          .map((student) {
                            return student.copyWith(
                              onActionPressed: () {
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog.adaptive(
                                      title: Text(context.tr('delete_student')),
                                      content: Text(
                                        context.tr(
                                          'are_you_sure_delete_student',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(context.tr('cancel')),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context
                                                .read<StudentAdminBloc>()
                                                .add(
                                                  DeleteStudentAdminEvent(
                                                    slug: student.slug,
                                                  ),
                                                );
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            context.tr('delete'),
                                            style: TextStyle(
                                              color: context.colorScheme.error,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onOptionsPressed: () {
                                context.pushNamed(
                                  AppRoutes.studentDetails,
                                  pathParameters: {'slug': student.slug},
                                );
                              },
                            );
                          })
                          .cast<CustomDataTableRowModel>()
                          .toList(),
                      scrollController: _scrollController,
                      isPaginationLoading: state.isPaginationLoading,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
