//
// @file main.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Implementation of a bottom bar of the application.
// @date 2023-12-17
//

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/recipe_create.dart';
import 'views/recipe_favorite.dart';
import 'views/shopping_list.dart';
import 'views/search.dart';
import 'firebase_options.dart';

// main function, inicialization of database, runs an app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	// This widget is the root of application.
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
		title: 'Kuchařka',
		theme: ThemeData(
			colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
			useMaterial3: true,
		),
		home: const MyHomePage(title: 'Kuchařka'),
		);
	}
}

class MyHomePage extends StatefulWidget {
	const MyHomePage({super.key, required this.title, this.index = 0});

	final String title;
  final int index;

	@override
	State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	int _currentIndex = 0;

  final List<Widget> _pages = [
    const SearchScreen(),
    CreateScreen(),
    const FavoritesScreen(),
    const ShoppingListScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index; // Initialize it in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.white, // Color of the selected item
        unselectedItemColor: Colors.white38, // Color of unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Najít',
			backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Vytvořit',
			backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Moje',
			backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Nákupní seznam',
      backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}