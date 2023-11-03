import 'package:flutter/material.dart';

class LeafIcon extends StatelessWidget {
  const LeafIcon({
    super.key,
    this.width = 80,
    this.height = 130,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: width,
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 3,
                left: 10,
                child: Icon(
                  Icons.energy_savings_leaf,
                  color: Colors.green.shade900,
                  size: width - 10,
                ),
              ),
              Transform.rotate(
                angle: 5.6,
                child: Icon(
                  Icons.energy_savings_leaf,
                  color: const Color.fromARGB(255, 50, 194, 122),
                  size: width - 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({
    super.key,
    this.size = 150,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(70, 50, 194, 122),
        borderRadius: BorderRadius.circular(80),
      ),
      child: LeafIcon(
        width: size * 0.53333,
        height: size * 0.80,
      ),
    );
  }
}
