import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CategoryScreen extends StatefulWidget {
  final Map<dynamic, dynamic> category;

  CategoryScreen({required this.category});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _isPaused = false;
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);

    bool isAvailable = await _flutterTts.isLanguageAvailable("en-US");
    if (isAvailable) {
      print("TTS is ready.");
    } else {
      print("TTS language not available.");
    }

    _flutterTts.setErrorHandler((msg) {
      print("Error with TTS: $msg");
    });

    // Listen to the completion event
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
        _isPaused = false;
      });
    });
  }

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      if (_isSpeaking) {
        // If speaking, we pause the speech
        await _flutterTts.stop();
        setState(() {
          _isSpeaking = false;
          _isPaused = true;
          _currentText = text; // Save the current text to resume later
        });
      } else if (_isPaused) {
        // If paused, we restart the speech from the saved text
        await _flutterTts.speak(_currentText);
        setState(() {
          _isSpeaking = true;
          _isPaused = false;
        });
      } else {
        // If not speaking or paused, we start new speech
        setState(() {
          _isSpeaking = true;
        });
        await _flutterTts.speak(text);
        setState(() {
          _currentText = text; // Save the current text being spoken
        });
      }
    }
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
      _isPaused = false;
      _currentText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final String description = widget.category['description'] ?? 'No description available';
    final String imageUrl = widget.category['thumbnailUrl'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category['name'] ?? 'Category'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the image
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  imageUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(Icons.error, color: Colors.red, size: 50),
                          ),
                        );
                      },
                    ),
                  )
                      : Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "No Image Available",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // TTS icon
                  Container(
                    margin: EdgeInsets.only(bottom: 15, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(4),
                    child: IconButton(
                      icon: Icon(
                        _isSpeaking
                            ? Icons.pause_circle_filled
                            : _isPaused
                            ? Icons.play_circle_filled
                            : Icons.volume_up,
                        size: 32,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _speak(description);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                description,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop(); // Stop any speech that may still be running
  }
}
