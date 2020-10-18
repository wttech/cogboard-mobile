import 'package:flutter/material.dart';

class DetailsContainer extends StatelessWidget {
  final List<Widget> children;

  DetailsContainer({
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            ...children,
          ],
        ),
      ),
    );
  }
}
