import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';

import '../models/user_transaction.dart'; // Import your Transaction model
import 'disbursement_details.dart'; // Import the DisbursementDetailsScreen

// void main() {
//   runApp(const UserUpload());
// }

class UserUpload extends StatelessWidget {
  const UserUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Transaction> transactions;
  late bool isLoading;
  String selectedColumn = 'docRef';
  List<String> headers = ['Doc Ref', 'Payor', 'Amount'];
  bool isAscending = true;
  int currentPage = 1;
  int rowsPerPage = 20;
  int _selectedIndex = 0; // Add this line to manage the active tab state

  @override
  void initState() {
    super.initState();
    isLoading = true;
    transactions = [];
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.68.114/localconnect/fetch_transaction_data.php'));

      if (response.statusCode == 200) {
        setState(() {
          final List<dynamic> data = json.decode(response.body);
          transactions =
              data.map((json) => Transaction.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to connect to server.');
    }
  }

  void previousPage() {
    setState(() {
      if (currentPage > 1) currentPage--;
    });
  }

  void nextPage() {
    setState(() {
      if ((currentPage + 1) * rowsPerPage <= transactions.length) currentPage++;
    });
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MM/dd/yy');
    return formatter.format(date);
  }

  String formatAmount(double amount) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'en_PH', // Filipino locale
      symbol: '₱', // Currency symbol for Philippine Peso
      decimalDigits: 2, // Number of decimal places
    );
    return currencyFormat.format(amount);
  }

  String createDocRef(String docType, String docNo, DateTime transDate) {
    final String formattedDate = formatDate(transDate);
    return 'Ref: $docType#$docNo; $formattedDate';
  }

  void sortTransactions(String columnName) {
    setState(() {
      if (selectedColumn == columnName) {
        isAscending = !isAscending;
      } else {
        selectedColumn = columnName;
        isAscending = true;
      }

      switch (columnName) {
        case 'Doc Ref':
          transactions.sort((a, b) {
            final String docRefA =
                createDocRef(a.docType, a.docNo, a.transDate);
            final String docRefB =
                createDocRef(b.docType, b.docNo, b.transDate);
            return isAscending
                ? docRefA.compareTo(docRefB)
                : docRefB.compareTo(docRefA);
          });
          break;
        case 'Payor':
          transactions.sort((a, b) => isAscending
              ? a.transactingParty.compareTo(b.transactingParty)
              : b.transactingParty.compareTo(a.transactingParty));
          break;
        case 'Amount':
          transactions.sort((a, b) => isAscending
              ? a.checkAmount.compareTo(b.checkAmount)
              : b.checkAmount.compareTo(a.checkAmount));
          break;
      }
    });
  }

  void navigateToDetails(Transaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisbursementDetailsScreen(
          transaction: transaction,
          selectedDetails: [], // Adjust based on your requirements
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation to different screens based on the tapped item
    switch (index) {
      case 0:
        // Navigate to "For Upload" screen
        break;
      case 1:
        // Navigate to "No Support" screen
        break;
      case 2:
        // Navigate to "Menu" screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    final paginatedTransactions = transactions
        .skip((currentPage - 1) * rowsPerPage)
        .take(rowsPerPage)
        .toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 79, 128, 189),
        toolbarHeight: 77,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'logo.png',
                  width: 60,
                  height: 55,
                ),
                const SizedBox(width: 8),
                const Text(
                  'For Uploading',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 233, 227, 227),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(right: screenSize.width * 0.02),
                  child: IconButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => NotificationScreen()),
                      // );
                    },
                    icon: const Icon(
                      Icons.notifications,
                      size: 24, // Adjust size as needed
                      color: Color.fromARGB(255, 233, 227, 227),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person,
                    size: 24, // Adjust size as needed
                    color: Color.fromARGB(255, 233, 227, 227),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                          color: Color.fromARGB(255, 79, 128, 189),
                          strokeAlign: BorderSide.strokeAlignOutside,
                          width: 2.0),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: ScrollableTableView(
                                  headers: headers.map((columnName) {
                                    return TableViewHeader(
                                      labelFontSize: 12,
                                      label: columnName,
                                      padding: const EdgeInsets.all(8),
                                      minWidth: 150,
                                      alignment: columnName == 'Amount'
                                          ? Alignment.centerRight
                                          : Alignment.center,
                                    );
                                  }).toList(),
                                  rows:
                                      paginatedTransactions.map((transaction) {
                                    return TableViewRow(
                                      height: 55,
                                      onTap: () {
                                        navigateToDetails(transaction);
                                      },
                                      cells: [
                                        TableViewCell(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            createDocRef(
                                                transaction.docType,
                                                transaction.docNo,
                                                transaction.transDate),
                                            softWrap: true,
                                          ),
                                        ),
                                        TableViewCell(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            transaction.transactingParty,
                                            softWrap: true,
                                          ),
                                        ),
                                        TableViewCell(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            formatAmount(
                                                transaction.checkAmount),
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: previousPage,
                            ),
                            Text(
                                '$currentPage / ${((transactions.length - 1) / rowsPerPage).ceil()}'),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: nextPage,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 79, 128, 189),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file_outlined),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'No Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_sharp),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
