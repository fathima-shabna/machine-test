import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/booking_details.dart';

class BookingReceiptScreen extends StatelessWidget {
  final BookingDetails details;
  const BookingReceiptScreen({super.key, required this.details});

  double _s(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;

    double scale = screenWidth / 400;

    return (baseSize * scale).clamp(baseSize * 0.7, baseSize * 1.2);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = (screenWidth * 0.1).clamp(20.0, 50.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: 0.03,
                child: Image.asset(
                  'assets/Layer_1-2.png',
                  width: screenWidth * 0.9,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 15),
                  const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                  const SizedBox(height: 20),
                  _buildPatientDetails(context),
                  const SizedBox(height: 25),
                  const _DashedDivider(),
                  _buildTreatmentTable(context),
                  const _DashedDivider(),
                  const SizedBox(height: 15),
                  _buildSummarySection(context),
                  const SizedBox(height: 40),
                  _buildFooter(context),
                  const SizedBox(height: 50),
                  const _DashedDivider(),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      '"Booking amount is non-refundable, and it\'s important to arrive on the allotted time for your treatment"',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFAAAAAA),
                        fontSize: _s(context, 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/Layer_1-2.png', width: 80, height: 80),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'KUMARAKOM',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: _s(context, 14),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Cheepunkal P.O. Kumarakom, kottayam, Kerala - 686563',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF9E9E9E),
                  fontSize: _s(context, 10),
                ),
              ),
              Text(
                'e-mail: unknown@gmail.com',
                style: TextStyle(
                  color: const Color(0xFF9E9E9E),
                  fontSize: _s(context, 10),
                ),
              ),
              Text(
                'Mob: +91 9876543210 | +91 9786543210',
                style: TextStyle(
                  color: const Color(0xFF9E9E9E),
                  fontSize: _s(context, 10),
                ),
              ),
              Text(
                'GST No: 32AABCU9603R1ZW',
                style: TextStyle(
                  color: const Color(0xFF9E9E9E),
                  fontSize: _s(context, 10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPatientDetails(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isNarrow = constraints.maxWidth < 450;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Details',
              style: TextStyle(
                color: const Color(0xFF27AE60),
                fontWeight: FontWeight.bold,
                fontSize: _s(context, 18),
              ),
            ),
            const SizedBox(height: 15),
            if (isNarrow)
              Column(
                children: [
                  _buildDetailRow(context, 'Name', details.patientName),
                  _buildDetailRow(context, 'Address', details.address),
                  _buildDetailRow(context, 'WhatsApp Number', details.phone),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    context,
                    'Booked On',
                    '${DateFormat('dd/MM/yyyy').format(details.bookedOn)}   |   ${DateFormat('hh:mm a').format(details.bookedOn).toLowerCase()}',
                  ),
                  _buildDetailRow(
                    context,
                    'Treatment Date',
                    DateFormat('dd/MM/yyyy').format(details.treatmentDate),
                  ),
                  _buildDetailRow(
                    context,
                    'Treatment Time',
                    details.treatmentTime,
                  ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        _buildDetailRow(context, 'Name', details.patientName),
                        _buildDetailRow(context, 'Address', details.address),
                        _buildDetailRow(
                          context,
                          'WhatsApp Number',
                          details.phone,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _buildDetailRow(
                          context,
                          'Booked On',
                          '${DateFormat('dd/MM/yyyy').format(details.bookedOn)}   |   ${DateFormat('hh:mm a').format(details.bookedOn).toLowerCase()}',
                        ),
                        _buildDetailRow(
                          context,
                          'Treatment Date',
                          DateFormat(
                            'dd/MM/yyyy',
                          ).format(details.treatmentDate),
                        ),
                        _buildDetailRow(
                          context,
                          'Treatment Time',
                          details.treatmentTime,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    double labelWidth = label == 'WhatsApp Number' ? 120 : 70;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _s(context, labelWidth),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _s(context, 11),
                color: const Color(0xFF333333),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: const Color(0xFF9E9E9E),
                fontSize: _s(context, 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentTable(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: _HeaderCell('Treatment', size: _s(context, 13)),
              ),
              Expanded(
                child: _HeaderCell(
                  'Price',
                  align: TextAlign.center,
                  size: _s(context, 13),
                ),
              ),
              Expanded(
                child: _HeaderCell(
                  'Male',
                  align: TextAlign.center,
                  size: _s(context, 13),
                ),
              ),
              Expanded(
                child: _HeaderCell(
                  'Female',
                  align: TextAlign.center,
                  size: _s(context, 13),
                ),
              ),
              Expanded(
                child: _HeaderCell(
                  'Total',
                  align: TextAlign.right,
                  size: _s(context, 13),
                ),
              ),
            ],
          ),
        ),
        ...details.treatments.map(
          (t) => _buildTreatmentRow(
            context,
            t.name,
            '₹${t.price.toStringAsFixed(0)}',
            t.male.toString(),
            t.female.toString(),
            '₹${t.total.toStringAsFixed(0)}',
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTreatmentRow(
    BuildContext context,
    String name,
    String price,
    String male,
    String female,
    String total,
  ) {
    final style = TextStyle(
      color: const Color(0xFF757575),
      fontSize: _s(context, 12),
      fontWeight: FontWeight.w500,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(name, style: style)),
          Expanded(
            child: Text(price, textAlign: TextAlign.center, style: style),
          ),
          Expanded(
            child: Text(male, textAlign: TextAlign.center, style: style),
          ),
          Expanded(
            child: Text(female, textAlign: TextAlign.center, style: style),
          ),
          Expanded(
            child: Text(total, textAlign: TextAlign.right, style: style),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        child: Column(
          children: [
            _buildSummaryRow(
              context,
              'Total Amount',
              '₹${details.totalAmount.toStringAsFixed(0)}',
            ),
            _buildSummaryRow(
              context,
              'Discount',
              '₹${details.discount.toStringAsFixed(0)}',
            ),
            _buildSummaryRow(
              context,
              'Advance',
              '₹${details.advance.toStringAsFixed(0)}',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: _DashedDivider(),
            ),
            _buildSummaryRow(
              context,
              'Balance',
              '₹${details.balance.toStringAsFixed(0)}',
              isBold: true,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 14,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
              fontSize: _s(context, fontSize),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
              fontSize: _s(context, fontSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Thank you for choosing us',
                style: TextStyle(
                  color: const Color(0xFF27AE60),
                  fontWeight: FontWeight.bold,
                  fontSize: _s(context, 20),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your well-being is our commitment, and we're honored\nyou've entrusted us with your health journey",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFFBDBDBD),
                  fontSize: _s(context, 11),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Image.asset(
                  'assets/Vector 1.png',
                  width: _s(context, 100),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double size;
  const _HeaderCell(
    this.text, {
    this.align = TextAlign.left,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: const Color(0xFF27AE60),
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFD0D0D0)),
              ),
            );
          }),
        );
      },
    );
  }
}
