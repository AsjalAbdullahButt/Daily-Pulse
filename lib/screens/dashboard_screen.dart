// Dashboard screen - Home tab with bento grid layout
// Progress ring, heart rate, sleep, activity analysis, workout CTA
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/logs_provider.dart';
import '../providers/habits_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LogsProvider>().loadToday();
      context.read<HabitsProvider>().loadHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final logs = context.watch<LogsProvider>();
    final habits = context.watch<HabitsProvider>();

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: () async {
          await logs.loadToday();
          await habits.loadHabits();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top App Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryContainer, width: 2.0),
                        ),
                        child: const Center(
                          child: Icon(Icons.person, color: AppColors.onSurface, size: 22),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'DAILY PULSE',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.settings_outlined, color: AppColors.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 28),

              // Greeting
              Text(
                'ACTIVE NOW',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: AppColors.secondaryContainer,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back',
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),

              // Bento Grid
              // Row 1: Progress ring + Stats column
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Progress Ring
                  Expanded(
                    flex: 3,
                    child: _GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today's Progress",
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "You're on fire!",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '🔥',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'STREAK: 12 DAYS',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                      color: AppColors.primaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Progress Ring
                            Center(
                              child:                              SizedBox(
                                width: 200.0,
                                height: 200.0,
                                child: CustomPaint(
                                  painter: _ProgressRingPainter(
                                    progress: 0.82,
                                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                                    gradientColors: const [
                                      AppColors.secondaryContainer,
                                      AppColors.primaryContainer,
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '12.4k',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        Text(
                                          'STEPS',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Stats Column
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Heart Rate Card
                        _GlassCard(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Heart Rate',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                            color: AppColors.secondaryContainer,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '72',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 4),
                                              child: Text(
                                                'BPM',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: AppColors.onSurfaceVariant,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.favorite_rounded,
                                      color: AppColors.secondaryContainer,
                                      size: 28,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Pulse line SVG equivalent
                                SizedBox(
                                  height: 40.0,
                                  child: CustomPaint(
                                    size: const Size(double.infinity, 40),
                                    painter: _HeartRateLinePainter(
                                      color: AppColors.secondaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Sleep Card
                        _GlassCard(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sleep',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                            color: AppColors.primaryContainer,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '7h 42m',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.bedtime_rounded,
                                      color: AppColors.primaryContainer,
                                      size: 28,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Progress bar
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Container(
                                          height: 8.0,
                                          color: Colors.white.withValues(alpha: 0.05),
                                          child: FractionallySizedBox(
                                            alignment: Alignment.centerLeft,
                                            widthFactor: 0.88,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryContainer,
                                                borderRadius: BorderRadius.circular(4),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.primaryContainer.withValues(alpha: 0.3),
                                                    blurRadius: 8,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '88%',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Deep sleep increased by 14%',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Activity Analysis
              _GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Activity Analysis',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                _FilterChip(label: 'Week', selected: true),
                                _FilterChip(label: 'Month', selected: false),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Bar chart
                      SizedBox(
                        height: 180.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _BarColumn(label: 'MON', height: 0.5, isToday: false),
                            _BarColumn(label: 'TUE', height: 0.65, isToday: false),
                            _BarColumn(label: 'WED', height: 0.85, isToday: true),
                            _BarColumn(label: 'THU', height: 0.4, isToday: false),
                            _BarColumn(label: 'FRI', height: 0.75, isToday: false),
                            _BarColumn(label: 'SAT', height: 0.9, isToday: false),
                            _BarColumn(label: 'SUN', height: 0.55, isToday: false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Workout CTA
              _WorkoutCta(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: child,
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final List<Color> gradientColors;

  _ProgressRingPainter({
    required this.progress,
    required this.backgroundColor,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 16;
    const strokeWidth = 20;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * progress,
      false,
      gradient,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _HeartRateLinePainter extends CustomPainter {
  final Color color;

  _HeartRateLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final w = size.width;
    final h = size.height;
    final midY = h / 2;

    path.moveTo(0, midY);
    path.lineTo(w * 0.15, midY);
    path.lineTo(w * 0.2, h * 0.15);
    path.lineTo(w * 0.25, h * 0.85);
    path.lineTo(w * 0.3, midY);
    path.lineTo(w * 0.5, midY);
    path.lineTo(w * 0.55, h * 0.1);
    path.lineTo(w * 0.62, h * 0.9);
    path.lineTo(w * 0.7, midY);
    path.lineTo(w, midY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  final String label;
  final double height;
  final bool isToday;

  const _BarColumn({
    required this.label,
    required this.height,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            height: 160.0 * height,
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.primaryContainer.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              border: isToday
                  ? Border(
                      top: BorderSide(
                        color: AppColors.primaryContainer,
                        width: 2.0,
                      ),
                    )
                  : null,
            ),
            child: isToday
                ? Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryContainer.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
              color: isToday ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutCta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1534258936925-c58bed479fcb?w=600&q=80',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              AppColors.background.withValues(alpha: 0.4),
              Colors.transparent,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Push Your Boundaries\nToday',
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryContainer.withValues(alpha: 0.4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'START WORKOUT',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        color: AppColors.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.onPrimaryContainer,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
