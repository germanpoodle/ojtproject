import 'package:flutter/material.dart';
import 'package:day13/widgets/card.dart';

String getCurrentDate() {
  DateTime now = DateTime.now();
  String formattedDate = "${now.month}-${now.day}-${now.year}";
  return formattedDate;
}

class DisbursementCheque extends StatelessWidget {
  const DisbursementCheque({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 9, 41, 145),
        toolbarHeight: 77,
        automaticallyImplyLeading: false,
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
                      getCurrentDate(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 8, 32, 134),
                      ),
                    ),
                    ElevatedButton(
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
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                width: screenWidth * 0.9,
                height: MediaQuery.of(context).size.height * 0.23,
                child: CustomCardExample(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
