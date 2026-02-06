import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/booking_details.dart';

class PdfService {
  static Future<void> generateAndPrint(BookingDetails details) async {
    final pdf = pw.Document();

    // Load images
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/Layer_1-2.png')).buffer.asUint8List(),
    );
    final footerVector = pw.MemoryImage(
      (await rootBundle.load('assets/Vector 1.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Image(logoImage, width: 80, height: 80),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'KUMARAKOM',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Cheepunkal P.O. Kumarakom, kottayam,\nKerala - 686563',
                        textAlign: pw.TextAlign.right,
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey,
                        ),
                      ),
                      pw.Text(
                        'e-mail: unknown@gmail.com',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey,
                        ),
                      ),
                      pw.Text(
                        'Mob: +91 9876543210 | +91 9786543210',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey,
                        ),
                      ),
                      pw.Text(
                        'GST No: 32AABCU9603R1ZW',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 20),

              // Patient Details Heading
              pw.Text(
                'Patient Details',
                style: pw.TextStyle(
                  color: PdfColor.fromHex('#27AE60'),
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              pw.SizedBox(height: 15),

              // Patient Details Grid
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        _buildDetailRow('Name', details.patientName),
                        _buildDetailRow('Address', details.address),
                        _buildDetailRow('WhatsApp Number', details.phone),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 40),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        _buildDetailRow(
                          'Booked On',
                          '${DateFormat('dd/MM/yyyy').format(details.bookedOn)}   |   ${DateFormat('hh:mm a').format(details.bookedOn).toLowerCase()}',
                        ),
                        _buildDetailRow(
                          'Treatment Date',
                          DateFormat(
                            'dd/MM/yyyy',
                          ).format(details.treatmentDate),
                        ),
                        _buildDetailRow(
                          'Treatment Time',
                          details.treatmentTime,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 25),
              _buildDashedDivider(),

              // Treatment Table
              pw.SizedBox(height: 12),
              pw.Row(
                children: [
                  pw.Expanded(flex: 4, child: _buildHeaderCell('Treatment')),
                  pw.Expanded(
                    child: _buildHeaderCell(
                      'Price',
                      align: pw.TextAlign.center,
                    ),
                  ),
                  pw.Expanded(
                    child: _buildHeaderCell('Male', align: pw.TextAlign.center),
                  ),
                  pw.Expanded(
                    child: _buildHeaderCell(
                      'Female',
                      align: pw.TextAlign.center,
                    ),
                  ),
                  pw.Expanded(
                    child: _buildHeaderCell('Total', align: pw.TextAlign.right),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              ...details.treatments.map(
                (t) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 4,
                        child: pw.Text(
                          t.name,
                          style: const pw.TextStyle(
                            fontSize: 11,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          'Rs. ${t.price.toStringAsFixed(0)}',
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 11,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          t.male.toString(),
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 11,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          t.female.toString(),
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 11,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          'Rs. ${t.total.toStringAsFixed(0)}',
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(
                            fontSize: 11,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              _buildDashedDivider(),

              // Financial Summary
              pw.SizedBox(height: 15),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  width: 250,
                  child: pw.Column(
                    children: [
                      _buildSummaryRow(
                        'Total Amount',
                        'Rs. ${details.totalAmount.toStringAsFixed(0)}',
                      ),
                      _buildSummaryRow(
                        'Discount',
                        'Rs. ${details.discount.toStringAsFixed(0)}',
                      ),
                      _buildSummaryRow(
                        'Advance',
                        'Rs. ${details.advance.toStringAsFixed(0)}',
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 4),
                        child: _buildDashedDivider(),
                      ),
                      _buildSummaryRow(
                        'Balance',
                        'Rs. ${details.balance.toStringAsFixed(0)}',
                        isBold: true,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ),

              pw.SizedBox(height: 40),

              // Footer Section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Thank you for choosing us',
                        style: pw.TextStyle(
                          color: PdfColor.fromHex('#27AE60'),
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        "Your well-being is our commitment, and we're honored\nyou've entrusted us with your health journey",
                        textAlign: pw.TextAlign.right,
                        style: const pw.TextStyle(
                          color: PdfColors.grey400,
                          fontSize: 10,
                        ),
                      ),
                      pw.SizedBox(height: 15),
                      pw.Image(footerVector, width: 100),
                    ],
                  ),
                ],
              ),

              pw.Spacer(),

              // Warning Footer
              _buildDashedDivider(),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  '"Booking amount is non-refundable, and it\'s important to arrive on the allotted time for your treatment"',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(
                    color: PdfColors.grey400,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save or Print
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Receipt_${details.patientName}.pdf',
    );
  }

  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
                color: PdfColors.black,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildHeaderCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Text(
      text,
      textAlign: align,
      style: pw.TextStyle(
        color: PdfColor.fromHex('#27AE60'),
        fontWeight: pw.FontWeight.bold,
        fontSize: 12,
      ),
    );
  }

  static pw.Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 12,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildDashedDivider() {
    return pw.Container(
      height: 1,
      child: pw.LayoutBuilder(
        builder: (context, constraints) {
          final dashWidth = 2.0;
          final dashCount = (constraints!.maxWidth / (2 * dashWidth)).floor();
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return pw.SizedBox(
                width: dashWidth,
                height: 1,
                child: pw.DecoratedBox(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
