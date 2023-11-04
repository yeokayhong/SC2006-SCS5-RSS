import 'package:flutter/material.dart';

class SearchButtonWidget extends StatelessWidget {
  final Function? onPressed;

  const SearchButtonWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: onPressed as void Function()?,
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 16, // font size
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 30, vertical: 15), // padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // rounded corners
          ),
        ),
        child: const Text('Get Directions'),
      ),
    );
  }
}
