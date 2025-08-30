import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

class PdfViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PdfViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generated PDF"),
      ),
      body: SfPdfViewer.file(
        File(pdfPath),
      ),
    );
  }
}