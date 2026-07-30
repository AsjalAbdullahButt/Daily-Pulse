// Main shell screen with bottom navigation bar
// 5 tabs: Home, Workouts, Coach, Stats, Profile
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'workouts_screen.dart';
import 'chat_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    WorkoutsScreen(),
    ChatScreen(),
    StatsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 0),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.15),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 32,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.secondaryContainer,
            unselectedItemColor: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
            selectedFontSize: 11,
            unselectedFontSize: 11,
            selectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            items: [
              _navItem(Icons.home_rounded, Icons.home_rounded, 'Home'),
              _navItem(Icons.fitness_center_outlined, Icons.fitness_center, 'Workouts'),
              _navItem(Icons.smart_toy_outlined, Icons.smart_toy, 'Coach'),
              _navItem(Icons.bar_chart_outlined, Icons.bar_chart_rounded, 'Stats'),
              _navItem(Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(IconData outlined, IconData filled, String label) {
    return BottomNavigationBarItem(
      icon: Icon(outlined, size: 26),
      activeIcon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryContainer.withValues(alpha: 0.3),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(filled, size: 26),
      ),
      label: label,
    );
  }
}
