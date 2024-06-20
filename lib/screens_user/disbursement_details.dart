import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '/models/disbursement_data_model.dart';
import '/screens_user/user_add_attachment.dart';
import 'package:http/http.dart' as http;

void navigateToNotifications(BuildContext context) {
  Navigator.pushNamed(context, '/notifications');
}

Future<List<DisbursementDetails>> fetchDisbursementDetails() async {
  final url = Uri.parse('http://127.0.0.1/localconnect/data.php'); 

  try {
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];

      List<DisbursementDetails> details = [];
      for (var item in data) {
        details.add(DisbursementDetails.fromJson(item));
      }
      return details;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

class DisbursementDetailsScreen extends StatelessWidget {
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
                    onPressed: () => navigateToNotifications(context),
                    icon: Icon(
                      Icons.notifications,
                      size: 16,
                      color: Color.fromARGB(255, 233, 227, 227),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<DisbursementDetails>>(
          future: fetchDisbursementDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final details = snapshot.data!;
              return ListView.builder(
                itemCount: details.length,
                itemBuilder: (context, index) {
                  final detail = details[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: detail.transactingParty,
                            decoration: InputDecoration(
                              hintText: 'Enter company name',
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: OutlineInputBorder(),
                            ),
                            enabled: false, // Non-editable field
                          ),
                          SizedBox(height: 20),
                          Table(
                            columnWidths: {
                              0: FlexColumnWidth(
                                  1), // Adjust column 0 (labels) width
                              1: FlexColumnWidth(
                                  2), // Adjust column 1 (text fields) width
                            },
                            border: TableBorder.all(
                                width: 1.0, color: Colors.black),
                            children: [
                              _buildTableRow('Doc Type', detail.docType),
                              _buildTableRow('Doc No', detail.docNo),
                              _buildTableRow(
                                  'Transacting Party', detail.transactingParty),
                              _buildTableRow('Transaction Status',
                                  detail.transactionStatus),
                              _buildTableRow('Check Amount', '₱${formatCurrency(detail.checkAmount)}'),

                              _buildEditableTableRow('Remarks', detail.remarks),
                            ],
                          ),
                          SizedBox(height: 20),
                          Center(
                              child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserAddAttachment()),
                              );
                            },
                            child: Text('Add Attachment'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                          )),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No data found'));
            }
          },
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: value,
              decoration: InputDecoration(
                hintText: 'Enter value',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
              ),
              enabled: false, 
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildEditableTableRow(String label, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: value,
              decoration: InputDecoration(
                hintText: 'Enter remarks',
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(),
              ),
              enabled: true,
            ),
          ),
        ),
      ],
    );
  }

  String formatCurrency(String amount) {
    double numericAmount = double.tryParse(amount) ?? 0.0;
    String formattedAmount = numericAmount.toStringAsFixed(2);
    return formattedAmount.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},');
  }
}
