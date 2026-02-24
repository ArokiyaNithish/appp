import 'package:flutter/material.dart';
import 'dart:math' as math;

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _skateboardController;
  late AnimationController _booksController;
  late AnimationController _loadingController;
  late AnimationController _backgroundController;
  late Animation<double> _skateboardAnimation;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();

    // Skateboard character animation (left to right)
    _skateboardController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _skateboardAnimation = Tween<double>(
      begin: -0.3,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _skateboardController,
      curve: Curves.linear,
    ));

    // Flying books animation
    _booksController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Loading bar animation
    _loadingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    // Background color transition
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _skateboardController.dispose();
    _booksController.dispose();
    _loadingController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFF5EC8E5),
                    const Color(0xFF4FB3D4),
                    _backgroundController.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF6DD5F0),
                    const Color(0xFF5EC8E5),
                    _backgroundController.value,
                  )!,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated wavy background shapes
                ...List.generate(5, (index) => _buildWaveShape(index, size)),

                // Flying books
                ...List.generate(4, (index) => _buildFlyingBook(index, size)),

                // Stars and decorative elements
                ...List.generate(6, (index) => _buildStar(index, size)),

                // Skateboard character
                _buildSkateboardCharacter(size),

                // Bottom section with app name and loading
                _buildBottomSection(size),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWaveShape(int index, Size size) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        final offset = (_backgroundController.value + index * 0.2) % 1.0;
        return Positioned(
          left: -100 + (offset * size.width * 0.5),
          top: 100 + (index * 120.0),
          child: Transform.rotate(
            angle: math.pi / 6 + (index * 0.3),
            child: CustomPaint(
              size: Size(300, 150),
              painter: WavePainter(
                color: _getWaveColor(index).withAlpha((0.6 * 255).toInt()),
                offset: offset,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getWaveColor(int index) {
    final colors = [
      const Color(0xFFFFC857), // Yellow/Orange
      const Color(0xFFFF6B9D), // Pink
      const Color(0xFF9B59B6), // Purple
      const Color(0xFFE74C3C), // Red
      const Color(0xFFF39C12), // Orange
    ];
    return colors[index % colors.length];
  }

  Widget _buildFlyingBook(int index, Size size) {
    return AnimatedBuilder(
      animation: _booksController,
      builder: (context, child) {
        final offset = (_booksController.value + index * 0.25) % 1.0;
        final yOffset = math.sin(offset * 2 * math.pi) * 30;

        return Positioned(
          left: 50 + (index * 80.0),
          top: 150 + (index * 100.0) + yOffset,
          child: Transform.rotate(
            angle: math.sin(offset * 2 * math.pi) * 0.3,
            child: Opacity(
              opacity: 0.7 + (math.sin(offset * 2 * math.pi) * 0.3),
              child: Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                  color: _getBookColor(index),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.2 * 255).toInt()),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 30,
                    height: 3,
                    color: Colors.white.withAlpha((0.5 * 255).toInt()),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBookColor(int index) {
    final colors = [
      const Color(0xFF9B59B6),
      const Color(0xFF3498DB),
      const Color(0xFFE74C3C),
      const Color(0xFFF39C12),
    ];
    return colors[index % colors.length];
  }

  Widget _buildStar(int index, Size size) {
    return AnimatedBuilder(
      animation: _booksController,
      builder: (context, child) {
        final offset = (_booksController.value + index * 0.15) % 1.0;
        final scale = 0.5 + (math.sin(offset * 2 * math.pi) * 0.5);

        return Positioned(
          left: 80 + (index * 60.0),
          top: 80 + (index * 90.0),
          child: Transform.scale(
            scale: scale,
            child: Icon(
              index % 2 == 0 ? Icons.star : Icons.circle,
              color: Colors.white.withAlpha((0.8 * 255).toInt()),
              size: index % 2 == 0 ? 20 : 12,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkateboardCharacter(Size size) {
    return AnimatedBuilder(
      animation: _skateboardAnimation,
      builder: (context, child) {
        return Positioned(
          left: size.width * _skateboardAnimation.value - 100,
          top: size.height * 0.35,
          child: SizedBox(
            width: 200,
            height: 250,
            child: CustomPaint(
              painter: SkateboardCharacterPainter(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection(Size size) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: size.height * 0.25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // App name
            const Text(
              'campzoo',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 30),
            // Loading bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: AnimatedBuilder(
                animation: _loadingAnimation,
                builder: (context, child) {
                  return Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _loadingAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF5EC8E5),
                              Color(0xFF3498DB),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for wavy shapes
class WavePainter extends CustomPainter {
  final Color color;
  final double offset;

  WavePainter({required this.color, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);

    for (double i = 0; i < size.width; i++) {
      path.lineTo(
        i,
        size.height * 0.5 +
            math.sin((i / size.width * 2 * math.pi) + (offset * 2 * math.pi)) *
                30,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}

// Custom painter for skateboard character
class SkateboardCharacterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Skateboard
    paint.color = const Color(0xFFE91E63);
    final skateboardRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(20, size.height - 40, 160, 15),
      const Radius.circular(8),
    );
    canvas.drawRRect(skateboardRect, paint);

    // Wheels
    paint.color = const Color(0xFFFFC107);
    canvas.drawCircle(Offset(40, size.height - 25), 12, paint);
    canvas.drawCircle(Offset(160, size.height - 25), 12, paint);

    // Legs
    paint.color = const Color(0xFF2C3E50);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(70, size.height - 100, 20, 65),
        const Radius.circular(10),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(110, size.height - 100, 20, 65),
        const Radius.circular(10),
      ),
      paint,
    );

    // Body (yellow shirt)
    paint.color = const Color(0xFFFFC857);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(60, size.height - 150, 80, 60),
        const Radius.circular(15),
      ),
      paint,
    );

    // Arms
    paint.color = const Color(0xFFFFC857);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(40, size.height - 140, 25, 50),
        const Radius.circular(12),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(135, size.height - 140, 25, 50),
        const Radius.circular(12),
      ),
      paint,
    );

    // Tablet/device in hand
    paint.color = const Color(0xFF5EC8E5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(30, size.height - 130, 35, 45),
        const Radius.circular(4),
      ),
      paint,
    );

    // Head
    paint.color = const Color(0xFFFFDBB5);
    canvas.drawCircle(Offset(100, size.height - 170), 35, paint);

    // Hair
    paint.color = const Color(0xFF2C3E50);
    final hairPath = Path();
    hairPath.moveTo(70, size.height - 180);
    hairPath.quadraticBezierTo(
      100,
      size.height - 210,
      130,
      size.height - 180,
    );
    hairPath.lineTo(130, size.height - 160);
    hairPath.quadraticBezierTo(
      100,
      size.height - 150,
      70,
      size.height - 160,
    );
    hairPath.close();
    canvas.drawPath(hairPath, paint);

    // Headphones
    paint.color = const Color(0xFFFFC107);
    canvas.drawCircle(Offset(70, size.height - 170), 15, paint);
    canvas.drawCircle(Offset(130, size.height - 170), 15, paint);

    // Headphone band
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 8;
    canvas.drawArc(
      Rect.fromLTWH(70, size.height - 205, 60, 40),
      math.pi,
      math.pi,
      false,
      paint,
    );

    // Face features
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFF2C3E50);
    canvas.drawCircle(Offset(90, size.height - 175), 3, paint);
    canvas.drawCircle(Offset(110, size.height - 175), 3, paint);

    // Smile
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawArc(
      Rect.fromLTWH(90, size.height - 170, 20, 15),
      0,
      math.pi,
      false,
      paint,
    );

    // Music notes
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFFE91E63);
    canvas.drawCircle(Offset(150, size.height - 190), 6, paint);
    canvas.drawRect(
      Rect.fromLTWH(155, size.height - 210, 3, 20),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
