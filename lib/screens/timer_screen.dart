import 'dart:async';
import 'package:flutter/material.dart';
import '../models/interval_program.dart';
import '../models/workout_record.dart';
import '../services/local_workout_repository.dart';
import '../theme/runners_theme.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({
    super.key,
    required this.program,
    required this.courseTitle,
  });

  final IntervalProgram program;
  final String courseTitle;

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late List<Phase> _phases;
  int _phaseIndex = 0;
  late int _secondsLeft;
  bool _isRunning = false;
  bool _isDone = false;
  Timer? _timer;

  Phase get _currentPhase => _phases[_phaseIndex];

  int get _elapsedSeconds {
    final doneSeconds = _phases
        .sublist(0, _phaseIndex)
        .fold(0, (sum, p) => sum + p.durationSeconds);
    return doneSeconds + (_currentPhase.durationSeconds - _secondsLeft);
  }

  double get _totalProgress =>
      _elapsedSeconds / widget.program.totalDuration.inSeconds;

  @override
  void initState() {
    super.initState();
    _phases = widget.program.phases;
    _secondsLeft = _currentPhase.durationSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPause() {
    if (_isDone) return;
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }
  }

  void _tick() {
    if (_secondsLeft > 1) {
      setState(() => _secondsLeft--);
    } else {
      _advancePhase();
    }
  }

  void _advancePhase() {
    if (_phaseIndex < _phases.length - 1) {
      setState(() {
        _phaseIndex++;
        _secondsLeft = _currentPhase.durationSeconds;
      });
    } else {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
        _isDone = true;
      });
      _saveRecord();
    }
  }

  Future<void> _saveRecord() async {
    final uniquePhases = _phases
        .map((p) => p.label)
        .toSet()
        .toList();
    await workoutRepo.save(WorkoutRecord(
      courseId: widget.program.courseId,
      courseTitle: widget.courseTitle,
      completedAt: DateTime.now(),
      durationSeconds: widget.program.totalDuration.inSeconds,
      phases: uniquePhases,
    ));
  }

  // 드래그한 비율(0.0~1.0)로 페이즈와 남은 시간을 계산해 점프
  void _seekTo(double fraction) {
    _timer?.cancel();
    final totalSecs = widget.program.totalDuration.inSeconds;
    final target = (fraction * totalSecs).round().clamp(0, totalSecs - 1);

    int accumulated = 0;
    for (int i = 0; i < _phases.length; i++) {
      final end = accumulated + _phases[i].durationSeconds;
      if (target < end || i == _phases.length - 1) {
        setState(() {
          _phaseIndex = i;
          _secondsLeft = end - target;
          _isRunning = false;
          _isDone = false;
        });
        return;
      }
      accumulated = end;
    }
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceTile1,
      appBar: AppBar(
        title: Text(widget.courseTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Center(
              child: Text(
                _formatTime(widget.program.totalDuration.inSeconds - _elapsedSeconds),
                style: AppTextStyles.caption,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _isDone
                  ? _DoneView(
                      onBack: () => Navigator.of(context)
                          .popUntil((route) => route.isFirst),
                    )
                  : _TimerView(
                      phase: _currentPhase,
                      secondsLeft: _secondsLeft,
                      totalSets: widget.program.totalSets,
                      totalProgress: _totalProgress,
                      phases: _phases,
                      totalDurationSeconds: widget.program.totalDuration.inSeconds,
                      isRunning: _isRunning,
                      formatTime: _formatTime,
                      onStartPause: _startPause,
                      onSeek: _seekTo,
                      onBack: () {
                        _timer?.cancel();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// TimerView
// ─────────────────────────────────────────

class _TimerView extends StatelessWidget {
  const _TimerView({
    required this.phase,
    required this.secondsLeft,
    required this.totalSets,
    required this.totalProgress,
    required this.phases,
    required this.totalDurationSeconds,
    required this.isRunning,
    required this.formatTime,
    required this.onStartPause,
    required this.onSeek,
    required this.onBack,
  });

  final Phase phase;
  final int secondsLeft;
  final int totalSets;
  final double totalProgress;
  final List<Phase> phases;
  final int totalDurationSeconds;
  final bool isRunning;
  final String Function(int) formatTime;
  final VoidCallback onStartPause;
  final ValueChanged<double> onSeek;
  final VoidCallback onBack;

  Color get _phaseColor => AppColors.forPhase(phase.type);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        _ScrubBar(
          progress: totalProgress,
          phases: phases,
          totalDurationSeconds: totalDurationSeconds,
          currentPhaseType: phase.type,
          onSeek: onSeek,
        ),
        if (phase.setIndex != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _SetIndicator(current: phase.setIndex!, total: totalSets),
        ] else
          const SizedBox(height: AppSpacing.xxl),
        const Spacer(),
        Text(phase.emoji, style: const TextStyle(fontSize: 52)),
        const SizedBox(height: AppSpacing.sm),
        Text(
          phase.label,
          style: AppTextStyles.phaseLabel.copyWith(color: _phaseColor),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(formatTime(secondsLeft), style: AppTextStyles.timerDisplay),
        const Spacer(),
        _StartPauseButton(isRunning: isRunning, color: _phaseColor, onTap: onStartPause),
        const SizedBox(height: AppSpacing.md),
        TextButton(
          onPressed: onBack,
          child: const Text('운동 그만하기'),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

// ─────────────────────────────────────────
// ScrubBar — 드래그/탭으로 구간 이동
// ─────────────────────────────────────────

class _ScrubBar extends StatelessWidget {
  const _ScrubBar({
    required this.progress,
    required this.phases,
    required this.totalDurationSeconds,
    required this.currentPhaseType,
    required this.onSeek,
  });

  final double progress;
  final List<Phase> phases;
  final int totalDurationSeconds;
  final PhaseType currentPhaseType;
  final ValueChanged<double> onSeek;

  void _handleInteraction(double localX, double width) {
    onSeek((localX / width).clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => _handleInteraction(d.localPosition.dx, width),
          onHorizontalDragUpdate: (d) => _handleInteraction(d.localPosition.dx, width),
          child: SizedBox(
            height: 36, // 터치 영역 넉넉하게
            width: width,
            child: CustomPaint(
              painter: _ScrubBarPainter(
                progress: progress,
                phases: phases,
                totalDurationSeconds: totalDurationSeconds,
                currentPhaseType: currentPhaseType,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ScrubBarPainter extends CustomPainter {
  _ScrubBarPainter({
    required this.progress,
    required this.phases,
    required this.totalDurationSeconds,
    required this.currentPhaseType,
  });

  final double progress;
  final List<Phase> phases;
  final int totalDurationSeconds;
  final PhaseType currentPhaseType;

  static const _trackH = 8.0;
  static const _thumbR = 9.0;

  Color _phaseColor(PhaseType t) => AppColors.forPhase(t);

  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height / 2; // 세로 중앙
    final trackTop = cy - _trackH / 2;
    final fullRect = Rect.fromLTWH(0, trackTop, size.width, _trackH);
    final fullRRect = RRect.fromRectAndRadius(fullRect, const Radius.circular(4));

    // 배경 트랙
    canvas.drawRRect(fullRRect, Paint()..color = AppColors.surfaceCard);

    // 페이즈별 색상 세그먼트 (진행된 부분만 채움)
    double accFrac = 0;
    for (final phase in phases) {
      final phaseFrac = phase.durationSeconds / totalDurationSeconds;
      final segX = accFrac * size.width;
      final segW = phaseFrac * size.width;

      // 이 페이즈에서 경과된 비율
      final elapsedInPhase = (progress - accFrac).clamp(0.0, phaseFrac);
      if (elapsedInPhase > 0) {
        final filledW = (elapsedInPhase / phaseFrac) * segW;
        final segRect = Rect.fromLTWH(segX, trackTop, filledW, _trackH);
        canvas.save();
        canvas.clipRRect(fullRRect);
        canvas.drawRect(segRect, Paint()..color = _phaseColor(phase.type));
        canvas.restore();
      }

      // 페이즈 경계선 (첫 번째 제외)
      if (accFrac > 0) {
        canvas.drawLine(
          Offset(segX, trackTop),
          Offset(segX, trackTop + _trackH),
          Paint()
            ..color = AppColors.surfaceTile1
            ..strokeWidth = 1.5,
        );
      }
      accFrac += phaseFrac;
    }

    // Thumb (흰 원 + 현재 페이즈 색 안쪽 원)
    final thumbX = (progress * size.width).clamp(_thumbR, size.width - _thumbR);
    final thumbColor = _phaseColor(currentPhaseType);

    canvas.drawCircle(Offset(thumbX, cy), _thumbR, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(thumbX, cy), _thumbR - 3,
        Paint()..color = thumbColor);
  }

  @override
  bool shouldRepaint(_ScrubBarPainter old) =>
      old.progress != progress || old.currentPhaseType != currentPhaseType;
}

// ─────────────────────────────────────────
// 나머지 위젯들
// ─────────────────────────────────────────

class _SetIndicator extends StatelessWidget {
  const _SetIndicator({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('세트 ', style: AppTextStyles.caption),
        Text('$current', style: AppTextStyles.bodyStrong.copyWith(fontSize: 18)),
        Text(' / $total', style: AppTextStyles.caption),
      ],
    );
  }
}

class _StartPauseButton extends StatelessWidget {
  const _StartPauseButton({required this.isRunning, required this.color, required this.onTap});

  final bool isRunning;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.4), blurRadius: 24, spreadRadius: 4),
          ],
        ),
        child: Icon(
          isRunning ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 44,
        ),
      ),
    );
  }
}

class _DoneView extends StatelessWidget {
  const _DoneView({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🎉', style: TextStyle(fontSize: 72)),
        const SizedBox(height: AppSpacing.lg),
        Text('운동 완료!', style: AppTextStyles.heroDisplay),
        const SizedBox(height: AppSpacing.sm),
        Text('오늘도 해냈어요. 대단해요!', style: AppTextStyles.body),
        const SizedBox(height: AppSpacing.xxl),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onBack,
            style: AppButtonStyles.primary(),
            child: const Text('홈으로'),
          ),
        ),
      ],
    );
  }
}
