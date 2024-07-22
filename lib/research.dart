import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:url_launcher/url_launcher.dart';

class Research extends StatefulWidget {
  @override
  _ResearchState createState() => _ResearchState();
}

class _ResearchState extends State<Research> {
  String _responseText = 'Research Paper';
  final String apiKey = 'AIzaSyCA25KPArcjrC0AbT8n8SweiV5ktE_ta0s';
  String _selectedOption1 = 'Any';
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
      final content = [
        Content.text(
            'Display Topics with Clickable Links for Research paper of type $_selectedOption1 on ${_questionController.text}')
      ];
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
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Widget _buildOption(String option, String label, String selectedOption,
      void Function()? onTap) {
    bool isSelected = option == selectedOption;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.blue : Colors.grey[200],
        ),
        child: Center(
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

  Future<void> _onOpen(String url) async {
    if (await canLaunch(url)) {
      try {
        await launch(url);
      } catch (e) {
        print('Error launching $url: $e');
      }
    } else {
      print('Could not launch $url');
    }
  }

  Widget _buildClickableText(String text) {
    final urlPattern = RegExp(r'https?:\/\/[^\s]+');
    final parts = text.split(urlPattern);
    final matches =
        urlPattern.allMatches(text).map((match) => match.group(0)!).toList();

    List<TextSpan> spans = [];
    for (int i = 0; i < parts.length; i++) {
      spans
          .add(TextSpan(text: parts[i], style: TextStyle(color: Colors.black)));
      if (i < matches.length) {
        spans.add(TextSpan(
          text: matches[i],
          style: TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()..onTap = () => _onOpen(matches[i]),
        ));
      }
    }

    return RichText(text: TextSpan(children: spans));
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
                  Text(
                    'Research',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      hintText: 'Efficient Energy',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      labelText: 'Research Paper Topic?',
                      labelStyle: TextStyle(color: Colors.blue),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
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
                  Text('Paper Type',
                      style: TextStyle(fontStyle: FontStyle.italic)),
                  SizedBox(height: 10),
                  Container(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        _buildOption('Any', 'Any', _selectedOption1, () {
                          setState(() {
                            _selectedOption1 = 'Any';
                          });
                        }),
                        _buildOption(
                            'Argumentative', 'Argumentative', _selectedOption1,
                            () {
                          setState(() {
                            _selectedOption1 = 'Argumentative';
                          });
                        }),
                        _buildOption(
                            'Analytical', 'Analytical', _selectedOption1, () {
                          setState(() {
                            _selectedOption1 = 'Analytical';
                          });
                        }),
                        _buildOption(
                            'Experimental', 'Experimental', _selectedOption1,
                            () {
                          setState(() {
                            _selectedOption1 = 'Experimental';
                          });
                        }),
                        _buildOption(
                            'Case Study', 'Case Study', _selectedOption1, () {
                          setState(() {
                            _selectedOption1 = 'Case Study';
                          });
                        }),
                        _buildOption('Literature Review', 'Literature Review',
                            _selectedOption1, () {
                          setState(() {
                            _selectedOption1 = 'Literature Review';
                          });
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _generateStory,
                    child: _isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.play_arrow, color: Colors.white),
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
                      child: _buildClickableText(_responseText),
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
