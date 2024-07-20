import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Impact extends StatefulWidget {
  @override
  _ImpactState createState() => _ImpactState();
}

class _ImpactState extends State<Impact> {
  String _responseText = 'Press the button for Product Impact Analysis.';
  final String apiKey = 'AIzaSyCA25KPArcjrC0AbT8n8SweiV5ktE_ta0s';
  String _selectedOption1 = 'Local Vendor';
  String _selectedOption2 = 'Rarely';
  bool _isLoading = false;
  final TextEditingController _questionController = TextEditingController();

  Future<void> _generateStory() async {
    if (apiKey.isEmpty) {
      setState(() {
        _responseText = 'No API key provided';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final content = [Content.text(' Analyse the environmental impact of purchasing decisions through $_selectedOption1$_selectedOption2 of ${_questionController.text}')];
      final response = await model.generateContent(content);
      setState(() {
        _responseText = response.text!;
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error generating Analysis: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Widget _buildOption(String option, String label, String selectedOption, void Function()? onTap) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Impact Analysis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  SizedBox(height: 10),
                  TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      hintText: 'Lays Chips',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      labelText: 'What product did you purchase?',
                      labelStyle: TextStyle(color: Colors.blue),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                  SizedBox(height: 10),
                  Text('Where did you purchase this product?', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildOption('On Campus', 'On Campus', _selectedOption1, () {
                        setState(() {
                          _selectedOption1 = 'On Campus';
                        });
                      }),
                      _buildOption('Local Vendor', 'Local Vendor', _selectedOption1, () {
                        setState(() {
                          _selectedOption1 = 'Local Vendor';
                        });
                      }),
                      _buildOption('Online', 'Online', _selectedOption1, () {
                        setState(() {
                          _selectedOption1 = 'Online';
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('How often do you buy this product?', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildOption('Daily/ Weekly', 'Daily/ Weekly', _selectedOption2, () {
                        setState(() {
                          _selectedOption2 = 'Daily/ Weekly';
                        });
                      }),
                      _buildOption('Monthly', 'Monthly', _selectedOption2, () {
                        setState(() {
                          _selectedOption2 = 'Monthly';
                        });
                      }),
                      _buildOption('Rarely', 'Rarely', _selectedOption2, () {
                        setState(() {
                          _selectedOption2 = 'Rarely';
                        });
                      }),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _generateStory,
                    child: _isLoading ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SpinKitThreeBounce(color: Colors.black,size: 20,),
                    ) : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.play_arrow, color: Colors.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    constraints: BoxConstraints(maxHeight: 300.0),
                    child: SingleChildScrollView(
                      child: Text(
                        _responseText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
