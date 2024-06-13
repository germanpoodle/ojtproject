import 'package:flutter/material.dart';
import 'package:ojtproject/screens/filter_pop_up.dart';
import 'package:ojtproject/widget/card.dart';

String getCurrentDate() {
  DateTime now = DateTime.now();
  String formattedDate = "${now.month}-${now.day}-${now.year}";
  return formattedDate;
}
void navigateToNotifications(BuildContext context) {
  Navigator.pushNamed(context, '/notifications');
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
              'For Apporval',
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
                    onPressed: () { navigateToNotifications(context);},
                    icon: Icon(
                      Icons.notifications,
                      size: 25,
                      color: Color.fromARGB(255, 126, 124, 124),
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
                    GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FilterDialog();
                  },
                );
              },
              child: Container(
                height: 35,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 15, 14, 14),
                      Color(0xff281537),
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Filter Results',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
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
