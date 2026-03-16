import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';

class QuoteExportController {
  // Export the widget wrapped by `key` into a single-page PDF file.
  Future<File?> exportWidgetToPdf(
    GlobalKey key,
    String filename, {
    double pixelRatio = 3.0,
    String? acceptLink,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));

      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      final pngBytes = byteData.buffer.asUint8List();

      final pdf = pw.Document();
      final pwImage = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context ctx) {
            return pw.Stack(
              children: [
                // Full-page image centered
                pw.Positioned.fill(
                  child: pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Image(pwImage, fit: pw.BoxFit.contain),
                  ),
                ),

                // Invisible clickable overlay that maps to the visual button in the PNG
                if (acceptLink != null && acceptLink.isNotEmpty)
                  pw.Positioned(
                    left: 60,
                    right: 60,
                    bottom: 60,
                    child: pw.SizedBox(
                      height: 40,
                      child: pw.UrlLink(
                        destination: acceptLink,
                        child: pw.Container(
                          decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(20),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              '',
                              style: pw.TextStyle(fontSize: 0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      );

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$filename.pdf');
      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      debugPrint('Export error: $e');
      return null;
    }
  }

  // Upload PDF to server and optionally request server to send email.
  // Expects backend `pdf_file` field (file) and `send_email` field (text 'True'/'true').
  Future<bool> uploadPdfAndSendEmail(
    int quoteId,
    File pdfFile, {
    bool sendEmail = true,
    String? acceptLink,
  }) async {
    final token = await LoginController.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('No access token available');
      EasyLoading.showError('Not authenticated');
      return false;
    }

    final uri = Uri.parse(Urls.sendpdfemail(quoteId));
    debugPrint('Preparing upload to: $uri');
    debugPrint('PDF file path: ${pdfFile.path}');
    try {
      final fileLength = await pdfFile.length();
      debugPrint('PDF size (bytes): $fileLength');

      EasyLoading.show(status: 'Uploading PDF...');

      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['send_email'] = sendEmail ? 'True' : 'False';
      // Include accept link so backend can add it to email body if desired
      if (acceptLink != null && acceptLink.isNotEmpty) {
        request.fields['accept_link'] = acceptLink;
      }

      final multipartFile = await http.MultipartFile.fromPath(
        'pdf_file',
        pdfFile.path,
        contentType: MediaType('application', 'pdf'),
      );
      request.files.add(multipartFile);

      debugPrint('Request fields: ${request.fields}');
      debugPrint(
        'Request files: ${request.files.map((f) => f.filename).toList()}',
      );

      final streamedResponse = await request.send();
      final respStr = await streamedResponse.stream.bytesToString();

      debugPrint('Upload response status: ${streamedResponse.statusCode}');
      debugPrint('Upload response body: $respStr');

      EasyLoading.dismiss();

      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        EasyLoading.showSuccess('PDF sent successfully');
        return true;
      } else {
        EasyLoading.showError('Failed to send PDF');
        return false;
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred');
      return false;
    }
  }

  // Convenience helper: export the widget at [key] to PDF then upload and request email.
  // Returns true when upload+email request was successful.
  Future<bool> exportAndSend(
    int quoteId,
    GlobalKey key, {
    String filename = '',
    String? acceptLink,
  }) async {
    try {
      final name = filename.isNotEmpty ? filename : 'quote_$quoteId';
      EasyLoading.show(status: 'Generating PDF...');
      final pdfFile = await exportWidgetToPdf(
        key,
        name,
        acceptLink: acceptLink,
      );
      EasyLoading.dismiss();

      if (pdfFile == null) {
        debugPrint('PDF export returned null');
        EasyLoading.showError('Could not create PDF');
        return false;
      }

      debugPrint('Exported PDF path: ${pdfFile.path}');
      // Upload and request server to send email (send_email = True)
      return await uploadPdfAndSendEmail(
        quoteId,
        pdfFile,
        sendEmail: true,
        acceptLink: acceptLink,
      );
    } catch (e) {
      debugPrint('exportAndSend error: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred');
      return false;
    }
  }

  // Invoice-specific helpers: export the preview widget then upload to invoice upload endpoint
  Future<bool> uploadPdfAndSendEmailInvoice(
    int invoiceId,
    File pdfFile, {
    bool sendEmail = true,
    String? acceptLink,
  }) async {
    final token = await LoginController.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('No access token available');
      EasyLoading.showError('Not authenticated');
      return false;
    }

    final uri = Uri.parse(Urls.sendpdfInvoicessemail(invoiceId));
    debugPrint('Preparing invoice upload to: $uri');
    debugPrint('PDF file path: ${pdfFile.path}');
    try {
      final fileLength = await pdfFile.length();
      debugPrint('PDF size (bytes): $fileLength');

      EasyLoading.show(status: 'Uploading PDF...');

      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['send_email'] = sendEmail ? 'True' : 'False';
      if (acceptLink != null && acceptLink.isNotEmpty) {
        request.fields['accept_link'] = acceptLink;
      }

      final multipartFile = await http.MultipartFile.fromPath(
        'pdf_file',
        pdfFile.path,
        contentType: MediaType('application', 'pdf'),
      );
      request.files.add(multipartFile);

      debugPrint('Request fields: ${request.fields}');
      debugPrint('Request files: ${request.files.map((f) => f.filename).toList()}');

      final streamedResponse = await request.send();
      final respStr = await streamedResponse.stream.bytesToString();

      debugPrint('Upload response status: ${streamedResponse.statusCode}');
      debugPrint('Upload response body: $respStr');

      EasyLoading.dismiss();

      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        EasyLoading.showSuccess('PDF sent successfully');
        return true;
      } else {
        EasyLoading.showError('Failed to send PDF');
        return false;
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred');
      return false;
    }
  }

  Future<bool> exportAndSendInvoice(
    int invoiceId,
    GlobalKey key, {
    String filename = '',
    String? acceptLink,
  }) async {
    try {
      final name = filename.isNotEmpty ? filename : 'invoice_$invoiceId';
      EasyLoading.show(status: 'Generating PDF...');
      final pdfFile = await exportWidgetToPdf(
        key,
        name,
        acceptLink: acceptLink,
      );
      EasyLoading.dismiss();

      if (pdfFile == null) {
        debugPrint('PDF export returned null');
        EasyLoading.showError('Could not create PDF');
        return false;
      }

      debugPrint('Exported PDF path: ${pdfFile.path}');
      // Upload to invoice upload endpoint
      return await uploadPdfAndSendEmailInvoice(
        invoiceId,
        pdfFile,
        sendEmail: true,
        acceptLink: acceptLink,
      );
    } catch (e) {
      debugPrint('exportAndSendInvoice error: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred');
      return false;
    }
  }
}
