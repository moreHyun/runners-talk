import 'package:flutter/material.dart';

enum CourseLevel { beginner, elementary, intermediate }

class Course {
  const Course({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.level,
    required this.icon,
    required this.weeks,
    required this.description,
  });

  final String id;
  final String title;
  final String subtitle;
  final CourseLevel level;
  final IconData icon;
  final int weeks;
  final String description;

  Color get levelColor => switch (level) {
        CourseLevel.beginner => const Color(0xFF4CAF50),
        CourseLevel.elementary => const Color(0xFFFF9800),
        CourseLevel.intermediate => const Color(0xFFFF6B35),
      };

  String get levelLabel => switch (level) {
        CourseLevel.beginner => '초보자',
        CourseLevel.elementary => '초급',
        CourseLevel.intermediate => '중급',
      };
}
