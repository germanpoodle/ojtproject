class Transaction {
  final String transactingParty;
  final String transDate;
  final String checkNo;
  final String checkBankDrawee;

  Transaction({
    required this.transactingParty,
    required this.transDate,
    required this.checkNo,
    required this.checkBankDrawee,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactingParty: json['transacting_party'] ?? '',
      transDate: json['date_trans'] ?? '',
      checkNo: json['check_no'] ?? '',
      checkBankDrawee: json['check_drawee_bank'] ?? '',
    );
  }
}
