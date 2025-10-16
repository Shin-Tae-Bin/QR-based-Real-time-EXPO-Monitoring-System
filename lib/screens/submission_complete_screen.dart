// lib/screens/submission_complete_screen.dart

import 'package:flutter/material.dart';

class SubmissionCompleteScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSuccess;

  const SubmissionCompleteScreen({
    Key? key,
    this.title = '부스 등록이 완료되었습니다.',
    this.subtitle = '정상적으로 처리되었습니다.', // 부제 수정
    this.isSuccess = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color circleColor =
        isSuccess ? const Color(0xFF4CAF50) : const Color(0xFFFF5252);
    final IconData icon = isSuccess ? Icons.check : Icons.close;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                ),
                child: Icon(icon, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6C6C6C),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
             Column(
  children: [
    // Image.asset 제거하고 아이콘으로 대체
    const Icon(
      Icons.health_and_safety,
      size: 40,
      color: Color(0xFF003d82),
    ),
    const SizedBox(height: 12),
    RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'Health ',
            style: TextStyle(color: Color(0xFF003d82)),
          ),
          TextSpan(
            text: 'EXPO',
            style: TextStyle(color: Color(0xFFd6006e)),
          ),
        ],
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

