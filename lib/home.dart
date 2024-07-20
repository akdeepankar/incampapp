import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _mood;
  String? _surprise;
  String? _recommend;
  String? _fun;
  String _responseText = '';
  String _responseText2 = '';
  String _responseText3 = '';
  String _responseText4 = '';
  String _responseText5 = '';
  final String apiKey = 'AIzaSyCA25KPArcjrC0AbT8n8SweiV5ktE_ta0s';
  bool _isLoading = false;
  String? _curious;

  void _clearOptionsAndResponses() {
    setState(() {
      _mood = null;
      _surprise = null;
      _recommend = null;
      _curious = null;
      _fun = null;
      _responseText = '';
      _responseText2 = '';
      _responseText3 = '';
      _responseText4 = '';
      _responseText5 = '';
    });
  }

  Future<void> _generateResponse() async {
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
            'Depending on the Mood, Cheer them up in one sentence only - The Person is in $_mood Mood.')
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

  Future<void> _generateResponse2() async {
    if (apiKey.isEmpty) {
      setState(() {
        _responseText2 = 'No API key provided';
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
            'Give them a $_surprise idea in one sentence only to be executed by college student')
      ];
      final response = await model.generateContent(content);
      setState(() {
        _responseText2 = response.text!;
      });
    } catch (e) {
      setState(() {
        _responseText2 = 'Error generating story: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateResponse3() async {
    if (apiKey.isEmpty) {
      setState(() {
        _responseText3 = 'No API key provided';
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
            'Recommend a random $_recommend name and why in just a sentence.')
      ];
      final response = await model.generateContent(content);
      setState(() {
        _responseText3 = response.text!;
      });
    } catch (e) {
      setState(() {
        _responseText3 = 'Error generating story: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateResponse4() async {
    if (apiKey.isEmpty) {
      setState(() {
        _responseText4 = 'No API key provided';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final content = [
        Content.text('Make me curious by a sentence on any $_curious topic.')
      ];
      final response = await model.generateContent(content);
      setState(() {
        _responseText4 = response.text!;
      });
    } catch (e) {
      setState(() {
        _responseText4 = 'Error generating story: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateResponse5() async {
    if (apiKey.isEmpty) {
      setState(() {
        _responseText5 = 'No API key provided';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final content = [Content.text('In one sentence or word - $_fun ')];
      final response = await model.generateContent(content);
      setState(() {
        _responseText5 = response.text!;
      });
    } catch (e) {
      setState(() {
        _responseText5 = 'Error generating story: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildOption(String option, String label, String? selectedOption,
      void Function()? onTap) {
    bool isSelected = option == selectedOption;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? Colors.blue : Colors.grey[200],
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'I\'m Feeling',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 5),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildOption('Happy', 'Happy 😊', _mood, () {
                                  setState(() {
                                    _mood = 'Happy';
                                  });
                                  _generateResponse();
                                }),
                                const SizedBox(width: 4),
                                _buildOption('Sad', 'Sad 😔', _mood, () {
                                  setState(() {
                                    _mood = 'Sad';
                                  });
                                  _generateResponse();
                                }),
                                const SizedBox(width: 4),
                                _buildOption('Confused', 'Confused 😕', _mood,
                                    () {
                                  setState(() {
                                    _mood = 'Confused';
                                  });
                                  _generateResponse();
                                }),
                                const SizedBox(width: 4),
                                _buildOption('Stressed', 'Stressed 😕', _mood,
                                    () {
                                  setState(() {
                                    _mood = 'Stressed';
                                  });
                                  _generateResponse();
                                }),
                                const SizedBox(width: 4),
                                _buildOption('Excited', 'Excited 😕', _mood,
                                    () {
                                  setState(() {
                                    _mood = 'Excited';
                                  });
                                  _generateResponse();
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _responseText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Recommend me a',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildOption('Book', 'Book', _recommend,
                                        () {
                                      setState(() {
                                        _recommend = 'Book';
                                      });
                                      _generateResponse3();
                                    }),
                                    const SizedBox(width: 4),
                                    _buildOption('Music', 'Music', _recommend,
                                        () {
                                      setState(() {
                                        _recommend = 'Music';
                                      });
                                      _generateResponse3();
                                    }),
                                    const SizedBox(width: 4),
                                    _buildOption('Movie', 'Movie', _recommend,
                                        () {
                                      setState(() {
                                        _recommend = 'Movie';
                                      });
                                      _generateResponse3();
                                    }),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _responseText3,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Surprise Me!',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        _buildOption(
                                            'Event', 'Event', _surprise, () {
                                          setState(() {
                                            _surprise = 'Event';
                                          });
                                          _generateResponse2();
                                        }),
                                        const SizedBox(width: 4),
                                        _buildOption(
                                            'Startup', 'Startup', _surprise,
                                            () {
                                          setState(() {
                                            _surprise = 'Startup';
                                          });
                                          _generateResponse2();
                                        }),
                                        const SizedBox(width: 4),
                                        _buildOption(
                                            'Activity', 'Activity', _surprise,
                                            () {
                                          setState(() {
                                            _surprise = 'Activity';
                                          });
                                          _generateResponse2();
                                        }),
                                        const SizedBox(width: 4),
                                        _buildOption('Food', 'Food', _surprise,
                                            () {
                                          setState(() {
                                            _surprise = 'Food';
                                          });
                                          _generateResponse2();
                                        }),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _responseText2,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Make me Curious',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildOption(
                                        'Philosophy', 'Philosophy', _curious,
                                        () {
                                      setState(() {
                                        _curious = 'Philosophy';
                                      });
                                      _generateResponse4();
                                    }),
                                    const SizedBox(width: 4),
                                    _buildOption(
                                        'Mythology', 'Mythology', _curious, () {
                                      setState(() {
                                        _curious = 'Mythology';
                                      });
                                      _generateResponse4();
                                    }),
                                    const SizedBox(width: 4),
                                    _buildOption(
                                        'Scientific', 'Scientific', _curious,
                                        () {
                                      setState(() {
                                        _curious = 'Scientific';
                                      });
                                      _generateResponse4();
                                    }),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _responseText4,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Fun Stuff',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildOption('A Riddle', 'A Riddle', _fun,
                                        () {
                                      setState(() {
                                        _fun = 'A Riddle';
                                      });
                                      _generateResponse5();
                                    }),
                                    const SizedBox(width: 4),
                                    _buildOption(
                                        'A Fun Fact', 'A Fun Fact', _fun, () {
                                      setState(() {
                                        _fun = 'A Fun Fact';
                                      });
                                      _generateResponse5();
                                    }),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _responseText5,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: _clearOptionsAndResponses,
              tooltip: 'Clear Selections and Responses',
              child: const Icon(Icons.clear_all),
              backgroundColor: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
