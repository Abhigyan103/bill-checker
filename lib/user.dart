class UserFields {
  static const String billNo = 'Bill No';
  static const String name = 'Name';
  static const String contact = 'Contact';
  static const String year = 'Year';
  static const String department = 'Department';
  static const String amountPaid = 'Amount Paid';
  static const String tshirt = 'T-Shirt';
  static const String tshirtRecieved = 'T-shirt Recieved';
  static const String idRecieved = 'ID Recieved';

  static List<String> getFields() =>
      [billNo, name, contact, year, department, amountPaid, tshirt];
}

class User {
  final int? billNo;
  final String name;
  final String contact;
  final String year;
  final String department;
  final int? amountPaid;
  final String tshirt;
  final bool tshirtRecieved;
  final bool idRecieved;

  User({
    required this.contact,
    required this.billNo,
    required this.name,
    required this.year,
    required this.department,
    required this.amountPaid,
    required this.tshirt,
    required this.tshirtRecieved,
    required this.idRecieved,
  });

  Map<String, dynamic> toJson() => {
        UserFields.billNo: billNo,
        UserFields.name: name,
        UserFields.contact: contact,
        UserFields.year: year,
        UserFields.department: department,
        UserFields.amountPaid: amountPaid,
        UserFields.tshirt: tshirt,
        UserFields.tshirtRecieved: tshirtRecieved,
        UserFields.idRecieved: idRecieved
      };
  static User fromJson(Map<String, String> json) => User(
        contact: json[UserFields.contact] ?? '',
        billNo: int.tryParse(json[UserFields.billNo] ?? '') ?? 0,
        name: json[UserFields.name] ?? '',
        year: json[UserFields.year] ?? '',
        department: json[UserFields.department] ?? '',
        amountPaid: int.tryParse(json[UserFields.amountPaid] ?? '') ?? 0,
        tshirt: json[UserFields.tshirt] ?? '',
        tshirtRecieved: bool.tryParse(
                json[UserFields.tshirtRecieved] ?? 'false',
                caseSensitive: false) ??
            false,
        idRecieved: bool.tryParse(json[UserFields.idRecieved] ?? 'false',
                caseSensitive: false) ??
            false,
      );
}
