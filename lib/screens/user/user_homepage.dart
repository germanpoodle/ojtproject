import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ojtproject/screens/user/user_disbursement.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ojtproject/models/disbursement_data_model.dart';

void main() {
  runApp(const UserHomepage());
}

class UserHomepage extends StatelessWidget {
  const UserHomepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),

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
  late List<TransactionData> filteredTransactions;
  late bool isLoading;
  String selectedColumn = 'docType';
  List<String> docTypes = [];
  List<String> transactionStatuses = [];

  @override
  void initState() {
    super.initState();
    isLoading = true;
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/localconnect/fetch_transaction_data.php'));

      if (response.statusCode == 200) {
        setState(() {
          final List<dynamic> data = json.decode(response.body);
          transactions =
              data.map((json) => TransactionData.fromJson(json)).toList();
          filteredTransactions = transactions;
          isLoading = false;

          // Extract unique values for docType and transactionStatus
          docTypes = transactions.map((e) => e.docType).toSet().toList();
          transactionStatuses =
              transactions.map((e) => e.transactionStatus).toSet().toList();
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

  void showFilterDialog() {
    List<String> selectedDocTypes = [];
    List<String> selectedTransactionStatuses = [];
    String? docNoSearch;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Criteria'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Filter by Doc Type'),
                    Wrap(
                      spacing: 8.0,
                      children: docTypes.map((String value) {
                        return ChoiceChip(
                          label: Text(value),
                          selected: selectedDocTypes.contains(value),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedDocTypes.add(value);
                              } else {
                                selectedDocTypes.remove(value);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Filter by Transaction Status'),
                    Wrap(
                      spacing: 8.0,
                      children: transactionStatuses.map((String value) {
                        return ChoiceChip(
                          label: Text(value),
                          selected: selectedTransactionStatuses.contains(value),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedTransactionStatuses.add(value);
                              } else {
                                selectedTransactionStatuses.remove(value);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Search by Doc No.'),
                    TextField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          hintText: 'Enter Doc No.'),
                      onChanged: (value) {
                        setState(() {
                          docNoSearch = value;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Filter'),
              onPressed: () {
                setState(() {
                  filteredTransactions = transactions.where((transaction) {
                    bool matchesDocType = selectedDocTypes.isEmpty ||
                        selectedDocTypes.contains(transaction.docType);
                    bool matchesTransactionStatus =
                        selectedTransactionStatuses.isEmpty ||
                            selectedTransactionStatuses
                                .contains(transaction.transactionStatus);

                    // Modify matchesDocNo to check for exact integer value
                    bool matchesDocNo = docNoSearch == null ||
                        (transaction.docNo.toString() == docNoSearch);

                    return matchesDocType &&
                        matchesTransactionStatus &&
                        matchesDocNo;
                  }).toList();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void resetFilters() {
    setState(() {
      filteredTransactions = transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            child: ElevatedButton(
                              child: Text("Filter Criteria"),
                              onPressed: showFilterDialog,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: ElevatedButton(
                              child: Text("Reset"),
                              onPressed: resetFilters,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SfDataGrid(
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          source: _DataSource(filteredTransactions),
                          columns: <GridColumn>[
                            _buildGridColumn('Document Type'),
                            _buildGridColumn('Document Number'),
                            _buildGridColumn('Transacting Party'),
                            _buildGridColumn('Transaction Date'),
                            _buildGridColumn('Check Amount'),
                            _buildGridColumn('Transaction Status'),
                            GridColumn(
                              columnName: 'remarks',
                              label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                color: Colors.blueGrey.shade800,
                                child: const Text(
                                  'remarks',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  GridColumn _buildGridColumn(String columnName) {
    return GridColumn(
      columnName: columnName,
      label: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        color: Colors.blueGrey.shade800,
        child: Text(
          columnName,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }
}

class _DataSource extends DataGridSource {
  final List transactions;

  _DataSource(this.transactions);

  @override
  List<DataGridRow> get rows => transactions
      .map((data) => DataGridRow(
            cells: [
              DataGridCell(columnName: 'docType', value: data.docType),
              DataGridCell(columnName: 'docNo', value: data.docNo),
              DataGridCell(
                  columnName: 'transactingParty', value: data.transactingParty),
              DataGridCell(columnName: 'dateTrans', value: data.dateTrans),
              DataGridCell(columnName: 'checkAmount', value: data.checkAmount),
              DataGridCell(
                  columnName: 'transactionStatus',
                  value: data.transactionStatus),
              DataGridCell(columnName: 'remarks', value: data.remarks),
            ],
          ))
      .toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((dataCell) {
        if (dataCell.columnName == 'remarks') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5.0),
            child: TextButton(
              style: TextButton.styleFrom(
                alignment: Alignment.center,
              ),
              onPressed: () => TransactionDataScreen()
              ,
              child: const Text(
                'Add Attachments',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ),
          );
        }
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(
                dataCell.value.toString(),
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
