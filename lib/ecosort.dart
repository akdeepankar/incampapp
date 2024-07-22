import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class EcoSort extends StatefulWidget {
  const EcoSort({super.key});

  @override
  State<EcoSort> createState() => _EcoSortState();
}

class _EcoSortState extends State<EcoSort> {
  Uint8List? pickedImageBytes;
  String mytext = '';
  bool scanning = false;
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _textController = TextEditingController();
  final String apiKey = 'AIzaSyCA25KPArcjrC0AbT8n8SweiV5ktE_ta0s';

  Future<void> getImage(ImageSource source) async {
    if (kIsWeb) {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files!.isEmpty) return;
        final reader = html.FileReader();
        reader.readAsArrayBuffer(files[0]!);

        reader.onLoadEnd.listen((e) async {
          setState(() {
            pickedImageBytes = reader.result as Uint8List;
          });
        });
      });
    } else {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() async {
          pickedImageBytes = await pickedFile.readAsBytes();
        });
      }
    }
  }

  Future<void> getdata(Uint8List imageBytes, String promptValue) async {
    setState(() {
      scanning = true;
      mytext = '';
    });

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final prompt = TextPart(promptValue);
      final imageParts = [DataPart('image/jpeg', imageBytes)];
      final response = await model.generateContent([
        Content.multi([prompt, ...imageParts])
      ]);

      setState(() {
        mytext = response.text!;
      });
    } catch (e) {
      setState(() {
        mytext = 'Error occurred: $e';
      });
    }

    setState(() {
      scanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text(
              'SORT WASTE EFFORTLESSLY',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            pickedImageBytes == null
                ? Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey[300],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                getImage(ImageSource.gallery);
                              },
                              icon: const Icon(
                                Icons.photo,
                                color: Colors.grey,
                                size: 100,
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'No Image Selected',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ))
                : SizedBox(
                    height: 340,
                    child: Center(
                        child: Image.memory(
                      pickedImageBytes!,
                      height: 400,
                    ))),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                getdata(
                  pickedImageBytes!,
                  'Identify recyclable, compostable, and landfill waste and mention which color dustbin should be used, also give Tips on proper recycling techniques if Applicable',
                );
              },
              icon: const Icon(
                Icons.energy_savings_leaf,
                color: Colors.white,
              ),
              label: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Sort',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            scanning
                ? const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(
                        child: SpinKitThreeBounce(
                      color: Colors.black,
                      size: 20,
                    )),
                  )
                : Text(mytext,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
