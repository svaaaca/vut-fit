//
// @file recipe_detail.dart
// @author Rostislav Červenka (xcerve30@stud.fit.vutbr.cz)
// @brief Implementation of the recipe detail screen of the application.
// @date 2023-12-17
//

// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'recipe_create.dart';


class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeKey});
  final String recipeKey;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final database = FirebaseDatabase.instance.ref();
  String recipeName = '';
  String recipeType = '';
  String recipeTime = '';
  double recipeRating = 0;
  int recipeFavorite = 0;
  List<String> recipeIngredientsName = [];
  List<int> recipeIngredientsAmount = [];
  List<String> recipeIngredientsUnit = [];
  List<int> recipeIngredientsPressed = [];
  List<String> recipeStepsText = [];
  List<int> recipeStepsTime = [];
  List<int> recipeStepsPressed = [];
  String image = '';
  Timer? _timer;
  bool isTimerRunning = false;
  int countdowntimer = 0;
  int portions = 1;
  int imageNet = 0;

  //Funkce pro formátování času
  String formatTimer(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    
    return '$hoursStr:$minutesStr:$secondsStr';
  }

  //Funkce pro spuštění časovače
  void startTimer(int duration, int index) {
    _timer?.cancel(); // Cancel any existing timer
    setState(() {
      countdowntimer = duration*60;
      isTimerRunning = true;
      recipeStepsPressed[index] = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdowntimer--;
        if (countdowntimer <= 0) {
          timer.cancel();
          isTimerRunning = false;
          recipeStepsPressed[index] = 1;
          // Timer completed, show alert
          SystemSound.play(SystemSoundType.alert);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Časovač dokončen'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }

  //Funkce pro zastavení časovače
  void endTimer() {
    _timer?.cancel(); // Cancel any existing timer
    setState(() {
      isTimerRunning = false;
    });
  }

  //Funkce pro aktualizaci hodnocení receptu
  void updateRating(double rating) {
    database.child('recipes/${widget.recipeKey}/rating').set(rating);
    setState(() {
      recipeRating = rating;
    });
  }

  //Funkce pro aktualizaci oblíbenosti receptu
  void updateFavorite() {
    if (recipeFavorite == 1) {
      database.child('recipes/${widget.recipeKey}/favorite').set(0);
      setState(() {
        recipeFavorite = 0;
      });
    } else {
      database.child('recipes/${widget.recipeKey}/favorite').set(1);
      setState(() {
        recipeFavorite = 1;
      });
    }
  }

  //Funkce pro snížení počtu porcí
  void decreasePortions() {
    if (portions > 1) {
      setState(() {
        portions--;
      });
    }
  }

  //Funkce pro zvýšení počtu porcí
  void increasePortions() {
    setState(() {
      portions++;
    });
  }

  //Funkce pro označení ingredience jako použitou
  void chageTappedIngedient(int index) {
    if (recipeIngredientsPressed[index] == 1) {
      setState(() {
        recipeIngredientsPressed[index] = 0;
      });
    } else {
      setState(() {
        recipeIngredientsPressed[index] = 1;
      });
    }
  }

  //Funkce pro označení kroku jako dokončený
  void changeTappedStep(int index) {
    if (recipeStepsPressed[index] == 1) {
      setState(() {
        recipeStepsPressed[index] = 0;
      });
    } else {
      setState(() {
        recipeStepsPressed[index] = 1;
      });
    }
  }

  //Funkce pro přidání ingredience do nákupního seznamu
  void addToBag(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Přidat do nákupního seznamu'),
          content: Text('Přidat ${recipeIngredientsAmount[index] * portions} ${recipeIngredientsUnit[index]} ${recipeIngredientsName[index]} do nákupního seznamu?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Zrušit'),
            ),
            ElevatedButton(
              onPressed: () {
                String name = '${recipeIngredientsAmount[index]} ${recipeIngredientsUnit[index] * portions} ${recipeIngredientsName[index]}';
                final ref = database.child('shoppingList').push();
                final newItem = {
                  'name': name,
                };
                ref.set(newItem);
                Navigator.pop(context);
              },
              child: const Text('Přidat'),
            ),
          ],
        );
      },
    );
  }

  //Funkce pro načtení receptu z databáze
  Future<void> loadRecipe() async {
    final snapshot = await database.child('recipes/${widget.recipeKey}').get();
    if (snapshot.exists) {
      final recipe = snapshot.value as Map;
      if (mounted) {
        if (recipe['dishType'] != null) {
          setState(() {
            recipeType = recipe['dishType'];
          });
        }
        if (recipe['time'] != null) {
          setState(() {
            recipeTime = '${recipe['time']} min';
          });
        }
        if (recipe['rating'] != null) {
          setState(() {
            recipeRating = recipe['rating'].toDouble();
          });
        }
        if (recipe['favorite'] != null) {
          setState(() {
            recipeFavorite = recipe['favorite'];
          });
        }
        if (recipe['ingredients'] != null) {
          setState(() {
            recipeIngredientsName = recipe['ingredients'].map<String>((ingredient) => ingredient['name'] as String).toList();
            recipeIngredientsAmount = recipe['ingredients'].map<int>((ingredient) => ingredient['amount'] as int).toList();
            recipeIngredientsUnit = recipe['ingredients'].map<String>((ingredient) => ingredient['unit'] as String).toList();
            recipeIngredientsPressed = List<int>.filled(recipeIngredientsName.length, 0);
          });
        }
        if (recipe['steps'] != null) {
          setState(() {
            recipeStepsText = recipe['steps'].map<String>((step) => step['text'] as String).toList();
            recipeStepsTime = recipe['steps'].map<int>((step) => step['time'] as int).toList();
            recipeStepsPressed = List<int>.filled(recipeStepsText.length, 0);
          });
        }
        if (recipe['image'] != null) {
          setState(() {
            image = recipe['image'];
          });
        }
        if (recipe['imageNet'] != null) {
          setState(() {
            imageNet = 1;
          });
        }
        if (recipe['name'] != null) {
          setState(() {
            recipeName = recipe['name'];
          });
        }
      }
    }
  }

  //inicializace receptu při spuštění aplikace
  @override
  void initState() {
    super.initState();
    loadRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipeName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateScreen(title: 'Upravit recept', recipeKey: widget.recipeKey),
                ),
              );
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  child: imageNet == 1
                      ? Image.network(image, fit: BoxFit.cover, width: double.infinity)
                      : image != ''
                        ? Image.file(File(image), fit: BoxFit.cover, width: double.infinity)
                        : Image.asset('assets/images/placeholder.png', fit: BoxFit.cover, width: double.infinity),
                ),
                Positioned(
                  top: 50, // Adjust the top position as needed
                  child: isTimerRunning
                      ? Container(
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8), // Add some spacing
                            const Icon(Icons.access_time, color: Colors.white), // White Clock icon
                            const SizedBox(width: 8),
                            Text(
                                formatTimer(countdowntimer),
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            IconButton(
                                alignment: Alignment.center,
                                icon: const Icon(Icons.clear, color: Colors.white),
                                onPressed: () {
                                  endTimer();
                                },
                            ),
                          ],
                        )
                      )
                      : Container(),
                ),
              ],
            ),
            Container(
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        recipeTime,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        recipeType,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: RatingBar.builder(
                        initialRating: recipeRating,
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
                        onRatingUpdate: (rating) {
                          updateRating(rating);
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.favorite),
                      color: recipeFavorite == 1 ? Colors.white : Colors.white.withOpacity(0.4),
                      onPressed: () {
                        updateFavorite();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Ingredience" , style: TextStyle(fontSize: 20)),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                  onPressed: () {
                    decreasePortions();
                  },
                ),
                Text(
                  portions < 5 ? '$portions porce' :
                  '$portions porcí',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                  onPressed: () {
                    increasePortions();
                  },
                ),
              ],
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: recipeIngredientsName.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(recipeIngredientsPressed[index] == 1 ? Icons.check_circle : Icons.check_circle_outline, 
                          color: recipeIngredientsPressed[index] == 1 ? Colors.green : Colors.black),
                  title: Text('${recipeIngredientsAmount[index] * portions} ${recipeIngredientsUnit[index]} ${recipeIngredientsName[index]}'),
                  textColor: recipeIngredientsPressed[index] == 1 ? Colors.green : Colors.black,
                  onTap: () {
                    chageTappedIngedient(index);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.shopping_bag, color: Colors.green),
                    onPressed: () {
                      addToBag(index);
                    },
                  )
                );
              },
            ),
            const Text("Postup", style: TextStyle(fontSize: 20)),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: recipeStepsText.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    recipeStepsPressed[index] == 1
                        ? Icons.check_circle
                        : Icons.check_circle_outlined,
                    color: recipeStepsPressed[index] == 1 ? Colors.green : Colors.black,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipeStepsText[index]),
                      if (recipeStepsTime[index] != 0)
                        GestureDetector(
                          child: Row(
                            children: [
                              const SizedBox(width: 8), // Add some spacing
                              recipeStepsPressed[index] == 1
                                  ? const Icon(Icons.access_time, color: Colors.green)
                                  : const Icon(Icons.access_time, color: Colors.orange), // Clock icon
                              recipeStepsPressed[index] == 1
                                  ? Text('${recipeStepsTime[index]} min',
                                      style: const TextStyle(color: Colors.green))
                                  : Text('${recipeStepsTime[index]} min',
                                      style: const TextStyle(color: Colors.orange)),
                            ],
                          ),
                          onTap: () {
                            startTimer(recipeStepsTime[index], index);
                          },
                        ),
                    ],
                  ),
                  textColor: recipeStepsPressed[index] == 1 ? Colors.green : Colors.black,
                  onTap: () {
                    changeTappedStep(index);
                  },
                );
              },
            ),
          ],
        ),
      ),
    ),
    );
  }
}