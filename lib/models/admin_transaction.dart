class TransactionAdmin {
  final String transactingParty;
  final String transDate;
  final String checkNo;
  final String docType;
  final String docNo;
  final String checkAmount;
  final String checkBankDrawee;
  final String remarks;

  TransactionAdmin({
    required this.transactingParty,
    required this.transDate,
    required this.checkNo,
    required this.docType,
    required this.docNo,
    required this.checkAmount,
    required this.checkBankDrawee,
    required this.remarks,
  });

  factory TransactionAdmin.fromJson(Map<String, dynamic> json) {
    return TransactionAdmin(
      transactingParty: json['transacting_party'] ?? '',
      transDate: json['check_date'] ?? '', 
      checkNo: json['check_no'] ?? '',
      docType: json['doc_type'] ?? '',
      checkAmount: json['check_amount'],
      docNo: json['doc_no'] ?? '',
      checkBankDrawee: json['check_drawee_bank'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }
}
