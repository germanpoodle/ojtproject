import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key, required Null Function(Uint8List? imageData) onImagePicked}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  List<Future<Uint8List?>> _imageFutures = [];

  Future<Uint8List?> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return await image.readAsBytes();
    }
    return null;
  }

  void _addImage() {
    setState(() {
      _imageFutures.add(_pickImage());
    });
  }

  Future<Uint8List?> readAsBytes(int index) async {
    if (index >= 0 && index < _imageFutures.length) {
      return await _imageFutures[index];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _addImage,
          child: Text('Pick Image'),
        ),
        Wrap(
          children: _imageFutures.asMap().entries.map((entry) {
            final index = entry.key;
            final future = entry.value;
            return FutureBuilder<Uint8List?>(
              future: future,
              builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.error),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  return Stack(
                    children: [
                      SizedBox(
                        height: 345,
                        width: 400,
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _imageFutures.removeAt(index);
                            });
                          },
                          child: Container(
                            color: Colors.white,
                            child: Icon(Icons.clear),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
