import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/patient_login_provider.dart';
import 'package:clinic_appointment_booking_ui/PatientLoginUI/patient_login_ui.dart';
import 'package:clinic_appointment_booking_ui/PatientMainMenuUI/patient_main_menu_ui.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:clinic_appointment_booking_providers/RefreshTokenProviders/login_by_refresh_Token_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _gradientAnimation;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 2 * pi, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 2.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _gradientAnimation = ColorTween(
      begin: Colors.blue.shade900,
      end: Colors.purple.shade800,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed && !_hasNavigated) {
        _hasNavigated = true;
        await _executeAfterAnimation();
      }
    });
  }

  Future<void> _executeAfterAnimation() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      var refreshTokenLogin = PVRefreshToken();
      var result = await refreshTokenLogin.login();

      if (mounted) {
        if (result) {
          PVBaseCurrentLoginInfo loginProvider = refreshTokenLogin;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(value: loginProvider),
                      ChangeNotifierProvider(
                        create: (context) => PVMainMenuUiPagesProvider(),
                      ),
                    ],
                    child: const PatientMainMenuUi(),
                  ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (_) => PVPatientLogin()),
                    ],
                    child: const PatientLoginScreenUI(),
                  ),
            ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => PVPatientLogin()),
                  ],
                  child: const PatientLoginScreenUI(),
                ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildArabicWord() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double wordProgress = (_controller.value - 0.3).clamp(0.0, 1.0);
        double wave = sin(wordProgress * pi * 4) * 0.05;
        double scale = 0.9 + wordProgress * 0.2;
        double glow = sin(wordProgress * pi * 8) * 0.3 + 0.7;

        return Transform.scale(
          scale: scale + wave,
          child: Container(
            width: MediaQuery.of(context).size.width, // FULL SCREEN WIDTH
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade600,
                  Colors.lightBlue.shade500,
                  Colors.cyan.shade500,
                  Colors.teal.shade400,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.6 * glow),
                  blurRadius: 30,
                  spreadRadius: 8,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.4 * glow),
                  blurRadius: 25,
                  spreadRadius: 5,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 3,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.9),
                width: 3,
              ),
            ),
            child: ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.blue.shade100,
                      Colors.cyan.shade100,
                      Colors.white,
                    ],
                    stops: const [0.0, 0.2, 0.8, 1.0],
                  ).createShader(bounds),
              child: Text(
                "عيادة الأمل",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:
                      MediaQuery.of(context).size.width *
                      0.08, // RESPONSIVE FONT
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 20,
                      offset: const Offset(4, 4),
                    ),
                    Shadow(
                      color: Colors.blue.withValues(alpha: 0.6),
                      blurRadius: 25,
                      offset: const Offset(-3, -3),
                    ),
                    Shadow(
                      color: Colors.cyan.withValues(alpha: 0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return AnimatedOpacity(
      opacity: _fadeAnimation.value > 0.5 ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: Transform.translate(
        offset: Offset(0, 20 - (_fadeAnimation.value * 20)),
        child: Container(
          width: MediaQuery.of(context).size.width, // FULL SCREEN WIDTH
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withValues(alpha: 0.3),
                Colors.lightBlue.withValues(alpha: 0.2),
                Colors.cyan.withValues(alpha: 0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 20,
                spreadRadius: 3,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 25,
                spreadRadius: 2,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Text(
            "رعاية طبية متكاملة لصحة أفضل وحياة أجمل",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:
                  MediaQuery.of(context).size.width * 0.045, // RESPONSIVE FONT
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.95),
              height: 1.5,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.7),
                  blurRadius: 12,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  _gradientAnimation.value!,
                  Color.lerp(
                    Colors.blue.shade800,
                    Colors.purple.shade700,
                    _fadeAnimation.value,
                  )!,
                  Color.lerp(
                    Colors.indigo.shade900,
                    Colors.deepPurple.shade800,
                    _fadeAnimation.value,
                  )!,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Background stars/animation
                ...List.generate(20, (index) {
                  return Positioned(
                    left:
                        Random().nextDouble() *
                        MediaQuery.of(context).size.width,
                    top:
                        Random().nextDouble() *
                        MediaQuery.of(context).size.height,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 2 + index),
                      curve: Curves.easeInOut,
                      width: 4 + Random().nextDouble() * 8,
                      height: 4 + Random().nextDouble() * 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.1 + _fadeAnimation.value * 0.2,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),

                // Main content - FULL SCREEN LAYOUT
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch, // STRETCH TO FILL WIDTH
                  children: [
                    // Medical icon with animation
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: RotationTransition(
                        turns: _rotationAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.blue.shade400,
                                Colors.lightBlue.shade300,
                                Colors.cyan.shade400,
                                Colors.teal.shade300,
                              ],
                              stops: const [0.0, 0.3, 0.7, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.8),
                                blurRadius: 30,
                                spreadRadius: 5,
                                offset: const Offset(0, 5),
                              ),
                              BoxShadow(
                                color: Colors.cyan.withValues(alpha: 0.6),
                                blurRadius: 40,
                                spreadRadius: 3,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                ),
                                BoxShadow(
                                  color: Colors.blue.withValues(alpha: 0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, -5),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Medical cross
                                Icon(
                                  Icons.medical_services,
                                  size:
                                      MediaQuery.of(context).size.width *
                                      0.15, // RESPONSIVE ICON
                                  color: Colors.blue.shade700,
                                ),
                                // Pulse animation
                                if (_controller.value > 0.3)
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width:
                                        100 +
                                        sin(_controller.value * pi * 8) * 10,
                                    height:
                                        100 +
                                        sin(_controller.value * pi * 8) * 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.green.withValues(
                                          alpha: 0.5,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ), // RESPONSIVE SPACING
                    // Arabic word (connected) - FULL WIDTH
                    SlideTransition(
                      position: _slideAnimation,
                      child: _buildArabicWord(),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ), // RESPONSIVE SPACING
                    // Subtitle - FULL WIDTH
                    _buildSubtitle(),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ), // RESPONSIVE SPACING
                    // Progress indicator
                    AnimatedOpacity(
                      opacity: _fadeAnimation.value > 0.7 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        width:
                            MediaQuery.of(context).size.width *
                            0.3, // RESPONSIVE WIDTH
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.cyan.shade400,
                              Colors.teal.shade300,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue.shade400,
                          ),
                          value: _controller.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
