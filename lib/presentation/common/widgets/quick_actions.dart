import 'package:flutter/material.dart';

class QuickActionsRow extends StatelessWidget {
  final VoidCallback onNailTap;
  final VoidCallback onLashTap;
  final VoidCallback onBrowTap;
  final VoidCallback onEstimateTap;

  const QuickActionsRow({
    super.key,
    required this.onNailTap,
    required this.onLashTap,
    required this.onBrowTap,
    required this.onEstimateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuickActionButton(icon: Icons.brush, label: '네일', onTap: onNailTap),
        QuickActionButton(
          icon: Icons.visibility,
          label: '속눈썹',
          onTap: onLashTap,
        ),
        QuickActionButton(
          icon: Icons.face_retouching_natural,
          label: '눈썹',
          onTap: onBrowTap,
        ),
        QuickActionButton(
          icon: Icons.calculate,
          label: '견적',
          onTap: onEstimateTap,
        ),
      ],
    );
  }
}

class QuickActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<QuickActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _pressed ? 0.94 : 1,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: Container(
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Icon(widget.icon, color: color.primary),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(widget.label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
