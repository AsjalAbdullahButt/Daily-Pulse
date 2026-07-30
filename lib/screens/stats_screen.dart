// Health Stats screen - Performance Matrix with heart rate chart,
// quick stats, and recent activities
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _selectedRange = 0;
  final List<String> _ranges = ['Daily', 'Weekly', 'Monthly'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DAILY PULSE',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.search_outlined, color: AppColors.primary, size: 22),
                    const SizedBox(width: 16),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.3)),
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: AppColors.onSurface, size: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.settings_outlined, color: AppColors.primary, size: 22),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Header
            Text(
              'PERFORMANCE MATRIX',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: AppColors.secondaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Health Stats',
              style: GoogleFonts.montserrat(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Range Toggle
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_ranges.length, (index) {
                    final isSelected = _selectedRange == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedRange = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryContainer : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryContainer.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          _ranges[index],
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.onPrimaryContainer
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bento Grid
            // Row 1: Heart Rate Chart (wide) + Quick Stats
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heart Rate Chart
                Expanded(
                  flex: 3,
                  child: _GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
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
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    'Last 24 Hours Analysis',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '72',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.secondaryContainer,
                                    ),
                                  ),
                                  Text(
                                    'BPM AVG',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondaryContainer.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Heart rate chart
                          SizedBox(
                            height: 200,
                            child: CustomPaint(
                              size: const Size(double.infinity, 200),
                              painter: _HeartRateChartPainter(
                                lineColor: AppColors.secondaryContainer,
                                fillColor: AppColors.secondaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Time labels
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _TimeLabel('00:00'),
                              _TimeLabel('06:00'),
                              _TimeLabel('12:00'),
                              _TimeLabel('18:00'),
                              _TimeLabel('23:59'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Quick Stats Column
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Recovery Score
                      _GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(
                                Icons.battery_0_bar_rounded,
                                color: AppColors.primaryContainer,
                                size: 36,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'RECOVERY SCORE',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '84%',
                                style: GoogleFonts.montserrat(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'Optimal for Intensity',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Deep Sleep
                      _GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(
                                Icons.nights_stay_rounded,
                                color: AppColors.secondaryContainer,
                                size: 36,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'DEEP SLEEP',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '2h 40m',
                                style: GoogleFonts.montserrat(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                '+12% from average',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
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

            // Recent Activities
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
                          'Recent Activities',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'View All',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _ActivityItem(
                      icon: Icons.fitness_center_rounded,
                      title: 'Hypertrophy Session',
                      subtitle: 'Today • 10:24 AM',
                      value: '482 kcal',
                      valueSub: '54 min',
                      iconColor: AppColors.primaryContainer,
                    ),
                    const SizedBox(height: 8),
                    _ActivityItem(
                      icon: Icons.directions_run_rounded,
                      title: 'VO2 Max Sprint',
                      subtitle: 'Yesterday • 6:15 PM',
                      value: '310 kcal',
                      valueSub: '22 min',
                      iconColor: AppColors.secondaryContainer,
                    ),
                    const SizedBox(height: 8),
                    _ActivityItem(
                      icon: Icons.pool_rounded,
                      title: 'Active Recovery',
                      subtitle: 'Yesterday • 8:00 AM',
                      value: '125 kcal',
                      valueSub: '15 min',
                      iconColor: AppColors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ],
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

class _HeartRateChartPainter extends CustomPainter {
  final Color lineColor;
  final Color fillColor;

  _HeartRateChartPainter({required this.lineColor, required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Data points
    final points = [
      Offset(0, h * 0.6),
      Offset(w * 0.1, h * 0.7),
      Offset(w * 0.2, h * 0.3),
      Offset(w * 0.3, h * 0.5),
      Offset(w * 0.4, h * 0.7),
      Offset(w * 0.5, h * 0.2),
      Offset(w * 0.6, h * 0.45),
      Offset(w * 0.7, h * 0.7),
      Offset(w * 0.8, h * 0.35),
      Offset(w * 0.9, h * 0.55),
      Offset(w, h * 0.45),
    ];

    // Fill area
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          fillColor.withValues(alpha: 0.2),
          fillColor.withValues(alpha: 0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final fillPath = Path()..moveTo(0, h);
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        fillPath.lineTo(points[i].dx, points[i].dy);
      } else {
        final prev = points[i - 1];
        final mid = Offset((prev.dx + points[i].dx) / 2, (prev.dy + points[i].dy) / 2);
        fillPath.quadraticBezierTo(prev.dx, prev.dy, mid.dx, mid.dy);
      }
    }
    fillPath.lineTo(w, h);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePath = Path();
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        linePath.moveTo(points[i].dx, points[i].dy);
      } else {
        final prev = points[i - 1];
        final mid = Offset((prev.dx + points[i].dx) / 2, (prev.dy + points[i].dy) / 2);
        linePath.quadraticBezierTo(prev.dx, prev.dy, mid.dx, mid.dy);
      }
    }
    canvas.drawPath(linePath, linePaint);

    // Active point
    final centerPoint = points[5];
    canvas.drawCircle(centerPoint, 5, Paint()..color = lineColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TimeLabel extends StatelessWidget {
  final String label;

  const _TimeLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 11,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final String valueSub;
  final Color iconColor;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.valueSub,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                valueSub,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
