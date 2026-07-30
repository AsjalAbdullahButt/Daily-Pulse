// Splash / Onboarding screen with DAILY PULSE branding
// Electric Lime and Cyan Glow, floating logo, "GET STARTED" CTA
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn1;
  late Animation<double> _fadeIn2;
  late Animation<double> _fadeIn3;
  late Animation<double> _fadeIn4;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _fadeIn1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.25, curve: Curves.easeOut)),
    );
    _fadeIn2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.45, curve: Curves.easeOut)),
    );
    _fadeIn3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.65, curve: Curves.easeOut)),
    );
    _fadeIn4 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.85, curve: Curves.easeOut)),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background radial glow
          Positioned(
            right: -100,
            bottom: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondaryContainer.withValues(alpha: 0.08),
                    AppColors.secondaryContainer.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Logo with glow
                  FadeTransition(
                    opacity: _fadeIn1,
                    child: _FloatingLogo(),
                  ),
                  const SizedBox(height: 32),
                  // Branding text
                  FadeTransition(
                    opacity: _fadeIn2,
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [AppColors.secondaryContainer, AppColors.primaryContainer],
                          ).createShader(bounds),
                          child: Text(
                            'DAILY PULSE',
                            style: GoogleFonts.montserrat(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.5,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'PRECISION PERFORMANCE TRACKING',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 4,
                            color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                  // GET STARTED button
                  FadeTransition(
                    opacity: _fadeIn3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: _PulseButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Bottom tagline
                  FadeTransition(
                    opacity: _fadeIn4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 32, height: 1, color: AppColors.outline.withValues(alpha: 0.4)),
                        const SizedBox(width: 12),
                        Text(
                          'V.2.4.0 ELITE FLOW',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3,
                            color: AppColors.outline.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(width: 32, height: 1, color: AppColors.outline.withValues(alpha: 0.4)),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingLogo extends StatefulWidget {
  @override
  State<_FloatingLogo> createState() => _FloatingLogoState();
}

class _FloatingLogoState extends State<_FloatingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnim.value),
          child: child,
        );
      },
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryContainer.withValues(alpha: 0.15),
              blurRadius: 60,
              spreadRadius: 20,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.favorite_rounded,
            size: 100,
            color: AppColors.primaryContainer,
          ),
        ),
      ),
    );
  }
}

class _PulseButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _PulseButton({required this.onPressed});

  @override
  State<_PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<_PulseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnim.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          widget.onPressed();
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'GET STARTED',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onPrimaryContainer,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: AppColors.onPrimaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}
