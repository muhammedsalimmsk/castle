import 'package:flutter/material.dart';

enum PasswordStrength { weak, medium, strong }

class PasswordStrengthIndicator extends StatefulWidget {
  final TextEditingController controller;

  const PasswordStrengthIndicator({super.key, required this.controller});

  @override
  State<PasswordStrengthIndicator> createState() => _PasswordStrengthIndicatorState();
}

class _PasswordStrengthIndicatorState extends State<PasswordStrengthIndicator> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateStrength);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateStrength);
    super.dispose();
  }

  void _updateStrength() {
    setState(() {});
  }

  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Length checks
    if (password.length >= 6) score++;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password)) score++; // lowercase
    if (RegExp(r'[A-Z]').hasMatch(password)) score++; // uppercase
    if (RegExp(r'[0-9]').hasMatch(password)) score++; // numbers
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++; // special chars

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  Color _getColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.green;
    }
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  double _getStrengthValue(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 0.33;
      case PasswordStrength.medium:
        return 0.66;
      case PasswordStrength.strong:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final password = widget.controller.text;
    final strength = _calculateStrength(password);
    final color = password.isEmpty ? Colors.grey : _getColor(strength);
    final text = password.isEmpty ? 'Enter password' : _getStrengthText(strength);
    final value = password.isEmpty ? 0.0 : _getStrengthValue(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Password Strength Text
        Text(
          'Password Strength',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 6),
        // Strength Meter
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Strength Text
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}