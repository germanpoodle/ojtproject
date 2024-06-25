import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/admin_transaction.dart';
import '../models/user_transaction.dart';

class CheckDetailsScreen extends StatefulWidget {
  final Transaction transaction;

  const CheckDetailsScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  _CheckDetailsScreenState createState() => _CheckDetailsScreenState();
}

class _CheckDetailsScreenState extends State<CheckDetailsScreen> {
  late Future<List<Map<String, dynamic>>> _checkDetailsFuture;

  @override
  void initState() {
    super.initState();
    _checkDetailsFuture = _fetchCheckDetails(
        widget.transaction.docNo, widget.transaction.docType);
  }

  Future<List<Map<String, dynamic>>> _fetchCheckDetails(
      String docNo, String docType) async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1/localconnect/view_details.php?doc_no=$docNo&doc_type=$docType'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch check details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final textScaleFactor = mediaQuery.textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Check Details',
            style: TextStyle(fontSize: 18 * textScaleFactor)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          CircleAvatar(
            child: Icon(Icons.person),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _checkDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Map<String, dynamic>> checkDetailsList = snapshot.data!;
            double totalDebit = 0.0;
            double totalCredit = 0.0;

            for (var details in checkDetailsList) {
              totalDebit += double.parse(details['debit_amount'] ?? '0');
              totalCredit += double.parse(details['credit_amount'] ?? '0');
            }

            return Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transacting Party: ${checkDetailsList.isNotEmpty ? checkDetailsList.first['transacting_party'] ?? '' : ''}',
                    style: TextStyle(
                        fontSize: 14 * textScaleFactor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Transaction Type: ${checkDetailsList.isNotEmpty ? checkDetailsList.first['trans_type_description'] ?? '' : ''}',
                    style: TextStyle(
                        fontSize: 13 * textScaleFactor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'Transaction Date: ${checkDetailsList.isNotEmpty ? checkDetailsList.first['date_trans'] ?? '' : ''}',
                            style: TextStyle(fontSize: 16 * textScaleFactor),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Account Description / SL Description',
                                style: TextStyle(
                                    fontSize: 11 * textScaleFactor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.1),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Credit',
                                    style: TextStyle(
                                        fontSize: 12 * textScaleFactor),
                                  ),
                                  SizedBox(width: screenWidth * 0.04),
                                  Text(
                                    'Debit',
                                    style: TextStyle(
                                        fontSize: 12 * textScaleFactor),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: checkDetailsList.length + 1,
                      itemBuilder: (context, index) {
                        if (index < checkDetailsList.length) {
                          final checkDetails = checkDetailsList[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    width: screenWidth * 0.7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${checkDetails['acct_description'] ?? ''}',
                                          style: TextStyle(
                                              fontSize: 12 * textScaleFactor),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${checkDetails['sl_description'] ?? ''}',
                                          style: TextStyle(
                                              fontSize: 10 * textScaleFactor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.1),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '₱ ${NumberFormat('#,###.##').format(double.parse(checkDetails['debit_amount'] ?? '0'))}',
                                        style: TextStyle(
                                            fontSize: 12 * textScaleFactor),
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(width: screenWidth * 0.04),
                                      Text(
                                        '₱ ${NumberFormat('#,###.##').format(double.parse(checkDetails['credit_amount'] ?? '0'))}',
                                        style: TextStyle(
                                            fontSize: 12 * textScaleFactor),
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(width: screenWidth * 0.02),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 11),
                            padding: EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '₱ ${NumberFormat('#,###.##').format(totalDebit)}',
                                  style: TextStyle(
                                      fontSize: 12 * textScaleFactor,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: screenWidth * 0.05),
                                Text(
                                  '₱ ${NumberFormat('#,###.##').format(totalCredit)}',
                                  style: TextStyle(
                                      fontSize: 12 * textScaleFactor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Padding(
                    padding: EdgeInsets.all(screenHeight * 0.02),
                    child: Text(
                      'Remarks: ${widget.transaction.remarks}',
                      style: TextStyle(
                        fontSize: 14 * textScaleFactor,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton.icon(
                    onPressed: () {
                      // functionality to view attachment
                    },
                    icon: Icon(Icons.attachment),
                    label: Text('View Attachment',
                        style: TextStyle(fontSize: 16 * textScaleFactor)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth, screenHeight * 0.07),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  ElevatedButton.icon(
                    onPressed: () {
                      // functionality to approve
                    },
                    icon: Icon(Icons.check),
                    label: Text('Approve',
                        style: TextStyle(fontSize: 16 * textScaleFactor)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth, screenHeight * 0.07),
                      backgroundColor: Colors.green,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  ElevatedButton.icon(
                    onPressed: () {
                      // functionality to decline
                    },
                    icon: Icon(Icons.close),
                    label: Text('Reject',
                        style: TextStyle(fontSize: 16 * textScaleFactor)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth, screenHeight * 0.07),
                      backgroundColor: Color.fromARGB(255, 175, 164, 164),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton.icon(
                    onPressed: () {
                      // functionality to decline
                    },
                    icon: Icon(Icons.close),
                    label: Text('Decline',
                        style: TextStyle(fontSize: 16 * textScaleFactor)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth, screenHeight * 0.07),
                      backgroundColor: Color.fromARGB(255, 175, 164, 164),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
