import 'package:flutter/material.dart';

/// ------------------- ClaimedButton -------------------
class ClaimedButton extends StatelessWidget {
  final Widget child;

  const ClaimedButton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white70),
        child: child,
      ),
    );
  }
}

/// ------------------- LockButton -------------------
class LockButton extends StatelessWidget {
  const LockButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.lock,
        color: Colors.grey,
        size: 20,
      ),
    );
  }
}

/// ------------------- ShinyButton -------------------
class ShinyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const ShinyButton({super.key, required this.child, this.onTap});

  @override
  State<ShinyButton> createState() => _ShinyButtonState();
}

class _ShinyButtonState extends State<ShinyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.0),
                ],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment(-1.0 + 2.0 * _controller.value, -0.3),
                end: Alignment(1.0 + 2.0 * _controller.value, 0.3),
              ).createShader(rect);
            },
            blendMode: BlendMode.srcATop,
            child: widget.child,
          );
        },
      ),
    );
  }
}
