import 'package:flutter/material.dart';
import '/screens_user/disbursement_details.dart';
import '/screens_user/user_homepage.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class ViewFilesPage extends StatefulWidget {
  final List<File> attachments;

  const ViewFilesPage({Key? key, required this.attachments}) : super(key: key);

  @override
  _ViewFilesPageState createState() => _ViewFilesPageState();
}

class _ViewFilesPageState extends State<ViewFilesPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserHomePage()),
        );
        break;
      case 1:
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DisbursementDetailsScreen(
        //       transaction: widget.transaction,
        //       selectedDetails: widget.selectedDetails,
        //     ),
        //   ),
        // );
        break;
      case 2:
        // Example: Handle navigation to a new screen
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const MenuWindow()),
        // );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Size screenSize = MediaQuery.of(context).size;
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
                      //   MaterialPageRoute(builder: (context) => NotificationScreen()),
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
      body: widget.attachments.isNotEmpty
          ? ListView.builder(
              itemCount: widget.attachments.length,
              itemBuilder: (context, index) {
                final file = widget.attachments[index];
                return ListTile(
                  leading: const Icon(Icons.attach_file),
                  title: Text(file.path.split('/').last), // Display file name
                  subtitle: Text(file.path), // Display file path
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      // Handle remove file action
                      // Example: removeAttachment(file);
                      // This can be implemented based on your logic to remove the file from the list
                    },
                  ),
                  onTap: () async {
                    await OpenFile.open(file.path);
                  },
                );
              },
            )
          : const Center(
              child: Text('No files uploaded.'),
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
