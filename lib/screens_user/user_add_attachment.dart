import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'disbursement_details.dart';
class UserAddAttachment extends StatefulWidget {
  const UserAddAttachment({Key? key}) : super(key: key);

  @override
  State<UserAddAttachment> createState() => _UserAddAttachmentState();
}

class _UserAddAttachmentState extends State<UserAddAttachment> {
  List<Map<String, String>> attachments = [];
  String? _fileName;
  PlatformFile? _pickedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
        _fileName = _pickedFile!.name;
        attachments.add({'name': _fileName!, 'status': 'Uploaded'});
      });
    }
  }

  Future<void> _requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      _pickFile();
    }
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
              'View Disbursement Details',
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
                      print('Notification button pressed');
                    },
                    icon: const Icon(
                      Icons.notifications,
                      size: 25,
                      color: Color.fromARGB(255, 126, 124, 124),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle profile button press
                    print('Profile button pressed');
                  },
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Attachment',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: Colors.grey[200],
                      padding: const EdgeInsets.all(24.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onPressed: _pickFile,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Click to upload',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            'Max. File Size: 5Mb',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_fileName != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Selected file: $_fileName'),
                    ),
                  const SizedBox(height: 20.0),
                  for (var attachment in attachments)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: _buildAttachmentItem(attachment['name']!, attachment['status']!),
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DisbursementDetailsScreen()),
            );
                          },
                          child: const Text('Discard'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle attach file button press
                            print('Attach file button pressed');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Attach File'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(String fileName, String status) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Icon(Icons.image),
        ),
        const SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fileName,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              status,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            setState(() {
              attachments.removeWhere((element) => element['name'] == fileName);
              print('Attachment removed: $fileName');
            });
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}

