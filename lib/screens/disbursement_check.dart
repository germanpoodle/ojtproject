import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';
import '../widget/card.dart';

String getCurrentDate() {
  DateTime now = DateTime.now();
  String formattedDate =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  return formattedDate;
}

class DisbursementCheque extends StatefulWidget {
  const DisbursementCheque({Key? key}) : super(key: key);

  @override
  _DisbursementChequeState createState() => _DisbursementChequeState();
}

class _DisbursementChequeState extends State<DisbursementCheque> {
  late String _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = getCurrentDate();
  }

  Future<List<Map<String, dynamic>>> _fetchTransactionDetails(
      String dateTrans) async {
    final response = await http.get(Uri.parse(
        'http://192.168.68.121/localconnect/get_transaction.php?date_trans=$dateTrans'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData is List) {
        return List<Map<String, dynamic>>.from(jsonData);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load transaction details');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        _selectedDate =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 9, 41, 145),
        toolbarHeight: 77,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Disbursement',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 233, 227, 227),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(right: screenWidth * 0.02),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications,
                      size: 25,
                      color: Color.fromARGB(255, 233, 227, 227),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(125, 68, 65, 65),
                    padding: EdgeInsets.all(5),
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 25,
                    color: Color.fromARGB(255, 233, 227, 227),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 15, horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transactions as of',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 8, 32, 134),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 28, 29, 27),
                      ),
                      child: Text(
                        'Filter Results',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ],
                ),
              ), 
              Container(
                margin: EdgeInsets.only(left: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _selectedDate,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 8, 32, 134),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchTransactionDetails(_selectedDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child:
                            Text('No transactions found for the given date.'));
                  } else {
                    final List<Map<String, dynamic>> transactions =
                        snapshot.data!;
                    return Column(
                      children: transactions.map((transactionDetails) {
                        final transaction = Transaction(
                          transactingParty:
                              transactionDetails['transacting_party'] ?? '',
                          transDate: transactionDetails['date_trans'] ?? '',
                          checkNo: transactionDetails['check_no'] ?? '',
                          checkBankDrawee:
                              transactionDetails['check_drawee_bank'] ?? '',
                        );
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05, vertical: 10),
                          width: screenWidth * 0.9,
                          height: MediaQuery.of(context).size.height * 0.23,
                          child: CustomCardExample(transaction: transaction),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
