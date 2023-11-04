import 'package:flutter/material.dart';

class WaitingTimeWidget extends StatelessWidget {
  final String duration;

  WaitingTimeWidget({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, color: Colors.grey),
          SizedBox(width: 10.0),
          Text('Wait for $duration min(s)',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
