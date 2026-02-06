class BookingDetails {
  final String patientName;
  final String address;
  final String phone;
  final DateTime bookedOn;
  final DateTime treatmentDate;
  final String treatmentTime;
  final List<SelectedTreatmentDetails> treatments;
  final double totalAmount;
  final double discount;
  final double advance;
  final double balance;

  BookingDetails({
    required this.patientName,
    required this.address,
    required this.phone,
    required this.bookedOn,
    required this.treatmentDate,
    required this.treatmentTime,
    required this.treatments,
    required this.totalAmount,
    required this.discount,
    required this.advance,
    required this.balance,
  });
}

class SelectedTreatmentDetails {
  final String name;
  final double price;
  final int male;
  final int female;
  final double total;

  SelectedTreatmentDetails({
    required this.name,
    required this.price,
    required this.male,
    required this.female,
    required this.total,
  });
}
