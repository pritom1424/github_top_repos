import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final int stars;
  final String formattedDate;
  const InfoRow({super.key, required this.stars, required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, size: 18, color: Colors.amber),
        const SizedBox(width: 4),
        Text('$stars'),
        const SizedBox(width: 16),
        const Icon(Icons.update, size: 18, color: Colors.blue),
        const SizedBox(width: 4),
        Text(formattedDate),
      ],
    );
  }
}
