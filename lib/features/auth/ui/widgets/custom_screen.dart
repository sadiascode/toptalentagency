import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';  // Import flutter_svg package

class CustomScreen extends StatefulWidget {
  final String svgPath;
  final double svgHeight;
  final double svgWidth;
  final Widget child;

  const CustomScreen({
    super.key,
    required this.svgPath,
    required this.svgHeight,
    required this.svgWidth,
    required this.child,
  });

  @override
  State<CustomScreen> createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff101828),  // Dark background
      body: Stack(
        children: [
          // Background color (dark)
          Container(color: const Color(0xff101828)),

          // Positioned SVG image at the top
          Positioned(
            top: 110,
            left: 10,
            right: 10,
            child: Center(
              child: SvgPicture.asset(
                widget.svgPath,  // Path to the SVG image
                height: widget.svgHeight,  // Height of the SVG
                width: widget.svgWidth,    // Width of the SVG
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Bottom container with the content inside it
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.6,
              widthFactor: 0.93,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                ),
                child: widget.child,  // Pass the content of the form or any widget here
              ),
            ),
          ),
        ],
      ),
    );
  }
}
