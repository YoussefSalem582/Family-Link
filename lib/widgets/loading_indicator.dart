import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;

  const LoadingIndicator({Key? key, this.message, this.size = 50})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          if (message != null) ...[
            SizedBox(height: 16),
            Text(message!, style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ],
      ),
    );
  }
}
