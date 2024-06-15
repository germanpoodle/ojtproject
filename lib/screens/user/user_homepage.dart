import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(const HomePage());
}

class TransactionData {
  final int id;
  final String transactingParty;
  final String docNo;
  final DateTime dateTrans;
  final String transTypeDescription;
  final DateTime checkDate;
  final String checkNo;
  final String checkDraweeBank;
  final double checkAmount;
  final String transactionStatus;
  final String remarks;

  TransactionData({
    required this.id,
    required this.transactingParty,
    required this.docNo,
    required this.dateTrans,
    required this.transTypeDescription,
    required this.checkDate,
    required this.checkNo,
    required this.checkDraweeBank,
    required this.checkAmount,
    required this.transactionStatus,
    required this.remarks,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: int.parse(json['id'].toString()), // Ensure 'id' is parsed as an integer
      transactingParty: json['transacting_party'].toString(),
      docNo: json['doc_no'].toString(),
      dateTrans: DateTime.parse(json['date_trans'].toString()),
      transTypeDescription: json['trans_type_description'].toString(),
      checkDate: DateTime.parse(json['check_date'].toString()),
      checkNo: json['check_no'].toString(),
      checkDraweeBank: json['check_drawee_bank'].toString(),
      checkAmount: double.parse(json['check_amount'].toString()),
      transactionStatus: json['transaction_status'].toString(),
      remarks: json['remarks'].toString(),
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

  @override
  void initState() {
    super.initState();
    isLoading = true;
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/localconnect/fetch_transaction_data.php'));

      if (response.statusCode == 200) {
        setState(() {
          final List<dynamic> data = json.decode(response.body);
          transactions = data.map((json) => TransactionData.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to connect to server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
              : Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: SfDataGrid(
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    frozenColumnsCount: 1,
                    source: _DataSource(transactions),
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: 'id',
                        label: Container(
                          child: const Text('ID'),
                          alignment: Alignment.center,
                        ),
                      ),
                      GridColumn(
                        columnName: 'transactingParty',
                        label: Container(
                          child: const Text('Transacting Party'),
                          alignment: Alignment.center,
                        ),
                      ),
                      GridColumn(
                        columnName: 'docNo',
                        label: Container(
                          child: const Text('Doc No'),
                          alignment: Alignment.center,
                        ),
                      ),
                      GridColumn(
                        columnName: 'dateTrans',
                        label: Container(
                          child: const Text('Transaction Date'),
                          alignment: Alignment.center,
                        ),
                      ),
                      GridColumn(
                        columnName: 'transTypeDescription',
                        label:Container(
                          child: const Text('Type'),
                          alignment: Alignment.center,
                        ),
                      ),
                      GridColumn(
                        columnName: 'checkDate',
                        label: Container(
                          child: const Text('Check Date'),
                          alignment: Alignment.center,
                        ),
                      ),
                      GridColumn(
                        columnName: 'checkNo',
                        label: Container(
                          child: const Text('Check Number'),
                          alignment: Alignment.center,
                        ),
                      ),
                      GridColumn(
                        columnName: 'checkDraweeBank',
                        label: Container(
                          child: const Text('Check Drawee Bank'),
                          alignment: Alignment.center,
                        ),
                      ),
                      GridColumn(
                        columnName: 'checkAmount',
                        label: Container(
                          child: const Text('Check Amount'),
                          alignment: Alignment.center,
                        ),
                      ),
                      GridColumn(
                        columnName: 'transactionStatus',
                        label: Container(
                          child: const Text('Status'),
                        ),
                      ),
                      GridColumn(
                        columnName: 'remarks',
                        label: Container(
                          child: const Text('Remarks'),
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _DataSource extends DataGridSource {
  final List<TransactionData> transactions;

  _DataSource(this.transactions);

  @override
  List<DataGridRow> get rows => transactions.map<DataGridRow>((data) => DataGridRow(
        cells: [
          DataGridCell<int>(columnName: 'id', value: data.id),
          DataGridCell<String>(columnName: 'transactingParty', value: data.transactingParty),
          DataGridCell<String>(columnName: 'docNo', value: data.docNo),
          DataGridCell<DateTime>(columnName: 'dateTrans', value: data.dateTrans),
          DataGridCell<String>(columnName: 'transTypeDescription', value: data.transTypeDescription),
          DataGridCell<DateTime>(columnName: 'checkDate', value: data.checkDate),
          DataGridCell<String>(columnName: 'checkNo', value: data.checkNo),
          DataGridCell<String>(columnName: 'checkDraweeBank', value: data.checkDraweeBank),
          DataGridCell<double>(columnName: 'checkAmount', value: data.checkAmount),
          DataGridCell<String>(columnName: 'transactionStatus', value: data.transactionStatus),
          DataGridCell<String>(columnName: 'remarks', value: data.remarks),
        ],
      )).toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        if (dataCell.columnName == 'remarks') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle "Add Attachments" button press
              },
              child: const Text('Add Attachments'),
            ),
          );
        }
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
