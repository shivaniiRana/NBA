import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDataLoaded = false;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    // Set up animation controller
    _controller = AnimationController(
      duration: Duration(seconds: 3), // Duration of the entire animation
      vsync: this,
    );

    // Scale animation (logo will grow from small to full size)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Fade animation (text will fade in after logo)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    // Start animation
    _controller.forward();

    // Fetch the data from Firebase
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      // Fetch data from Firebase
      final DatabaseEvent event = await _database.child('categories').once();
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        // Assuming the data is valid, you can set _isDataLoaded to true
        setState(() {
          _isDataLoaded = true;
        });
      } else {
        setState(() {
          _isDataLoaded = true; // If no data is available, still allow navigation
        });
      }
    } catch (e) {
      setState(() {
        _isDataLoaded = true; // If error occurs, still allow navigation
      });

      // Ensure the SnackBar is shown only when the context is valid
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error fetching data: $e')),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();  // Dispose of the controller when it's no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If data is loaded and animation is done, navigate to HomePage
    if (_isDataLoaded) {
      // Schedule navigation after the current frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,  // Background color for contrast
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/images/nbalogo.jpg',  // Make sure the logo image path is correct
                width: 150,  // Adjust the size as needed
                height: 150,
              ),
            ),
            SizedBox(height: 20), // Space between image and text

            // Animated Text
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'NBA Highlights',
                style: TextStyle(
                  fontSize: 30,  // Font size for the app name
                  fontWeight: FontWeight.bold,  // Make the text bold
                  color: Colors.white,  // White text color for visibility on dark background
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
