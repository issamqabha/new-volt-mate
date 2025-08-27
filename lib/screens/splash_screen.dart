import 'dart:math';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  late AnimationController _effectsController;

  final int sparksCount = 15;
  final Random _random = Random();

  late List<double> sparksAngles;
  late List<double> sparksLengths;

  final double logoSize = 150;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_logoController);

    _logoController.forward();

    sparksAngles = List.generate(sparksCount, (_) => _random.nextDouble() * 2 * pi);
    sparksLengths = List.generate(sparksCount, (_) => _random.nextDouble() * 20 + 10);

    _effectsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // الانتقال بعد 5 ثواني إلى LoginScreen
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _effectsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4B0082), Color(0xFF1A1A40)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _effectsController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _SplashElectricPainter(
                        progress: _effectsController.value,
                        sparksAngles: sparksAngles,
                        sparksLengths: sparksLengths,
                        centerOffset: Offset(logoSize / 2, logoSize / 2),
                      ),
                      child: SizedBox(width: logoSize, height: logoSize),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _effectsController,
                  builder: (context, child) {
                    double glowSize = logoSize + 50 + 20 * sin(_effectsController.value * pi * 2);
                    return Container(
                      width: glowSize,
                      height: glowSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellowAccent.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellowAccent.withOpacity(0.5),
                            blurRadius: 20 + 10 * sin(_effectsController.value * pi * 2),
                            spreadRadius: 5 + 5 * sin(_effectsController.value * pi * 2),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'VOLTMATE',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _opacityAnimation.value,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.bolt,
                        size: 150,
                        color: Colors.yellowAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashElectricPainter extends CustomPainter {
  final double progress;
  final List<double> sparksAngles;
  final List<double> sparksLengths;
  final Offset centerOffset;

  _SplashElectricPainter({
    required this.progress,
    required this.sparksAngles,
    required this.sparksLengths,
    required this.centerOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint sparkPaint = Paint()
      ..color = Colors.yellowAccent.withOpacity(0.8)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < sparksAngles.length; i++) {
      final angle = sparksAngles[i];
      final length = sparksLengths[i] * progress;
      final path = Path();
      final step = length / 4;
      path.moveTo(centerOffset.dx, centerOffset.dy);
      path.lineTo(centerOffset.dx + cos(angle) * step, centerOffset.dy + sin(angle) * step);
      path.lineTo(centerOffset.dx + cos(angle + 0.2) * step * 2, centerOffset.dy + sin(angle + 0.2) * step * 2);
      path.lineTo(centerOffset.dx + cos(angle) * step * 3, centerOffset.dy + sin(angle) * step * 3);
      path.lineTo(centerOffset.dx + cos(angle + 0.1) * length, centerOffset.dy + sin(angle + 0.1) * length);
      canvas.drawPath(path, sparkPaint);
    }

    final Paint wavePaint = Paint()
      ..color = Colors.yellowAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (int i = 1; i <= 3; i++) {
      double radius = 50.0 * i + progress * 30;
      canvas.drawCircle(centerOffset, radius, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SplashElectricPainter oldDelegate) => true;
}
