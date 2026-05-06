import 'package:flutter/material.dart';
import '../data/courses.dart';
import '../models/course.dart';
import '../models/interval_program.dart';
import '../theme/runners_theme.dart';
import 'timer_screen.dart';

class CourseSelectionScreen extends StatelessWidget {
  const CourseSelectionScreen({super.key});

  void _navigateToCourse(BuildContext context, Course course) {
    final program = switch (course.id) {
      'beginner' => buildBeginnerProgram(),
      _ => buildBeginnerProgram(),
    };
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TimerScreen(program: program, courseTitle: course.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceTile1,
      appBar: AppBar(
        title: const Text('코스 선택'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Text(
                      '나에게 맞는 코스를 골라보세요',
                      style: AppTextStyles.caption,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: kCourses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) => _CourseCard(
                        course: kCourses[index],
                        onTap: () => _navigateToCourse(context, kCourses[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course, required this.onTap});

  final Course course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = course.levelColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: accent.withOpacity(0.25), width: 1),
        ),
        child: Row(
          children: [
            // 아이콘 컨테이너
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(course.icon, color: accent, size: 26),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(course.title, style: AppTextStyles.bodyStrong),
                      ),
                      _LevelBadge(label: course.levelLabel, color: accent),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(course.subtitle, style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    course.description,
                    style: AppTextStyles.finePrint.copyWith(height: 1.55),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 11,
                        color: AppColors.inkMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course.weeks}주 프로그램',
                        style: AppTextStyles.finePrint,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(Icons.chevron_right, color: AppColors.inkFaint, size: 20),
          ],
        ),
      ),
    );
  }
}

// 난이도 배지 — pill 문법 사용 (Apple의 pill = action signal)
class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withOpacity(0.30)),
      ),
      child: Text(
        label,
        style: AppTextStyles.finePrint.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
