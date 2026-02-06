import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'controllers/booking_controller.dart';
import 'booking_receipt_screen.dart';
import 'models/booking_details.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final BookingController _bookingController = Get.put(BookingController());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _executiveController = TextEditingController();
  final TextEditingController _discountController = TextEditingController(
    text: '0',
  );
  final TextEditingController _advanceController = TextEditingController(
    text: '0',
  );
  final TextEditingController _balanceController = TextEditingController(
    text: '0',
  );
  final TextEditingController _totalController = TextEditingController(
    text: '0',
  );
  final TextEditingController _dateController = TextEditingController();

  String? _paymentOption = 'Cash';
  int _maleCount = 0;
  int _femaleCount = 0;
  int? _selectedBranchId;
  int? _selectedTreatmentId;
  DateTime? _selectedDate;
  String _selectedHour = '01';
  String _selectedMinute = '00';

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _selectedDate = DateTime.now();
    _discountController.addListener(_updateCalculatedValues);
    _advanceController.addListener(_updateCalculatedValues);
  }

  @override
  void dispose() {
    _discountController.removeListener(_updateCalculatedValues);
    _advanceController.removeListener(_updateCalculatedValues);
    super.dispose();
  }

  void _showAddTreatmentDialog(BuildContext context) {
    _maleCount = 0;
    _femaleCount = 0;
    _selectedTreatmentId = null;

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
                        Obx(
                          () => _buildDialogDropdown(
                            'Choose preferred treatment',
                            _bookingController.treatments,
                            _selectedTreatmentId,
                            (val) => setDialogState(
                              () => _selectedTreatmentId = val,
                            ),
                          ),
                        ),
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
                          onPressed: () {
                            if (_selectedTreatmentId != null) {
                              _bookingController.selectedTreatments.add(
                                _selectedTreatmentId!,
                              );
                              _bookingController.maleTreatments.add(_maleCount);
                              _bookingController.femaleTreatments.add(
                                _femaleCount,
                              );
                              _updateCalculatedValues();
                              Navigator.pop(context);
                            } else {
                              Get.snackbar(
                                'Error',
                                'Please select a treatment',
                              );
                            }
                          },
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

  Widget _buildDialogDropdown(
    String hint,
    List<dynamic> items,
    int? value,
    Function(int?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x66000000)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
          ),
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF006837)),
          items: items.map((item) {
            return DropdownMenuItem<int>(
              value: item.id,
              child: Text(item.name, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
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
                    _buildTextField('Enter your full name', _nameController),
                    _buildLabel('Executive'),
                    _buildTextField(
                      'Enter executive name',
                      _executiveController,
                    ),
                    _buildLabel('Whatsapp Number'),
                    _buildTextField(
                      'Enter your Whatsapp number',
                      _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    _buildLabel('Address'),
                    _buildTextField(
                      'Enter your full address',
                      _addressController,
                    ),
                    _buildLabel('Branch'),
                    Obx(
                      () => _buildDropdown(
                        'Select the branch',
                        _bookingController.branches,
                        _selectedBranchId,
                        (val) => setState(() => _selectedBranchId = val),
                      ),
                    ),
                    _buildLabel('Treatments'),
                    Obx(
                      () => Column(
                        children: List.generate(
                          _bookingController.selectedTreatments.length,
                          (index) {
                            final tId =
                                _bookingController.selectedTreatments[index];
                            final treatment = _bookingController.treatments
                                .firstWhere((t) => t.id == tId);
                            return _buildAddedTreatmentCard(
                              index + 1,
                              treatment.name,
                              _bookingController.maleTreatments[index],
                              _bookingController.femaleTreatments[index],
                              () {
                                _bookingController.selectedTreatments.removeAt(
                                  index,
                                );
                                _bookingController.maleTreatments.removeAt(
                                  index,
                                );
                                _bookingController.femaleTreatments.removeAt(
                                  index,
                                );
                                _updateCalculatedValues();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildAddTreatmentButton(),
                    _buildLabel('Total Amount'),
                    _buildTextField('', _totalController, readOnly: true),
                    _buildLabel('Discount Amount'),
                    _buildTextField('', _discountController),
                    _buildLabel('Payment Option'),
                    _buildPaymentOptions(),
                    _buildLabel('Advance Amount'),
                    _buildTextField('', _advanceController),
                    _buildLabel('Balance Amount'),
                    _buildTextField('', _balanceController, readOnly: true),
                    _buildLabel('Treatment Date'),
                    _buildDatePickerField(),
                    _buildLabel('Treatment Time'),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimeDropdown(
                            'Hour',
                            List.generate(
                              24,
                              (i) => (i + 1).toString().padLeft(2, '0'),
                            ),
                            _selectedHour,
                            (v) => setState(() => _selectedHour = v!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTimeDropdown(
                            'Minutes',
                            List.generate(
                              60,
                              (i) => i.toString().padLeft(2, '0'),
                            ),
                            _selectedMinute,
                            (v) => setState(() => _selectedMinute = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _bookingController.isLoading.value ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006837),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _bookingController.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Save',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }

  void _updateCalculatedValues() {
    double total = 0;
    for (int i = 0; i < _bookingController.selectedTreatments.length; i++) {
      final tId = _bookingController.selectedTreatments[i];
      final treatment = _bookingController.treatments.firstWhere(
        (t) => t.id == tId,
      );
      final price = double.tryParse(treatment.price) ?? 0.0;
      final patientCount =
          _bookingController.maleTreatments[i] +
          _bookingController.femaleTreatments[i];
      total += price * patientCount;
    }
    _totalController.text = total.toStringAsFixed(0);

    double discount = double.tryParse(_discountController.text) ?? 0.0;
    double advance = double.tryParse(_advanceController.text) ?? 0.0;
    double balance = total - discount - advance;
    _balanceController.text = balance.toStringAsFixed(0);
  }

  void _handleSave() async {
    if (_nameController.text.isEmpty ||
        _selectedBranchId == null ||
        _bookingController.selectedTreatments.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all required fields and add at least one treatment',
      );
      return;
    }

    final success = await _bookingController.registerPatient(
      name: _nameController.text,
      executive: _executiveController.text,
      payment: _paymentOption ?? 'Cash',
      phone: _phoneController.text,
      address: _addressController.text,
      total: double.tryParse(_totalController.text) ?? 0.0,
      discount: double.tryParse(_discountController.text) ?? 0.0,
      advance: double.tryParse(_advanceController.text) ?? 0.0,
      balance: double.tryParse(_balanceController.text) ?? 0.0,
      dateTime: DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        int.parse(_selectedHour),
        int.parse(_selectedMinute),
      ),
      branchId: _selectedBranchId!,
    );

    final details = BookingDetails(
      patientName: _nameController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      bookedOn: DateTime.now(),
      treatmentDate: _selectedDate!,
      treatmentTime:
          '$_selectedHour:$_selectedMinute ${_selectedHour.compareTo('12') >= 0 ? 'pm' : 'am'}',
      treatments: List.generate(_bookingController.selectedTreatments.length, (
        i,
      ) {
        final tId = _bookingController.selectedTreatments[i];
        final treatment = _bookingController.treatments.firstWhere(
          (t) => t.id == tId,
        );
        final price = double.tryParse(treatment.price) ?? 0.0;
        final male = _bookingController.maleTreatments[i];
        final female = _bookingController.femaleTreatments[i];
        return SelectedTreatmentDetails(
          name: treatment.name,
          price: price,
          male: male,
          female: female,
          total: price * (male + female),
        );
      }),
      totalAmount: double.tryParse(_totalController.text) ?? 0.0,
      discount: double.tryParse(_discountController.text) ?? 0.0,
      advance: double.tryParse(_advanceController.text) ?? 0.0,
      balance: double.tryParse(_balanceController.text) ?? 0.0,
    );

    Get.to(() => BookingReceiptScreen(details: details));
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

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
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

  Widget _buildDropdown(
    String hint,
    List<dynamic> items,
    int? value,
    Function(int?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x66000000)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
          ),
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF006837)),
          items: items.map((item) {
            return DropdownMenuItem<int>(
              value: item.id,
              child: Text(item.name, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildAddedTreatmentCard(
    int index,
    String name,
    int male,
    int female,
    VoidCallback onDelete,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '$index. ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: onDelete,
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
              _buildCountBox(male.toString()),
              const SizedBox(width: 16),
              const Text('Female', style: TextStyle(color: Color(0xFF006837))),
              const SizedBox(width: 8),
              _buildCountBox(female.toString()),
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
        backgroundColor: const Color(0xFFE8F5E9),
        foregroundColor: const Color(0xFF006837),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, size: 20),
          SizedBox(width: 8),
          Text('Add Treatments', style: TextStyle(fontWeight: FontWeight.w600)),
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
      controller: _dateController,
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          setState(() {
            _selectedDate = date;
            _dateController.text = DateFormat('dd/MM/yyyy').format(date);
          });
        }
      },
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

  Widget _buildTimeDropdown(
    String label,
    List<String> items,
    String value,
    Function(String?) onChanged,
  ) {
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
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF006837)),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
