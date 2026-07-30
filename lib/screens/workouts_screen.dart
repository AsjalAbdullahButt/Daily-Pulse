// Workouts screen - library with filter tabs and bento grid cards
// All, HIIT, Yoga, Strength filters with premium workout cards
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'HIIT', 'Yoga', 'Strength'];

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
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryContainer, width: 2),
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

            // Header
            Text(
              'PREMIUM ACCESS',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: AppColors.secondaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'WORKOUTS',
              style: GoogleFonts.montserrat(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),

            // Sliding Filter
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: List.generate(_filters.length, (index) {
                  final isSelected = _selectedFilter == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryContainer : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          _filters[index],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.onPrimaryContainer
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Hero Card - HIIT
            _WorkoutHeroCard(
              title: 'ULTRA BURN 500',
              category: 'HIIT',
              level: 'ADVANCED',
              duration: '45 min',
              calories: '520 kcal',
              imageUrl: 'https://images.unsplash.com/photo-1534258936925-c58bed479fcb?w=600&q=80',
              categoryColor: AppColors.primaryContainer,
            ),
            const SizedBox(height: 16),

            // Two side cards
            Row(
              children: [
                Expanded(
                  child: _WorkoutCard(
                    title: 'NEON FLOW',
                    category: 'YOGA',
                    subtitle: 'Mobility & Mental Focus',
                    duration: '30 min',
                    imageUrl: 'https://images.unsplash.com/photo-1545389336-cf090694435e?w=400&q=80',
                    categoryColor: AppColors.secondaryContainer,
                    height: 300.0,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _WorkoutCard(
                    title: 'TITAN LIFT',
                    category: 'Strength',
                    subtitle: 'Intermediate',
                    duration: '40 min',
                    imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400&q=80',
                    categoryColor: AppColors.primaryContainer,
                    height: 300.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Bottom row cards
            Row(
              children: [
                Expanded(
                  child: _WorkoutCard(
                    title: 'PULSE RUN',
                    category: 'Cardio',
                    subtitle: 'Beginner',
                    duration: '25 min',
                    imageUrl: 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=400&q=80',
                    categoryColor: AppColors.primaryContainer,
                    height: 240.0,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _WorkoutCard(
                    title: 'CORE MATRIX',
                    category: 'Abs',
                    subtitle: 'Expert',
                    duration: '15 min',
                    imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&q=80',
                    categoryColor: AppColors.primaryContainer,
                    height: 240.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // AI Coaching CTA
            Container(
      height: 220.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
                color: AppColors.surfaceContainer,
              ),
              child: Stack(
                children: [
                  // Gradient background
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primaryContainer.withValues(alpha: 0.15),
                            AppColors.primaryContainer.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LEVEL UP WITH',
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          'AI COACHING',
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondaryContainer,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Get personalized real-time form correction\nand adaptive training plans.',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.onSurfaceVariant,
                            height: 1.4,
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
                                color: AppColors.primaryContainer.withValues(alpha: 0.3),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Text(
                            'UNLOCK NOW',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              color: AppColors.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutHeroCard extends StatelessWidget {
  final String title;
  final String category;
  final String level;
  final String duration;
  final String calories;
  final String imageUrl;
  final Color categoryColor;

  const _WorkoutHeroCard({
    required this.title,
    required this.category,
    required this.level,
    required this.duration,
    required this.calories,
    required this.imageUrl,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.7),
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      level,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.timer_outlined, color: AppColors.secondaryContainer, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    duration.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Icon(Icons.local_fire_department_outlined, color: AppColors.secondaryContainer, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    calories.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final String title;
  final String category;
  final String subtitle;
  final String duration;
  final String imageUrl;
  final Color categoryColor;
  final double height;

  const _WorkoutCard({
    required this.title,
    required this.category,
    required this.subtitle,
    required this.duration,
    required this.imageUrl,
    required this.categoryColor,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (category == 'YOGA')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSecondaryContainer,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule_outlined, color: AppColors.secondaryContainer, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    duration.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
