import 'package:flutter/material.dart';
import 'package:ojtproject/widget/card.dart';

String getCurrentDate() {
  DateTime now = DateTime.now();
  String formattedDate = "${now.month}-${now.day}-${now.year}";
  return formattedDate;
}

class DisbursementCheque extends StatelessWidget {
  const DisbursementCheque({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 9, 41, 145),
        toolbarHeight: 77,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 15, height: 45),
            Text(
              'Disbursement',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 233, 227, 227),
              ),
            ),
            SizedBox(width: 260),
            Icon(
              size: 25,
              Icons.notifications,
              color: Color.fromARGB(255, 233, 227, 227),
            ),
            SizedBox(width: 5),
            Row(
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(125, 68, 65, 65),
                      padding: EdgeInsets.zero,
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 25,
                      color: Color.fromARGB(255, 233, 227, 227),
                    ),
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
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(27.5),
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          getCurrentDate(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 8, 32, 134),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 290),
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {},
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
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.82,
                child: 
                CustomCardExample(
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
