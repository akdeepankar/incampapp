import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Book extends StatefulWidget {
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  String _responseText = 'Press the button to get Recommendations.';
  final String apiKey = 'AIzaSyCA25KPArcjrC0AbT8n8SweiV5ktE_ta0s'; // Replace with your actual API key
  bool _isLoading = false;

  final List<Map<String, dynamic>> mcqQuestions = [
    {
      'question': 'What genre do you enjoy the most?',
      'options': ['Fiction', 'Non-fiction', 'Mystery/Thriller'],
      'selectedAnswer': 'Fiction',
    },
    {
      'question': 'Which academic field interests you the most?',
      'options': ['History and Politics', 'Sci and Tech', 'Literature and Arts'],
      'selectedAnswer': 'History and Politics',
    },
    {
      'question': 'What type of writing style do you prefer?',
      'options': ['Formal and Academic', 'Informal and Conversational', 'Poetic and Descriptive'],
      'selectedAnswer': 'Formal and Academic',
    },
    {
      'question': 'How do you usually prefer to consume books?',
      'options': ['Physical books', 'E-books', 'Audiobooks'],
      'selectedAnswer': 'Physical books',
    },
    {
      'question': 'Which of these authors do you admire?',
      'options': ['Stephen Hawking', 'J.K. Rowling', 'Malcolm Gladwell'],
      'selectedAnswer': 'Stephen Hawking',
    },
  ];

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

      // Construct the prompt string
      String prompt = 'Suggest 5 Books Names using this preferences:\n';
      for (var question in mcqQuestions) {
        prompt += '${question["question"]}: ${question["selectedAnswer"]}\n';
      }

      final content = [
        Content.text(prompt)
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

  Widget _buildOption(String question, List<String> options, String selectedAnswer, void Function(String) onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        question,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
      SizedBox(height: 10),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: options.map((option) => _buildOptionButton(option, selectedAnswer, onChanged)).toList(),
        ),
      ),
    ],
  );
}


  Widget _buildOptionButton(String option, String selectedAnswer, void Function(String) onChanged) {
    bool isSelected = option == selectedAnswer;
    return GestureDetector(
      onTap: () {
        onChanged(option);
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Colors.blue : Colors.grey[200],
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10)
        ],
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
                  Text('Recommendations', style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: mcqQuestions.map((mcq) {
                      String question = mcq['question']!;
                      List<String> options = mcq['options']!;
                      String selectedAnswer = mcq['selectedAnswer']!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOption(question, options, selectedAnswer, (selectedOption) {
                            setState(() {
                              mcq['selectedAnswer'] = selectedOption;
                            });
                          }),
                          SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _generateStory,
                    child: _isLoading ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: Colors.blue,),
                    ) : Padding(
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
                      child: Text(
                        _responseText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
