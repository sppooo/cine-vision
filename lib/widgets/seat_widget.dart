import 'package:flutter/material.dart';

class SeatWidget extends StatelessWidget {
  final String status;
  final VoidCallback onTap;

  const SeatWidget({required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color seatColor;
    switch (status) {
      case 'selected':
        seatColor = Colors.pinkAccent.shade100;
        break;
      case 'reserved':
        seatColor = Colors.grey.shade600;
        break;
      default:
        seatColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: status == 'reserved' ? null : onTap,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: seatColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
