import 'dart:io';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

class EReceiptPage extends StatelessWidget {
  final String name;
  final String email;
  final String course;
  final String category;
  final String transactionId;
  final double price;
  final DateTime date;
  final String barcodeNumber1;
  final String barcodeNumber2;

  const EReceiptPage({
    super.key,
    required this.name,
    required this.email,
    required this.course,
    required this.category,
    required this.transactionId,
    required this.price,
    required this.date,
    required this.barcodeNumber1,
    required this.barcodeNumber2,
  });

  // Format date nicely
  String formatDate(DateTime dt) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }

  Future<pw.Document> _buildPDF() async {
    final pdf = pw.Document();

    // Load logo safely
    final logoBytes = await rootBundle.load('assets/logo.png');
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) => pw.Stack(
          children: [
            // Watermark
            pw.Positioned.fill(
              child: pw.Opacity(
                opacity: 0.08,
                child: pw.Center(
                  child: pw.Text(
                    'Eduera',
                    style: pw.TextStyle(
                      fontSize: 100,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey300,
                    ),
                  ),
                ),
              ),
            ),
            // Receipt content
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.blueGrey, width: 2),
                borderRadius: pw.BorderRadius.circular(12),
              ),
              padding: const pw.EdgeInsets.all(24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(child: pw.Image(logo, height: 60)),
                  pw.SizedBox(height: 16),
                  pw.Center(
                    child: pw.Text(
                      'E-Receipt',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 24),
                  _pdfRow('Name', name),
                  _pdfRow('Email ID', email),
                  _pdfRow('Course', course),
                  _pdfRow('Category', category),
                  _pdfRow('Transaction ID', transactionId),
                  _pdfRow('Price', '₹${price.toStringAsFixed(2)}'),
                  _pdfRow('Date', formatDate(date)),
                  _pdfRow('Status', 'Paid'),
                  pw.SizedBox(height: 24),
                  pw.Center(
                    child: pw.BarcodeWidget(
                      barcode: pw.Barcode.code128(),
                      data: '$barcodeNumber1$barcodeNumber2',
                      width: 200,
                      height: 80,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Center(
                    child: pw.Text(
                      '$barcodeNumber1  $barcodeNumber2',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return pdf;
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Text(
            '$label: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  Future<void> _downloadPDF(BuildContext context) async {
    final pdf = await _buildPDF();
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  Future<void> _sharePDF(BuildContext context) async {
    final pdf = await _buildPDF();
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'e_receipt_$transactionId.pdf',
    );
  }

  Future<void> _savePDFLocally(BuildContext context) async {
    try {
      final pdf = await _buildPDF();
      final bytes = await pdf.save();

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/e_receipt_$transactionId.pdf');
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Saved to ${file.path}')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving file: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Receipt'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'download') {
                _downloadPDF(context);
              } else if (value == 'save') {
                _savePDFLocally(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'download', child: Text('Download PDF')),
              PopupMenuItem(value: 'save', child: Text('Save to Device')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Image.asset('assets/logo.png', height: 60),
                const SizedBox(height: 16),
                const Text(
                  'E-Receipt',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _buildRow('Name', name),
                _buildRow('Email ID', email),
                _buildRow('Course', course),
                _buildRow('Category', category),
                _buildRow('Transaction ID', transactionId),
                _buildRow('Price', '₹${price.toStringAsFixed(2)}'),
                _buildRow('Date', formatDate(date)),
                _buildRow('Status', 'Paid'),
                const SizedBox(height: 24),
                BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: '$barcodeNumber1$barcodeNumber2',
                  width: 200,
                  height: 80,
                  drawText: false,
                ),
                const SizedBox(height: 8),
                Text(
                  '$barcodeNumber1  $barcodeNumber2',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => _sharePDF(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () => _downloadPDF(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () => _savePDFLocally(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
