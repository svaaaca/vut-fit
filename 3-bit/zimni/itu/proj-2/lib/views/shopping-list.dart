//
// @file shopping_list.dart
// @author Rostislav Červenka (xcerve30@stud.fit.vutbr.cz)
// @brief Implementation of the shopping list screen of the application.
// @date 2023-12-17
//

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<String> itemNames = [];
  List<String> itemKeys = [];
  List<int> itemPressed = [];
  bool isLoading = true;
  bool listLoaded = false;

  //Funkce pro vyprázdnění celého nákupního seznamu
  void clearList() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Opravdu chcete vyprázdnit nákupní seznam?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('NE'),
            ),
            TextButton(
              onPressed: () {
                final ref = FirebaseDatabase.instance.ref();
                ref.child('shoppingList').remove();
                setState(() {
                  itemNames.clear();
                  itemKeys.clear();
                  itemPressed.clear();
                });
                Navigator.pop(context);
              },
              child: const Text('ANO'),
            ),
          ],
        );
      },
    );
  }

  final TextEditingController _recipeNameController = TextEditingController();

  //Funkce pro přidání položky do nákupního seznamu
  void addToList() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Přidat položku do nákupního seznamu'),
          content: TextField(
            controller: _recipeNameController,
            decoration: const InputDecoration(
              labelText: 'Zadejte název položky',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Zrušit'),
            ),
            TextButton(
              onPressed: () {
                String recipeName = _recipeNameController.text;
                final ref = FirebaseDatabase.instance.ref();
                final newRecipeRef = ref.child('shoppingList').push();
                final newRecipe = {'name': recipeName, 'amount': 0, 'unit': ''};
                newRecipeRef.set(newRecipe).then((_) {
                  loadShoppingList();
                  Navigator.pop(context);
                });
              },
              child: const Text('Přidat'),
            ),
          ],
        );
      },
    );
  }

  //Funkce pro označení položky jako koupenou
  void changeTappedItem(int index) {
    setState(() {
      itemPressed[index] = itemPressed[index] == 1 ? 0 : 1;
    });
  }

  //Funkce pro smazání položky z nákupního seznamu
  void deleteItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Opravdu chcete smazat položku "${itemNames[index]}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('NE'),
            ),
            TextButton(
              onPressed: () {
                final ref = FirebaseDatabase.instance.ref();
                ref.child('shoppingList/${itemKeys[index]}').remove();
                loadShoppingList();
                Navigator.pop(context);
              },
              child: const Text('ANO'),
            ),
          ],
        );
      },
    );
  }

  //Funkce pro načtení nákupního seznamu z databáze
  Future<void>loadShoppingList() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('shoppingList').get();
    String recName = '';
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        itemNames.clear();
        itemKeys.clear();
        itemPressed.clear();
      });
      data.forEach((key, value) {
        value['amount'] != 0 ? 
        recName = "${value['name']}" : 
        recName = "${value['name']}";
        setState(() {
          itemNames.add(recName);
          itemKeys.add(key);
          itemPressed.add(0);
        });
      });
    }
  }

  Future<void> loadShoppingListOnce() async {
    if (!listLoaded) {
      await loadShoppingList();
      setState(() {
        listLoaded = true;
      });
    }
  }

  //Funkce pro načtení nákupního seznamu při spuštění aplikace
  Future<void>loadData() async {
    await loadShoppingListOnce();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nákupní seznam",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: itemNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          itemPressed[index] == 1
                              ? Icons.check_circle
                              : Icons.check_circle_outlined,
                          color: itemPressed[index] == 1 ? Colors.green : Colors.black,
                        ),
                        title: Text(itemNames[index]),
                        onTap: () {
                          changeTappedItem(index);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteItem(index);
                          },
                        )
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0), // Adjust the left padding as needed
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          addToList();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.add),
                            Text('Přidat'),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0), // Adjust the right padding as needed
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          clearList();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.delete),
                            Text('Vyprázdnit'),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }
}