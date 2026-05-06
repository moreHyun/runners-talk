import 'package:flutter/material.dart';
import '../services/local_workout_repository.dart';
import '../services/stats_service.dart';
import '../theme/runners_theme.dart';
import 'course_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WorkoutStats _stats = WorkoutStats.empty;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final records = await workoutRepo.getAll();
    if (mounted) setState(() => _stats = StatsService.compute(records));
  }

  void _goToCourseSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CourseSelectionScreen()),
    ).then((_) => _loadStats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceTile1,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  const _Logo(),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '왕초보 러너 탈출 프로그램',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (_stats.hasData) ...[
                    _StatsRow(stats: _stats),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                  const Spacer(flex: 2),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _goToCourseSelection,
                      style: AppButtonStyles.primary(),
                      child: const Text('오늘의 운동 시작'),
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── 통계 카드 행 ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final WorkoutStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: '${stats.totalDays}일차',
            label: '성공',
            icon: Icons.flag_rounded,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: _StatCard(
            value: '${stats.streak}일',
            label: '연속 운동',
            icon: Icons.local_fire_department,
            color: const Color(0xFFFFB347),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: _StatCard(
            value: '${stats.thisWeekCount}/7',
            label: '이번 주',
            icon: Icons.calendar_month,
            color: AppColors.phaseWalk,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withOpacity(0.22), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: AppSpacing.xs - 2),
          Text(
            value,
            style: AppTextStyles.tagline.copyWith(color: color, fontSize: 17),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.finePrint),
        ],
      ),
    );
  }
}

// ── 로고 ─────────────────────────────────────────────────────────────────────

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 유일한 그림자: feature 요소(로고 아이콘)에만 적용
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppColors.featureShadow,
          ),
          child: const Icon(Icons.directions_run, color: Colors.white, size: 48),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('러너스톡', style: AppTextStyles.heroDisplay),
        const SizedBox(height: 4),
        Text(
          'RUNNERS TALK',
          style: AppTextStyles.finePrint.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }
}
