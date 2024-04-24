import 'package:flutter/material.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Harap menunggu:",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 40,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 207,
                  height: 207,
                  child: CircularProgressIndicator(
                    strokeWidth: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
