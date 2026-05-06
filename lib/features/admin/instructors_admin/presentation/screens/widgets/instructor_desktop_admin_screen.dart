import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_admin_instructor/core/extensions/context_extensions.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/core/routing/app_routes.dart';
import 'package:lms_admin_instructor/features/admin/instructors_admin/presentation/bloc/instructor_admin_bloc.dart';
import 'package:lms_admin_instructor/features/admin/instructors_admin/presentation/bloc/instructor_admin_event.dart';
import 'package:lms_admin_instructor/features/admin/instructors_admin/presentation/bloc/instructor_admin_state.dart';
import 'package:lms_admin_instructor/features/widgets/custom_add_row/custom_add_row_widget.dart';
import 'package:lms_admin_instructor/features/widgets/custom_card_status_info/custom_card_status_info_desktop.dart';
import 'package:lms_admin_instructor/features/admin/instructors_admin/presentation/screens/widgets/custom_nav_bar.dart';
import 'package:lms_admin_instructor/features/widgets/custom_data_table/custom_data_table.dart';
import 'package:lms_admin_instructor/features/widgets/custom_data_table/custom_data_table_model.dart';
import 'package:lms_admin_instructor/features/admin/instructors_admin/presentation/screens/widgets/add_instructor_disktop_admin_screen.dart';

class InstructorDesktopAdminScreen extends StatefulWidget {
  const InstructorDesktopAdminScreen({super.key});

  @override
  State<InstructorDesktopAdminScreen> createState() =>
      _InstructorDesktopAdminScreenState();
}

class _InstructorDesktopAdminScreenState
    extends State<InstructorDesktopAdminScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<InstructorAdminBloc>().add(GetInstructorAdminEvent(page: 1));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      final state = context.read<InstructorAdminBloc>().state;
      if (state is InstructorAdminLoaded && !state.isPaginationLoading) {
        context.read<InstructorAdminBloc>().add(
          GetInstructorAdminEvent(
            page: state.instructorAdminUiModel.currentPage + 1,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.primary.withValues(alpha: 0.005),
      //**************************************??AppBar??********************************************??
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: const CustomNavBar(),
        toolbarHeight: 70.h,
      ),
      body: Padding(
        padding: EdgeInsets.all(40.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAddRowWidget(
              title: context.tr('manage_instructors'),
              description: context.tr(
                'create_update_manage_instructor_profiles_assignments',
              ),
              buttonText: context.tr('add_instructor'),
              icon: Icons.people_outline,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<InstructorAdminBloc>(),
                    child: const AddInstructorDisktopAdminScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 32.h),

            //**************************************??show all instructors??********************************************??
            Expanded(
              child: BlocListener<InstructorAdminBloc, InstructorAdminState>(
                listener: (context, state) {
                  if (state is DeleteInstructorSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Instructor deleted successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.read<InstructorAdminBloc>().add(
                      GetInstructorAdminEvent(page: 1),
                    );
                  }
                },
                child: BlocBuilder<InstructorAdminBloc, InstructorAdminState>(
                  buildWhen: (previous, current) =>
                      current is InstructorAdminLoaded ||
                      current is InstructorAdminLoading ||
                      current is InstructorAdminError,
                  builder: (context, state) {
                    if (state is InstructorAdminLoading ||
                        state is DeleteInstructorLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is InstructorAdminError) {
                      return Center(child: Text(state.message));
                    } else if (state is InstructorAdminLoaded) {
                      return Column(
                        children: [
                          //**************************************??Details Cards??********************************************??
                          Row(
                            children: [
                              CustomCardStatusInfoDesktop(
                                title: context.tr('total_instructors'),
                                value:
                                    "${state.instructorAdminUiModel.totalInstructors}",
                                icon: Icons.people_outline,
                                color: const Color(0xff3B82F6),
                              ),
                              SizedBox(width: 20.w),
                              CustomCardStatusInfoDesktop(
                                title: context.tr('total_courses'),
                                value: "48",
                                icon: Icons.book_outlined,
                                color: const Color(0xff16A34A),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.h),

                          Expanded(
                            child: CustomDataTable(
                              headers: [
                                context.tr('instructor_name_column'),
                                context.tr('bio_column'),
                                context.tr('join_date_column'),
                                context.tr('email_column'),
                              ],
                              columnFlex: const [3, 4, 2, 2, 2],
                              data: state.instructorAdminUiModel.instructors
                                  .map((instructor) {
                                    return instructor.copyWith(
                                      onActionPressed: () {
                                        showAdaptiveDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return BlocProvider.value(
                                              value: context
                                                  .read<InstructorAdminBloc>(),
                                              child: AlertDialog.adaptive(
                                                title: Text(
                                                  context.tr(
                                                    'delete_Instructor',
                                                  ),
                                                ),
                                                content: Text(
                                                  context.tr(
                                                    'are_you_sure_delete_instructor',
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          dialogContext,
                                                        ),
                                                    child: Text(
                                                      context.tr('cancel'),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                        dialogContext,
                                                      );
                                                      context
                                                          .read<
                                                            InstructorAdminBloc
                                                          >()
                                                          .add(
                                                            DeleteInstructorEvent(
                                                              slug: instructor
                                                                  .slug,
                                                            ),
                                                          );
                                                    },
                                                    child: Text(
                                                      context.tr('delete'),
                                                      style: TextStyle(
                                                        color: context
                                                            .colorScheme
                                                            .error,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      onOptionsPressed: () async {
                                        await context.push(
                                          AppRoutes
                                              .profileInstructorAdminScreen,
                                          extra: instructor.slug,
                                        );
                                        if (context.mounted) {
                                          context
                                              .read<InstructorAdminBloc>()
                                              .add(
                                                GetInstructorAdminEvent(
                                                  page: 1,
                                                ),
                                              );
                                        }
                                      },
                                      actionIconpressed: Icons.delete,
                                      // optionsIconpressed: Icons.person,
                                    );
                                  })
                                  .cast<CustomDataTableRowModel>()
                                  .toList(),
                              scrollController: _scrollController,
                              isPaginationLoading: state.isPaginationLoading,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
