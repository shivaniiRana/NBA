import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'category_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NBA Categories',
      theme: ThemeData(
        primaryColor: Color(0xFF17408b),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: Color(0xFF17408b), // Set AppBar background color
          titleTextStyle: TextStyle(
            color: Colors.white,  // Set title color to white
            fontSize: 20,          // Font size for the title
            fontWeight: FontWeight.bold, // Optional: set font weight
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final DatabaseEvent event = await _database.child('categories').once();
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic> categoriesMap = Map<dynamic, dynamic>.from(snapshot.value as Map);
        List<Map<String, dynamic>> fetchedCategories = [];

        categoriesMap.forEach((key, value) {
          fetchedCategories.add(Map<String, dynamic>.from(value as Map));
        });

        setState(() {
          categories = fetchedCategories;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching categories: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NBA Categories',
          style: TextStyle(color: Colors.white),  // Explicitly setting title color to white
        ),
        backgroundColor: Colors.black,  // Background color for the AppBar
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : categories.isEmpty
          ? Center(child: Text('No categories available.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6,  // Reduced spacing
            mainAxisSpacing: 6,   // Reduced spacing
            childAspectRatio: 0.90,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryScreen(category: category),
                ),
              ),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Column(
                    children: [
                      category['thumbnailUrl'] != null
                          ? CachedNetworkImage(
                        imageUrl: category['thumbnailUrl'],
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                          : Container(
                        height: 100,
                        color: Colors.grey,
                        child: Center(child: Icon(Icons.image, color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          category['name'] ?? 'Unknown Category',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}