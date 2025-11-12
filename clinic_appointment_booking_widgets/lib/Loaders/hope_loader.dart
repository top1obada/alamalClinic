import 'package:flutter/material.dart';

class HopeLoader extends StatefulWidget {
  const HopeLoader({Key? key}) : super(key: key);

  @override
  State<HopeLoader> createState() => _HopeLoaderState();
}

class _HopeLoaderState extends State<HopeLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FadeTransition(
        opacity: controller,
        child: ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ).createShader(bounds),
          child: const Text(
            'الأمل',
            style: TextStyle(
              fontSize: 48, // حجم أكبر للعربية
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Arial', // خط يدعم العربية بشكل أفضل
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
