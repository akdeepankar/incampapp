import 'dart:typed_data';
import 'dart:html' as html; // For web
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Bf extends StatefulWidget {
  const Bf({super.key});

  @override
  State<Bf> createState() => _BfState();
}

class _BfState extends State<Bf> {
  Uint8List? _imageBytes;
  String _selectedOption1 = '';
  String _selectedOption2 = '';
  bool _isLoading = false;
  String _responseText = '';

  final TextEditingController prompt = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  final String apiKey = 'AIzaSyCA25KPArcjrC0AbT8n8SweiV5ktE_ta0s';

  Future<void> _pickImage() async {
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
            _imageBytes = reader.result as Uint8List;
          });
        });
      });
    } else {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() async {
          _imageBytes = await pickedFile.readAsBytes();
        });
      }
    }
  }

  Future<void> _generateResponse() async {
    if (_imageBytes == null) {
      setState(() {
        _responseText = 'No image selected';
      });
      return;
    }

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final promptText =
        'My Budget is ${prompt.text}. What food item do you suggest for $_selectedOption1 and should be for $_selectedOption2?';
    final promptPart = TextPart(promptText);
    final imagePart = DataPart('image/jpeg', _imageBytes!);

    try {
      final response = await model.generateContent([
        Content.multi([promptPart, imagePart])
      ]);

      setState(() {
        _responseText = response.text!;
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              _imageBytes == null
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
                              onPressed: _pickImage,
                              icon: const Icon(Icons.photo,
                                  color: Colors.grey, size: 100),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Upload Food Menu',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 340,
                      child: Center(
                        child: Image.memory(_imageBytes!, height: 400),
                      ),
                    ),
              const SizedBox(height: 20),
              TextField(
                controller: prompt,
                decoration: InputDecoration(
                  hintText: '350',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: 'Budget per Person In INR',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'I want to have',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildOption('Breakfast', 'Breakfast', _selectedOption1, () {
                    setState(() {
                      _selectedOption1 = 'Breakfast';
                    });
                  }),
                  _buildOption('Lunch', 'Lunch', _selectedOption1, () {
                    setState(() {
                      _selectedOption1 = 'Lunch';
                    });
                  }),
                  _buildOption('Dinner', 'Dinner', _selectedOption1, () {
                    setState(() {
                      _selectedOption1 = 'Dinner';
                    });
                  }),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Other Info',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildOption('Vegetarian', 'Vegetarian', _selectedOption2,
                      () {
                    setState(() {
                      _selectedOption2 = 'Vegetarian';
                    });
                  }),
                  _buildOption('Non Veg', 'Non Veg', _selectedOption2, () {
                    setState(() {
                      _selectedOption2 = 'Non Veg';
                    });
                  }),
                  _buildOption('Fever / Cold', 'Fever / Cold', _selectedOption2,
                      () {
                    setState(() {
                      _selectedOption2 = 'Fever / Cold';
                    });
                  }),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _generateResponse,
                icon: Icon(Icons.local_pizza, color: Colors.white),
                label: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Suggest me Food',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              SizedBox(height: 30),
              if (_responseText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                      child: Text(_responseText,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20))),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String option, String label, String selectedOption,
      void Function()? onTap) {
    bool isSelected = option == selectedOption;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? Colors.blue : Colors.grey[200],
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
