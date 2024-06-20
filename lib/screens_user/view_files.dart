import 'package:flutter/material.dart';

class ViewFilesPage extends StatelessWidget {
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
            const Text(
              'View Files',
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
                    onPressed: () {
                      // Handle notification button press
                    },
                    icon: Icon(
                      Icons.notifications,
                      size: 25,
                      color: Color.fromARGB(255, 126, 124, 124),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle profile button press
                  },
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
      body: Center(
        child: Text('Files will be listed here.'),
      ),
    );
  }
}
