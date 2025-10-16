import 'package:flutter/material.dart';
import 'dart:async';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(75.0); // 상단 여백 포함한 맞춤 높이

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  Timer? _timer;

 

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    const Color startColor = Color(0xFF6A1B9A);
    const Color endColor = Color(0xFFFE3D8C);

    final double statusBar = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: widget.preferredSize.height + statusBar,
      child: Stack(
        children: [
          Container(
            height: widget.preferredSize.height + statusBar,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [startColor, endColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: statusBar,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
               Row(
  children: [
    // Image.asset 대신 텍스트 로고 사용
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'EXPO',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
    const SizedBox(width: 30),
    Text(
      widget.title,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 0.4,
      ),
    ),
  ],
),

                
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
