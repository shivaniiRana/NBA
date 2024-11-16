import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  bool _isFirstLaunch = true;  // Variable to track if it's the first launch

  @override
  void initState() {
    super.initState();

    // Set up animation controller for the splash screen
    _controller = AnimationController(
      duration: Duration(seconds: 3),  // Splash screen animation duration
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

    // Start checking if it's the first time the app is launched
    _checkFirstLaunch();
  }

  // Function to check if it's the first launch
  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLaunch = prefs.getBool('isFirstLaunch');

    if (isFirstLaunch == null || isFirstLaunch == true) {
      // First time launch or no preference saved
      // Save the flag to false so that splash screen won't show next time
      prefs.setBool('isFirstLaunch', false);

      // Display splash screen for 3 seconds and then navigate
      Future.delayed(Duration(seconds: 3), () {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      });
    } else {
      // If it's not the first launch, skip splash screen and navigate to the Home Page immediately
      Future.delayed(Duration(milliseconds: 500), () {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
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
    return Scaffold(
      backgroundColor: Colors.black,  // Background color for contrast
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show animated logo only on the first launch
            if (_isFirstLaunch)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/images/nbalogo.jpg',  // Path to your splash screen logo
                  width: 150,  // Adjust the size as needed
                  height: 150,
                ),
              ),
            SizedBox(height: 20), // Space between image and text

            // Animated Text (Fading effect) only on the first launch
            if (_isFirstLaunch)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'NBA Highlights',
                  style: TextStyle(
                    fontSize: 30,  // Font size for the app name
                    fontWeight: FontWeight.bold,  // Bold text
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
