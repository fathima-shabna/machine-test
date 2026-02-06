import 'package:flutter/material.dart';
import 'booking_receipt_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _paymentOption = 'Cash';
  int _maleCount = 0;
  int _femaleCount = 0;

  void _showAddTreatmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Choose Treatment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF424242),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDropdown('Choose preferred treatment'),
                        const SizedBox(height: 24),
                        const Text(
                          'Add Patients',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF424242),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCounterRow('Male', _maleCount, (val) {
                          setDialogState(() => _maleCount = val);
                        }),
                        const SizedBox(height: 16),
                        _buildCounterRow('Female', _femaleCount, (val) {
                          setDialogState(() => _femaleCount = val);
                        }),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006837),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCounterRow(String label, int count, Function(int) onChanged) {
    return Row(
      children: [
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0x66000000)),
          ),
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            if (count > 0) onChanged(count - 1);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF006837),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.remove, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 50,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0x66000000)),
          ),
          child: Text('$count', style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => onChanged(count + 1),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF006837),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            const Divider(thickness: 1, height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF424242),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Name'),
                    _buildTextField('Enter your full name'),
                    _buildLabel('Whatsapp Number'),
                    _buildTextField('Enter your Whatsapp number'),
                    _buildLabel('Address'),
                    _buildTextField('Enter your full address'),
                    _buildLabel('Location'),
                    _buildDropdown('Choose your location'),
                    _buildLabel('Branch'),
                    _buildDropdown('Select the branch'),
                    _buildLabel('Treatments'),
                    _buildTreatmentCard(),
                    const SizedBox(height: 12),
                    _buildAddTreatmentButton(),
                    _buildLabel('Total Amount'),
                    _buildTextField(''),
                    _buildLabel('Discount Amount'),
                    _buildTextField(''),
                    _buildLabel('Payment Option'),
                    _buildPaymentOptions(),
                    _buildLabel('Advance Amount'),
                    _buildTextField(''),
                    _buildLabel('Balance Amount'),
                    _buildTextField(''),
                    _buildLabel('Treatment Date'),
                    _buildDatePickerField(),
                    _buildLabel('Treatment Time'),
                    Row(
                      children: [
                        Expanded(child: _buildTimeDropdown('Hour')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTimeDropdown('Minutes')),
                      ],
                    ),
                    const SizedBox(height: 100), // Space for save button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BookingReceiptScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006837),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Save',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          Stack(
            children: [
              Image.asset(
                'assets/clarity_bell-line.png',
                width: 28,
                height: 28,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF424242),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF006837)),
          items: [],
          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget _buildTreatmentCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '1. ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Expanded(
                child: Text(
                  'Couple Combo package i..',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.cancel, color: Color(0xFFEF9A9A)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Male', style: TextStyle(color: Color(0xFF006837))),
              const SizedBox(width: 8),
              _buildCountBox('2'),
              const SizedBox(width: 16),
              const Text('Female', style: TextStyle(color: Color(0xFF006837))),
              const SizedBox(width: 8),
              _buildCountBox('2'),
              const Spacer(),
              const Icon(Icons.edit, color: Color(0xFF006837), size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountBox(String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x66000000)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(count, style: const TextStyle(color: Color(0xFF006837))),
    );
  }

  Widget _buildAddTreatmentButton() {
    return ElevatedButton(
      onPressed: () => _showAddTreatmentDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF006837), // Primary Green
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, size: 20),
          SizedBox(width: 8),
          Text('Add Treatments', style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Row(
      children: [
        Expanded(child: _buildRadioButton('Cash')),
        Expanded(child: _buildRadioButton('Card')),
        Expanded(child: _buildRadioButton('UPI')),
      ],
    );
  }

  Widget _buildRadioButton(String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: _paymentOption,
          onChanged: (String? val) {
            setState(() {
              _paymentOption = val;
            });
          },
          activeColor: const Color(0xFF006837),
        ),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildDatePickerField() {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        suffixIcon: const Icon(
          Icons.calendar_today_outlined,
          color: Color(0xFF006837),
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x66000000)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0x66000000)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildTimeDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x66000000)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            label,
            style: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF006837)),
          items: [],
          onChanged: (value) {},
        ),
      ),
    );
  }
}
