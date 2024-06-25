class Transaction {
  final String docType;
  final String docNo;
  final String transactingParty;
  final DateTime transDate;
  final double checkAmount;
  final String transactionStatus;
  final String remarks;
  final String checkBankDrawee;
  final String checkNumber;
  final String bankName;
  final String dateTrans;

  Transaction({
    required this.docType,
    required this.docNo,
    required this.transactingParty,
    required this.transDate,
    required this.checkAmount,
    required this.transactionStatus,
    required this.remarks,
    required this.checkBankDrawee,
    required this.checkNumber,
    required this.bankName,
    required this.dateTrans
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    // Extracting the nested date string from 'transaction_date'
    String dateString = json['date_trans']; // Adjusted to match PHP output field
    // Parsing the date string into a DateTime object
    DateTime parsedDate = DateTime.parse(dateString);

    return Transaction(
      docType: json['doc_type'].toString(),
      docNo: json['doc_no'].toString(), // Adjusted to match PHP output field
      transactingParty: json['transacting_party'].toString(), // Adjusted to match PHP output field
      transDate: parsedDate, // Assigning the parsed DateTime object
      checkAmount: double.parse(json['check_amount'].toString()), // Adjusted to match PHP output field
      transactionStatus: json['transaction_status'].toString(), // Adjusted to match PHP output field
      remarks: json['remarks'].toString(),
      checkBankDrawee: json['check_drawee_bank'].toString(), // Adjusted to match PHP output field
      checkNumber: json['check_no'].toString(), // Adjusted to match PHP output field
      bankName: json['check_drawee_bank'].toString(), // Adjusted to match PHP output field
      dateTrans: json['check_date_trans'].toString(), //
    );
  }
}