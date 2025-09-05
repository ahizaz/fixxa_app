import 'package:flutter/material.dart';

class QuoteSpeak extends StatelessWidget {
  const QuoteSpeak({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Tap',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}