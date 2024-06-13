class UserData {
  final String transactingParty;
  final String transDate;
  final String checkNo;
  final String checkBankDrawee;

  UserData({
    required this.transactingParty,
    required this.transDate,
    required this.checkNo,
    required this.checkBankDrawee,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      transactingParty: json['transacting_party'],
      transDate: json['date_trans'],
      checkNo: json['check_no'],
      checkBankDrawee: json['check_drawee_bank'],
    );
  }
}
