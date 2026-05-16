import 'package:flutter/material.dart';
import 'package:lms_admin_instructor/features/widgets/custom_data_table/custom_data_table_model.dart';

import 'package:lms_admin_instructor/core/common/mixins/paginated_state.dart';

class StudentAdminUIModel extends PaginatedUIModel<StudentItemUIModel> {
  final List<StudentItemUIModel> students;
  final int totalEnrollments;
  @override
  final int totalPages;
  @override
  final int currentPage;

  StudentAdminUIModel({
    required this.students,
    required this.totalEnrollments,
    required this.totalPages,
    required this.currentPage,
  }) : super(items: students, totalPages: totalPages, currentPage: currentPage);

  @override
  StudentAdminUIModel copyWithItems(
    List<StudentItemUIModel> newItems, {
    int? totalPages,
    int? currentPage,
  }) {
    return StudentAdminUIModel(
      students: newItems,
      totalEnrollments: totalEnrollments,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  StudentAdminUIModel copyWith({
    List<StudentItemUIModel>? students,
    int? totalEnrollments,
    int? totalPages,
    int? currentPage,
  }) {
    return StudentAdminUIModel(
      students: students ?? this.students,
      totalEnrollments: totalEnrollments ?? this.totalEnrollments,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class StudentItemUIModel extends CustomDataTableRowModel {
  final String slug;
  final String studentName;
  final String email;
  final bool isActive;
  final int enrollmentsCount;
  final String? image;
  final bool isVerified;
  final VoidCallback? onActionPressed;
  final VoidCallback? onOptionsPressed;

  StudentItemUIModel({
    required this.slug,
    required this.studentName,
    required this.email,
    required this.isActive,
    required this.enrollmentsCount,
    required this.isVerified,
    this.image,
    this.onActionPressed,
    this.onOptionsPressed,
  });

  StudentItemUIModel copyWith({
    String? slug,
    String? studentName,
    String? email,
    bool? isActive,
    int? enrollmentsCount,
    String? image,
    bool? isVerified,
    VoidCallback? onActionPressed,
    VoidCallback? onOptionsPressed,
  }) {
    return StudentItemUIModel(
      slug: slug ?? this.slug,
      studentName: studentName ?? this.studentName,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      enrollmentsCount: enrollmentsCount ?? this.enrollmentsCount,
      image: image ?? this.image,
      isVerified: isVerified ?? this.isVerified,
      onActionPressed: onActionPressed ?? this.onActionPressed,
      onOptionsPressed: onOptionsPressed ?? this.onOptionsPressed,
    );
  }

  @override
  List<String> get rowTexts => [
    studentName,
    email,
    isActive ? 'active' : 'inactive',
    isVerified ? 'verified' : 'not_verified',
  ];

  @override
  String? get avatarUrl => image;

  @override
  VoidCallback? get onAction => onActionPressed;

  @override
  IconData? get actionIcon => null;

  @override
  VoidCallback? get onRowTap => onOptionsPressed;

  @override
  VoidCallback? get onOptions => onOptionsPressed;

  @override
  IconData? get optionsIcon => null;
}
