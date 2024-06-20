import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ojtproject/models/disbursement_data_model.dart';
import 'package:ojtproject/screens/user/user_disbursement.dart';
import 'dart:convert';
import 'package:scrollable_table_view/scrollable_table_view.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const UserHomepage());
}

class UserHomepage extends StatelessWidget {
  const UserHomepage({Key? key}) : super(key: key);

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
  late List<TransactionData> transactions;
  late bool isLoading;
  String selectedColumn = 'docType';
  List<String> docTypes = [];
  int currentPage = 1;
  int rowsPerPage = 20;

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
          'http://127.0.0.1/localconnect/fetch_transaction_data.php'));

      if (response.statusCode == 200) {
        setState(() {
          final List<dynamic> data = json.decode(response.body);
          transactions =
              data.map((json) => TransactionData.fromJson(json)).toList();
          isLoading = false;

          // Extract unique values for docType
          docTypes = transactions.map((e) => e.docType).toSet().toList();
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
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paginatedTransactions = transactions
        .skip((currentPage - 1) * rowsPerPage)
        .take(rowsPerPage)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 41, 145),
        toolbarHeight: 77,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
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
                    icon: const Icon(
                      Icons.notifications,
                      size: 25,
                      color: Color.fromARGB(255, 233, 227, 227),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(125, 68, 65, 65),
                    padding: const EdgeInsets.all(5),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
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
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ClipRRect(
                borderRadius: BorderRadius.zero,
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: ScrollableTableView(
                                  headers: [
                                    'Document Type',
                                    'Document Number',
                                    'Transacting Party',
                                    'Transaction Date',
                                    'Check Amount',
                                    'Remarks',
                                  ].map((columnName) {
                                    return TableViewHeader(
                                      label: columnName,
                                      minWidth: 150,
                                    );
                                  }).toList(),
                                  rows:
                                      paginatedTransactions.map((transaction) {
                                    return TableViewRow(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TransactionDataScreen()));
                                      },
                                      cells: [
                                        TableViewCell(
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: Text(
                                              transaction.docType,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        TableViewCell(
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: Text(
                                              transaction.docNo,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        TableViewCell(
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: Text(
                                              transaction.transactingParty,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        TableViewCell(
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: Text(
                                              formatDate(transaction.dateTrans),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        TableViewCell(
                                          alignment: Alignment.center,
                                          child: Text(
                                            formatAmount(transaction
                                                .checkAmount), // Format the check amount
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        TableViewCell(
                                          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: Text(
                                              transaction.remarks,
                                              softWrap: true,
                                            ),
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
                                '${currentPage} / ${((transactions.length - 1) ~/ rowsPerPage) + 1}'),
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
    );
  }
}
