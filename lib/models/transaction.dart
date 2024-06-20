class Transaction {
  final String transactingParty;
  final DateTime transDate;
  final String checkNo;
  final String docType;
  final String docNo;
  final String checkAmount;
  final String checkBankDrawee;
  final String remarks;

  Transaction({
    required this.transactingParty,
    required this.transDate,
    required this.checkNo,
    required this.docType,
    required this.docNo,
    required this.checkAmount,
    required this.checkBankDrawee,
    required this.remarks,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactingParty: json['transacting_party'] ?? '',
      transDate: DateTime.parse(json['transDate'] ?? ''),
      checkNo: json['check_no'] ?? '',
      docType: json['doc_type'] ?? '',
      checkAmount: json['check_amount'],
      docNo: json['doc_no'] ?? '',
      checkBankDrawee: json['check_drawee_bank'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transacting_party': transactingParty,
      'transDate': transDate.toIso8601String(),
      'check_no': checkNo,
      'doc_type': docType,
      'doc_no': docNo,
      'check_amount': checkAmount,
      'check_drawee_bank': checkBankDrawee,
      'remarks': remarks,
    };
  }
}