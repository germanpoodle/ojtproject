import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/admin_transaction.dart';
import '../models/user_transaction.dart';
import '../widgets/card.dart';
import 'filter_pop_up.dart';
import 'notifications.dart';
import 'admin_homepage.dart'; 
import 'admin_menu_window.dart'; 

class DisbursementCheque extends StatefulWidget {
  const DisbursementCheque({Key? key}) : super(key: key);

  @override
  _DisbursementChequeState createState() => _DisbursementChequeState();
}

class _DisbursementChequeState extends State<DisbursementCheque> {
  late String _selectedDate;
  List<Transaction> transactions = [];
  int _selectedIndex = 1; 

  @override
  void initState() {
    super.initState();
    _selectedDate = getCurrentDate();
    _fetchTransactionDetails();
  }

  String getCurrentDate() {
    final DateTime now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  Future<List<Transaction>> _fetchTransactionDetails() async {
    try {
      var url = Uri.parse(
          'http://192.168.68.123/localconnect/get_transaction.php?date_trans=$_selectedDate');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          List<Transaction> fetchedTransactions = jsonData
              .map((transaction) => Transaction.fromJson(transaction))
              .toList();
          return fetchedTransactions;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load transaction details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch transaction details: $e');
    }
  }

  Future<void> _showFilterDialog() async {
    final Map<String, dynamic>? filterData = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => FilterDialog(),
    );

    if (filterData != null) {
      setState(() {
        _selectedDate = filterData['date'];
      });
      await _fetchTransactionDetails();
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; 

    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DisbursementCheque()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminMenuWindow()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 9, 41, 145),
        toolbarHeight: 77,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Disbursement',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 233, 227, 227),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: screenWidth * 0.02),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotificationScreen()),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications,
                      size: 16,
                      color: Color.fromARGB(255, 233, 227, 227),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person,
                    size: 16,
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
                    const Text(
                      'Transactions as of',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 8, 32, 134),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _showFilterDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 28, 29, 27),
                      ),
                      child: const Text(
                        'Filter Results',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: screenWidth < 600 ? 25 : 65),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _selectedDate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 8, 32, 134),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              FutureBuilder<List<Transaction>>(
                future: _fetchTransactionDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      'No transactions found as of today.',
                      style: TextStyle(fontSize: 12),
                    ));
                  } else {
                    final List<Transaction> transactions = snapshot.data!;
                    return Column(
                      children: transactions.map((transaction) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06, vertical: 9),
                          width: screenWidth * 0.9,
                          height: MediaQuery.of(context).size.height * 0.1579,
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Disbursement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_sharp),
            label: 'Menu',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
