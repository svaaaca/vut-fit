import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

// main function, inicialization of database, runs an app
void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCN2KbBpF_QfBICHRldhtMlF3k-UL7mBWA",
          projectId: "kucharka-38edb",
          storageBucket: "kucharka-38edb.appspot.com",
          messagingSenderId: "14660040615",
          databaseURL: "https://kucharka-38edb-default-rtdb.europe-west1.firebasedatabase.app/",
          appId: "1:14660040615:android:6030f6282196f441fbe882",
          ),
  );
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
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      ),
		),
		home: const MyHomePage(title: 'Kuchařka'),
		);
	}
}

class MyHomePage extends StatefulWidget {
	const MyHomePage({super.key, required this.title});

	final String title;

	@override
	State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    CreateScreen(),
    const FavoritesScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
            icon: Icon(Icons.home),
            label: 'Domů',
			backgroundColor: Colors.black,
          ),
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
        ],
      ),
    );
  }
}

// Rosta
class RecipeModel {
  String name;

  RecipeModel(this.name);
}

class RecipeListView extends StatelessWidget {
  final List<String> recipeNames;
  final Function() onShowRecipes;

  const RecipeListView({super.key, required this.recipeNames, required this.onShowRecipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text(
          'Kuchařka',
            style: GoogleFonts.itim(
                color: Colors.white,
                fontSize: 26,
            ),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: onShowRecipes,
            child: const Text('Ukazát moje recepty'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: recipeNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(recipeNames[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeListController {
  List<String> recipeNames = [];

  Future<void> loadRecipes() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('recipes').get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      data.forEach((key, value) {
        String recName = "${value['name']}";
        if (!recipeNames.contains(recName)) {
          recipeNames.add(recName);
        }
      });
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RecipeListController controller = RecipeListController();

  @override
  Widget build(BuildContext context) {
    
    return RecipeListView(
      recipeNames: controller.recipeNames,
      onShowRecipes: () async {
        await controller.loadRecipes();
        setState(() {});
      },
    );
  }
}

//David
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DatabaseReference _recipesReference = FirebaseDatabase.instance.ref().child('recipes');
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            TextField(
              controller: _textEditingController,
              onChanged: (text) {
                setState(() {});
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Zadejte název receptu',
                hintStyle: const TextStyle(
                  color: Colors.black45,
                ),
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder(
                stream: _recipesReference.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Nepodařilo se načíst data.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  }

                  final DataSnapshot data = snapshot.data!.snapshot;
                  final Map<dynamic, dynamic> recipesMap = data.value as Map<dynamic, dynamic>;

                  final List<MapEntry> filteredRecipes = recipesMap.entries.where((entry) {
                    final name = entry.value['name'].toString().toLowerCase();
                    final searchText = _textEditingController.text.toLowerCase();
                    return name.contains(searchText);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipeEntry = filteredRecipes[index];
                      final recipeData = recipeEntry.value;

                      return ListTile(
                        title: Text(
                          recipeData['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                        subtitle: const Text(
                          'druh pokrmu',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        trailing: const Text(
                          'hodnocení ★',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.indigo,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Maja
class CreateScreen extends StatelessWidget {
  CreateScreen({Key? key}) : super(key: key);

  final TextEditingController _recipeNameController = TextEditingController();

  void sendDataToFirebase(BuildContext context, String recipeName) {
    final reference = FirebaseDatabase.instance.ref().child('recipes');
    final newRecipeRef = reference.push();
    final newRecipe = {'name': recipeName};

    newRecipeRef.set(newRecipe).then((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('recept "$recipeName" byl úspěšně uložen'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      print('Chyba při ukládání receptu: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text(
          'Vytvořit recept',
            style: GoogleFonts.itim(
                color: Colors.white,
                fontSize: 26,
            ),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 2,
      ),
      
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Container(
                width: 300,
                child: TextFormField(
                  controller: _recipeNameController,
                  decoration: InputDecoration(
                    labelText: 'Zadejte název receptu',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  String recipeName = _recipeNameController.text;
                  sendDataToFirebase(context, recipeName);
                },
                child: Text('Uložit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      title: Text(
        'Oblíbené recepty',
        style: GoogleFonts.itim(
              color: Colors.white,
              fontSize: 26,
            ),
      ),
      actions: const [],
      centerTitle: true,
      elevation: 2,
    ),
        );
  }
}
