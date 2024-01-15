//
// @file recipe_favorite.dart
// @author Rostislav Červenka (xcerve30@stud.fit.vutbr.cz)
// @brief Implementation of the favorites screen of the application.
// @date 2023-12-17
//

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io';
import 'dart:async';
import 'recipe_detail.dart';


class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> recipeNames = [];
  List<String> recipeKeys = [];
  List<String> recipeImages = [];
  List<String> recipeTypes = [];
  List<String> recipeTimes = [];
  List<double> recipeRatings = [];
  List<int> recipeimageNet = [];
  bool isLoading = true;
  bool recipesLoaded = false;

  //načtení oblíbených receptů z databáze
  Future<void> loadRecipes() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('recipes').get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      data.forEach((key, value) {
        if (value['favorite'] == 1) {
          String recName;
          String recImage;
          String recType;
          String recTime;
          double recRating;
          int recImageNet;
          value['name'] != null ? recName = "${value['name']}" : recName = "Název receptu";
          value['dishType'] != null ? recType = "${value['dishType']}" : recType = "Druh pokrmu";
          value['time'] != null ? recTime = "${value['time']} min" : recTime = "x min";
          value['rating'] != null ? recRating = value['rating'].toDouble() : recRating = 0;
          value['image'] != null ? recImage = "${value['image']}" : recImage = "";
          value['imageNet'] != null ? recImageNet = 1 : recImageNet = 0;
          setState(() {
            recipeNames.add(recName);
            recipeKeys.add(key);
            recipeTypes.add(recType);
            recipeTimes.add(recTime);
            recipeRatings.add(recRating);
            recipeImages.add(recImage);
            recipeimageNet.add(recImageNet);
          });
        }
      });
    }
  }

  Future<void> loadRecipesOnce() async {
    if (!recipesLoaded) {
      await loadRecipes();
      setState(() {
        recipesLoaded = true;
      });
    }
  }

  //inicializace oblíbených receptů při spuštění aplikace
  Future<void> loadData() async {
    await loadRecipesOnce();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          'Oblíbené recepty',
          style: TextStyle(color: Colors.white),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 2,
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
            return ListView.builder(
              itemCount: recipeNames.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(
                          recipeKey: recipeKeys[index],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 100,
                        width: 300,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: recipeimageNet[index] == 1
                            ? Image.network(recipeImages[index], fit: BoxFit.cover, width: double.infinity)
                            : recipeImages[index] != ''
                              ? Image.file(File(recipeImages[index]), fit: BoxFit.cover, width: double.infinity)
                              : Image.asset('assets/images/placeholder.png', fit: BoxFit.cover, width: double.infinity),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 300,
                        color: Colors.black,
                        child: Text(recipeNames[index], style: const TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Container(
                          width: 300,
                          height: 30,
                          color: Colors.black,
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    recipeTimes[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    recipeTypes[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: RatingBar.builder(
                                    ignoreGestures: true,
                                    initialRating: recipeRatings[index],
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 3,
                                    itemSize: 20,
                                    unratedColor: Colors.white.withOpacity(0.4),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.white,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}