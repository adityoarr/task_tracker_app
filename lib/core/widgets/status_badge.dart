import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final bool isDone;
  final VoidCallback? onTap;

  const StatusBadge({super.key, required this.isDone, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDone ? Colors.green.shade50 : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDone ? Colors.green.shade300 : Colors.orange.shade300),
        ),
        child: Text(
          isDone ? 'Done' : 'Pending',
          style: TextStyle(
            color: isDone ? Colors.green.shade700 : Colors.orange.shade800,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}