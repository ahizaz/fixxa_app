import 'package:flutter/material.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';

class ExportPreviewPage extends StatelessWidget {
  final Map<String, dynamic>? data;
  final String source;

  const ExportPreviewPage({
    Key? key,
    this.data,
    required this.source,
  }) : super(key: key);

  String _title() {
    if (source.isEmpty) return 'Export Preview';
    return '${source[0].toUpperCase()}${source.substring(1)} Export Preview';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              ImagePath.backgroud,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                  
             
                  ],
                ),
                const SizedBox(height: 16),
              
              
              ],
            ),
          ),
        ],
      ),
    );
  }
}
