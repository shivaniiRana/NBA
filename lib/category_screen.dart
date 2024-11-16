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
  bool _isSpeaking = false; // Track if TTS is currently speaking

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  // Initialize TTS settings (e.g., language, rate, volume)
  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage("en-US"); // Set default language to English
    await _flutterTts.setSpeechRate(0.5); // Set speech rate (0.0 - 1.0)
    await _flutterTts.setVolume(1.0); // Set volume (0.0 - 1.0)

    // Optionally, handle TTS initialization errors
    _flutterTts.setErrorHandler((msg) {
      print("Error with TTS: $msg");
    });
  }

  // This function will trigger speech to read the category description
  Future<void> _speak(String text) async {
    if (text.isNotEmpty && !_isSpeaking) {
      setState(() {
        _isSpeaking = true;
      });
      await _flutterTts.speak(text);
    }
  }

  // This function will stop any ongoing speech (optional, if you need a stop button)
  Future<void> _stop() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String description = widget.category['description'] ?? 'No description available';
    final String imageUrl = widget.category['thumbnailUrl'] ?? '';  // Handle missing image

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category['name'] ?? 'Category'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white), // Set the back arrow to white
        titleTextStyle: TextStyle(
          color: Colors.white,  // Set title text color to white
          fontSize: 20,         // Set font size of the title
          fontWeight: FontWeight.bold, // Optional: make title bold
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the image from the URL or a placeholder
              Stack(
                alignment: Alignment.bottomRight, // Position icon at the bottom-right
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

                  // Speaker icon positioned at the bottom-right of the image
                  Container(
                    margin: EdgeInsets.only(bottom: 15, right: 20),  // Margin from the bottom and right
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),  // Semi-transparent black background
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(4), // Add padding for a better visual effect
                    child: IconButton(
                      icon: Icon(
                        _isSpeaking ? Icons.pause_circle_filled : Icons.volume_up,
                        size: 32,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (_isSpeaking) {
                          _stop();  // Pause speech
                        } else {
                          _speak(description);  // Start speech
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Display the description of the category
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

  // Disposing flutter_tts instance to prevent memory leaks
  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop(); // Stop any speech that may still be running
  }
}