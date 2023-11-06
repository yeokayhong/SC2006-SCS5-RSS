import 'package:flutter/material.dart';

class SearchButtonWidget extends StatelessWidget {
  final Function? onPressed;
  final bool isLoading;
  final bool isError;

  const SearchButtonWidget(
      {super.key,
      this.onPressed,
      this.isLoading = false,
      this.isError = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: onPressed as void Function()?,
        style: ElevatedButton.styleFrom(
          backgroundColor: isError ? Colors.red : Colors.blue,
          textStyle: const TextStyle(
            fontSize: 16, // font size
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 30, vertical: 15), // padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // rounded corners
          ),
        ),
        child: isError
            ? const Text('Please enter a valid address')
            : isLoading
                ? const Center(
                    child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(color: Colors.white)))
                : const Text('Get Directions'),
      ),
    );
  }
}
