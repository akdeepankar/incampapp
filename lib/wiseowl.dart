import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:js' as js;

class WiseOwl extends StatefulWidget {
  @override
  _WiseOwlState createState() => _WiseOwlState();
}

class _WiseOwlState extends State<WiseOwl> {
  String _responseText = 'Press the button to generate a story.';
  final String apiKey = 'AIzaSyCA25KPArcjrC0AbT8n8SweiV5ktE_ta0s'; // Replace with your API key  
  int _selectedDuration = 5; // Default duration is 5 minutes  
  bool _isLoading = false; // Loading state  
  bool _isSpeaking = false;
  bool _isPaused = false;

  final TextEditingController _questionController = TextEditingController();

  Future<void> _generateStory() async {
    if (apiKey.isEmpty) {
      setState(() {
        _responseText = 'No API key provided';
      });
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final content = [Content.text('Generate a $_selectedDuration min topic on ' + _questionController.text)];
      final response = await model.generateContent(content);
      setState(() {
        _responseText = response.text!;
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error generating story: $e';
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  void _speakText() {
    if (_isSpeaking) return;

    final String jsCode = '''
      var utterance = new SpeechSynthesisUtterance(`$_responseText`);
      utterance.onend = function(event) {
        // Notify Dart when speaking is finished
        window.flutter_inappwebview.callHandler('onSpeechEnd');
      };
      window.speechSynthesis.speak(utterance);
    ''';
    js.context.callMethod('eval', [jsCode]);
    setState(() {
      _isSpeaking = true;
      _isPaused = false;
    });
  }

  void _pauseSpeech() {
    final String jsCode = '''
      window.speechSynthesis.pause();
    ''';
    js.context.callMethod('eval', [jsCode]);
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeSpeech() {
    final String jsCode = '''
      window.speechSynthesis.resume();
    ''';
    js.context.callMethod('eval', [jsCode]);
    setState(() {
      _isPaused = false;
    });
  }

  void _stopSpeech() {
    final String jsCode = '''
      window.speechSynthesis.cancel();
    ''';
    js.context.callMethod('eval', [jsCode]);
    setState(() {
      _isSpeaking = false;
      _isPaused = false;
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Widget _buildDurationOption(int duration, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDuration = duration;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _selectedDuration == duration ? Colors.blue : Colors.grey[200],
          ),
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
          child: Text(
            label,
            style: TextStyle(
              color: _selectedDuration == duration ? Colors.white : Colors.black,
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
        FocusScope.of(context).requestFocus(FocusNode()); // Dismiss the keyboard when screen is touched
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildDurationOption(2, '2 minutes'),
                      _buildDurationOption(5, '5 minutes'),
                      _buildDurationOption(10, '10 minutes'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _questionController,
                          decoration: InputDecoration(
                            hintText: 'Topic for the podcast',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Topic',
                            labelStyle: TextStyle(
                              color: Colors.blue,
                            ),
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
                      ),
                      SizedBox(width: 5),
                      Container(
                        height: 46,
                        width: 86,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _generateStory,
                          child: _isLoading
                              ? SpinKitThreeBounce(color: Colors.black, size: 20)
                              : Icon(Icons.play_arrow, color: Colors.blue),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: 300.0,
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        _responseText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _isSpeaking ? (_isPaused ? _resumeSpeech : _pauseSpeech) : _speakText,
                        child: Icon(
                          _isSpeaking ? (_isPaused ? Icons.play_arrow : Icons.pause) : Icons.volume_up,
                          color: Colors.blue,
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _stopSpeech,
                        child: Icon(Icons.stop, color: Colors.red),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
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
