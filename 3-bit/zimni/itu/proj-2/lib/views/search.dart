//
// @file search.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Implementation of a search screen of the application.
// @date 2023-12-17
//

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'recipe_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DatabaseReference reference = FirebaseDatabase.instance.ref().child('recipes');
  final TextEditingController controller = TextEditingController();
  String selectedItem = 'Vyberte vyhledávací kritérium';
  List<String> items = ['Vyberte vyhledávací kritérium', 'Hledat podle druhu pokrmu', 'Hledat podle doby přípravy', 'Hledat podle ingrediencí'];
  String selectedItemSecondDropdown = '';
  List<String> itemsSecondDropdown = [''];

  void updateSecondDropdownItems(String selectedItemFirstDropdown) {
    if (selectedItemFirstDropdown == 'Hledat podle druhu pokrmu') {
      itemsSecondDropdown = ['snídaně', 'polévka', 'hlavní jídlo', 'dezert', 'večeře', 'nápoj', 'jiné'];
    } else if (selectedItemFirstDropdown == 'Hledat podle doby přípravy') {
      itemsSecondDropdown = ['30 min. a méně', '31 až 90 min.', '91 min. a více'];
    } else if (selectedItemFirstDropdown == 'Hledat podle ingrediencí') {
      itemsSecondDropdown = ['cukr', 'mouka', 'vejce', 'mléko', 'máslo', 'sůl', 'kakao', 'vanilkový extrakt', 'pudinkový prášek', 'oříšky', 'med', 'olivový olej', 'česnek', 'cibule', 'rýže', 'kuřecí maso', 'hovězí maso', 'sýr', 'bazalka', 'avokádo', 'koriandr', 'paprika', 'šunka', 'rajčatová omáčka', 'víno', 'těstoviny', 'ryby', 'sojová omáčka'];
    } else {
      itemsSecondDropdown = [''];
    }
    setState(() {
      selectedItemSecondDropdown = itemsSecondDropdown[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        // ignore: prefer_const_constructors
        title: Text(
          'Vyhledat recept',
          style: const TextStyle(color: Colors.white),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.black12,
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                value: selectedItem,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedItem = newValue!;
                    updateSecondDropdownItems(selectedItem);
                  });
                },
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.black12,
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                value: selectedItemSecondDropdown,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedItemSecondDropdown = newValue!;
                  });
                },
                items: itemsSecondDropdown.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder(
                stream: reference.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Nepodařilo se načíst recepty.'),
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
                    final searchText = controller.text.toLowerCase();
                    final dishType = entry.value['dishType']?.toString().toLowerCase() ?? '';
                    final time = int.parse(entry.value['time']?.toString() ?? '0');
                    final List<String> ingredientNames = [];
                    final ingredients = entry.value['ingredients'];
                    if (ingredients != null && ingredients is List) {
                      for (final ingredientEntry in ingredients) {
                        final ingredientName = ingredientEntry['name']?.toString() ?? '';
                        ingredientNames.add(ingredientName.toLowerCase());
                      }
                    }
                    if (selectedItem == 'Hledat podle druhu pokrmu') {
                      return name.contains(searchText) && dishType == selectedItemSecondDropdown.toLowerCase();
                    } else if (selectedItem == 'Hledat podle doby přípravy') {
                      if (selectedItemSecondDropdown == '30 min. a méně') {
                        return name.contains(searchText) && time > 0 && time <= 30;
                      } else if (selectedItemSecondDropdown == '31 až 90 min.') {
                        return name.contains(searchText) && time > 30 && time <= 90;
                      } else if (selectedItemSecondDropdown == '91 min. a více') {
                        return name.contains(searchText) && time > 90;
                      }
                    }
                    else if (selectedItem == 'Hledat podle ingrediencí') {
                      final bool hasMatchingIngredient = ingredientNames.any((ingredientName) => ingredientName.contains(selectedItemSecondDropdown.toLowerCase()));
                      return name.contains(searchText) && hasMatchingIngredient;
                    }
                    return name.contains(searchText);
                  }).toList();
                  if (filteredRecipes.isEmpty) {
                    return const Center(
                      child: Text(
                        'Hledaný recept nebyl nalezen.',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      filteredRecipes.sort((a, b) =>
                          (a.value['name'] as String).compareTo(b.value['name'] as String));
                      final recipeEntry = filteredRecipes[index];
                      final recipeData = recipeEntry.value;
                      return GestureDetector(
                        onTap: () {
                          // Navigate to RecipeDetailScreen when the card is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(recipeKey: recipeEntry.key),
                            ),
                          );
                        },
                        child: Dismissible(
                          key: Key(recipeData['id'].toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16.0),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          confirmDismiss: (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Odstranit recept'),
                                  content: Text('Chcete opravdu odstranit recept "${recipeData['name']}"?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('Zrušit'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        reference.child(recipeEntry.key).remove();
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text('Odstranit'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (direction) {},
                          child: Card(
                            color: Colors.white70,
                            elevation: 4.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    recipeData['name'] ?? 'název receptu neuveden',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    recipeData['dishType'] ?? 'druh pokrmu neuveden',
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      recipeData['favorite'] == 1 ? Icons.favorite : Icons.favorite_border,
                                      color: Colors.black87,
                                      size: 20.0,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          String dialogContent;
                                          String dialogButton;
                                          if (recipeData['favorite'] == 1) {
                                            dialogContent =
                                                'Chcete odebrat recept "${recipeData['name']}" z oblíbených?';
                                            dialogButton = 'Odebrat';
                                          } else {
                                            dialogContent = 'Chcete přidat recept "${recipeData['name']}" do oblíbených?';
                                            dialogButton = 'Přidat';
                                          }
                                          return AlertDialog(
                                            title: const Text('Oblíbené recepty'),
                                            content: Text(dialogContent),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Zrušit'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  reference.child(recipeEntry.key).update({
                                                    'favorite': recipeData['favorite'] == 1 ? 0 : 1
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(dialogButton),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
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