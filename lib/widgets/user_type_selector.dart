import 'package:flutter/material.dart';
import 'package:expoqr/screens/registration_screen.dart';

class UserTypeSelector extends StatelessWidget {
  final UserType selectedUserType;
  final ValueChanged<UserType> onChanged;

  const UserTypeSelector({
    super.key,
    required this.selectedUserType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: LayoutBuilder(
        builder: (context, constraints) {
          final values = UserType.values;
          final double segmentWidth = constraints.maxWidth / values.length;
          final int selectedIndex = values.indexOf(selectedUserType);

          return SizedBox(
            height: 48,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOut,
                  left: selectedIndex * segmentWidth,
                  top: 2,
                  bottom: 2,
                  width: segmentWidth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8A2BE2), Color(0xFFFF1493)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8A2BE2).withOpacity(0.28),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: values.map((type) {
                    final bool isSelected = selectedUserType == type;
                    return Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => onChanged(type),
                            child: Center(
                              child: _buildOption(type, isSelected),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(growable: false),
                ),
              ],
            ),
          );
        },
      ),
      ),
    );
  }

  String _labelFor(UserType type) {
    switch (type) {
      case UserType.external:
        return '외부인';
      case UserType.student:
        return '재학생';
      case UserType.staff:
        return '교직원';
    }
  }

  Widget _buildOption(UserType type, bool isSelected) {
    final iconColor = isSelected ? Colors.white : const Color(0xFF4A4A4A);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _iconFor(type),
          size: 20,
          color: iconColor,
        ),
        const SizedBox(width: 6),
        Text(
          _labelFor(type),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  IconData _iconFor(UserType type) {
    switch (type) {
      case UserType.student:
        return Icons.school;
      case UserType.staff:
        return Icons.badge_outlined;
      case UserType.external:
        return Icons.public;
    }
  }
}
