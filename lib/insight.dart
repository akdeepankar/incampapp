import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Insight extends StatefulWidget {
  @override
  _InsightState createState() => _InsightState();
}

class _InsightState extends State<Insight> {
  String _responseText = 'Analyse.';
  final String apiKey = 'AIzaSyCA25KPArcjrC0AbT8n8SweiV5ktE_ta0s';
  bool _isLoading = false;
  final TextEditingController _questionController = TextEditingController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> questions = [
    {
      'title': '',
      'widget': (context, state) => Image.asset('assets/images/cf.png', height: 400, width: 400),
    },
    {
      'title': 'What is your primary mode of transportation on Campus?',
      'options': ['Institute Bus', 'Bicycle', 'Electric Vehicle', 'Walking', 'Car', 'Motorcycle'],
      'selectedOption': '',
    },
    {
      'title': 'What type of fuel does your vehicle use?',
      'options': ['Diesel', 'Electric', 'Petrol'],
      'selectedOption': '',
    },
    {
      'title': 'What type of housing do you live in?',
      'options': ['Paying Guest', 'Dormitory', 'Hostel',],
      'selectedOption': '',
    },
    {
      'title': 'How often do you eat meat?',
      'options': ['Daily', 'Weekly', 'Monthly', 'Never'],
      'selectedOption': '',
    },
    {
      'title': 'How often do you eat dairy products?',
      'options': ['Daily', 'Weekly', 'Monthly', 'Rarely'],
      'selectedOption': '',
    },
    {
      'title': 'How much food do you waste per week?',
      'options': ['None', 'A Little', 'Some', 'A Lot'],
      'selectedOption': '',
    },
    {
      'title': 'Do you recycle?',
      'options': ['Always', 'Often', 'Sometimes', 'Rarely', 'Never'],
      'selectedOption': '',
    },
    {
      'title': 'What items do you recycle?',
      'options': ['Paper', 'Plastic', 'Glass', 'Metal', 'Electronics'],
      'selectedOption': '',
    },
    {
      'title': 'How often do you buy new clothes?',
      'options': ['Monthly', 'Every few months', 'Yearly', 'Rarely'],
      'selectedOption': '',
    },
    {
      'title': 'How often do you purchase new electronics?',
      'options': ['Yearly', 'Every 2-3 years', 'Every 4-5 years', 'Rarely'],
      'selectedOption': '',
    },
    {
      'title': 'Are you involved in any environmental organizations or initiatives?',
      'options': ['Yes', 'No'],
      'selectedOption': '',
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
      final content = [
        Content.text(
            'Provide a comprehensive analysis of the users carbon footprint by the following Data.  Primary mode of transportation on Campus is ${questions[1]['selectedOption']}, fuel does your vehicle use?  ${questions[2]['selectedOption']}, housing do you live in?  ${questions[3]['selectedOption']}, How often do you eat meat? ${questions[4]['selectedOption']}, How often do you eat diary products? ${questions[5]['selectedOption']}, How much food do you waste per week? ${questions[6]['selectedOption']}, Do you recycle? ${questions[7]['selectedOption']}, How often do you buy new clothes? ${questions[8]['selectedOption']}, How often do you purchase new electronics? ${questions[9]['selectedOption']}, How often do you purchase new electronics? ${questions[10]['selectedOption']}, Are you involved in any environmental organizations or initiatives? ${questions[11]['selectedOption']} ')
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

  Widget _buildOption(String option, String selectedOption, void Function()? onTap) {
    bool isSelected = option == selectedOption;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          width: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? Colors.blue : Colors.grey[200],
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(
            option,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    var question = questions[index];
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ' ${question['title']}',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            if (question.containsKey('options'))
              ...question['options'].map<Widget>((option) {
                return _buildOption(option, question['selectedOption'], () {
                  setState(() {
                    question['selectedOption'] = option;
                  });
                });
              }).toList(),
            if (question.containsKey('widget')) question['widget'](context, this),
          ],
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: questions.length + 1,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      if (index == questions.length) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _isLoading ? null : _generateStory,
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Analyse Carbon Footprint', style: TextStyle(color: Colors.black),),
                              style: ElevatedButton.styleFrom(
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
                        );
                      }
                      return _buildCard(index);
                    },
                  ),
                ),
                if (_currentIndex < questions.length)
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${questions.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(questions.length + 1, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      width: _currentIndex == index ? 10.0 : 6.0,
                      height: _currentIndex == index ? 10.0 : 6.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index ? Colors.blue : Colors.grey,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
