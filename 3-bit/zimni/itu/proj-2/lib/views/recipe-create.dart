// ignore_for_file: use_build_context_synchronously

/* --Tvorba receptu--
   autor: Marie Pařilová
   login: xparil05
   datum: 17.12.2023
 */

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:cookbook/main.dart';
import 'dart:io';
import 'recipe_detail.dart';

// class for ingredients
class Ingredient {
  String name;
  int amount;
  String unit;

  Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  Ingredient copyWith({
    String? name,
    int? amount,
    String? unit,
  }) {
    return Ingredient(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
    );
  }
}

// class for steps
class Step {
  String text;
  int time; // Čas v minutách

  Step({
    required this.text,
    required this.time,
  });
}

// class for recipes
class Recipe {
  String name;
  String dishType;
  int rating;
  int time;
  String image;
  int favorite;
  List<Ingredient> ingredients;
  List<Map<String, dynamic>> steps;

  Recipe({
    required this.name,
    required this.dishType,
    required this.rating,
    required this.time,
    required this.image,
    required this.favorite,
    required this.ingredients,
    required this.steps,
  });
}

// function for sending data to database
Future<void> sendDataToFirebase(
  BuildContext context,
  String imagePath,
  String recipeName,
  int preparationTime,
  String dishType,
  List<Ingredient> selectedIngredients,
  List<Step> steps,
  int favorite,
  String? recipeKey,
) async {
  try {
    final reference = FirebaseDatabase.instance.ref().child('recipes');
    final newRecipeRef = reference.push();
    final newRecipe = {
      'name': recipeName,
      'time': preparationTime,
      'dishType': dishType,
      'image': imagePath.isNotEmpty ? imagePath : null, // Předává null, pokud je imagePath prázdný
      'ingredients': selectedIngredients.map((ingredient) => {
        'name': ingredient.name,
        'amount': ingredient.amount,
        'unit': ingredient.unit,
      }).toList(),
      'steps': steps.map((step) => { 
        'text': step.text, 'time': step.time
      }).toList(),
      'favorite': favorite,
    };

    if (recipeKey != null) {
      // If recipeKey is provided, update the existing recipe
      await reference.child(recipeKey).update(newRecipe);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Recept "$recipeName" byl úspěšně upraven'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailScreen(
                        recipeKey: recipeKey,
                      ),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Otherwise create a new recipe
      await newRecipeRef.set(newRecipe);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Recept "$recipeName" byl úspěšně uložen'),
            actions: [
              TextButton(
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
  } catch (error) {
    print('Chyba při ukládání receptu: $error');
  }
}



List<String> dishTypes = ['Snídaně', 'Hlavní jídlo', 'Polévka', 'Večeře', "Dezert", "Nápoj", "Jiné"];
List<String> dostupneIngredience = [
  'Cukr',
  'Mouka',
  'Vejce',
  'Mléko',
  'Máslo',
  'Sůl',
  'Kakao',
  'Vanilkový extrakt',
  'Pudinkový prášek',
  'Oříšky',
  'Med',
  'Olivový olej',
  'Česnek',
  'Cibule',
  'Rýže',
  'Kuřecí maso',
  'Hovězí maso',
  'Sýr',
  'Bazalka',
  'Avokádo',
  'Koriandr',
  'Paprika',
  'Šunka',
  'Rajčatová omáčka',
  'Víno',
  'Těstoviny',
  'Ryby',
  'Sojová omáčka',
];

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

List<Ingredient> vybraneIngredience = [];
List<Step> steps = [];

class CreateScreen extends StatefulWidget {
  CreateScreen({super.key, this.title, this.recipeKey});
  final String? title;
  final String? recipeKey;

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  String selectedDishType = '';
  Ingredient? vybranaIngredience;
  XFile? pickedFile;
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _preparationTimeController = TextEditingController();
  Ingredient? novaHodnota;
  String prePickedImage = '';
  int imageNet = 0;

  bool isFormValid() {
    return _recipeNameController.text.isNotEmpty &&
        _preparationTimeController.text.isNotEmpty &&
        selectedDishType.isNotEmpty
        &&
        vybraneIngredience.isNotEmpty &&
        steps.isNotEmpty;
    }
  bool isImageAdded = false;

  void loadRecipeData(String recipeKey) async {
    final recipeSnapshot = await FirebaseDatabase.instance.ref('recipes/$recipeKey').get();
    final recipeData = recipeSnapshot.value as Map;
    setState(() {
      // Set default values based on the loaded recipe data
      _recipeNameController.text = recipeData['name'] ?? '';
      _preparationTimeController.text = recipeData['time']?.toString() ?? '';
      selectedDishType = recipeData['dishType'] ?? '';
      vybraneIngredience = (recipeData['ingredients'] as List<dynamic>?)
          ?.map((ingredientData) {
        return Ingredient(
          name: ingredientData['name'] ?? '',
          unit: ingredientData['unit'] ?? '',
          amount: ingredientData['amount'] ?? 0,
        );
      }).toList() ?? [];
      steps = (recipeData['steps'] as List<dynamic>?)
          ?.map((stepData) {
        return Step(
          text: stepData['text'] ?? '',
          time: stepData['time'] ?? 0,
        );
      }).toList() ?? [];
      prePickedImage = recipeData['image'] ?? '';
      recipeData['imageNet'] == Null ? imageNet = 1 : imageNet = 0;
    });
  }

  void clearData() {
    _recipeNameController.clear();
    _preparationTimeController.clear();
    selectedDishType = '';
    vybraneIngredience = [];
    steps = [];
    prePickedImage = '';
  }

  @override
  void initState() {
    super.initState();
    clearData();
    if (widget.recipeKey != null) {
      // If recipeKey is provided, load the recipe data
      loadRecipeData(widget.recipeKey!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text(
            widget.title ?? 'Vytvořit recept',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          widget.recipeKey != null
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Opravdu chcete smazat tento recept?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Zrušit'),
                            ),
                            TextButton(
                              onPressed: () async {
                                final reference = FirebaseDatabase.instance.ref().child('recipes');
                                await reference.child(widget.recipeKey!).remove();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyHomePage(title: "Oblíbené recepty", index: 2),
                                  ),
                                );
                              },
                              child: const Text('Smazat'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete),
                )
              : Container(),
        ],
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _recipeNameController,
              decoration: const InputDecoration(
                labelText: 'Zadejte název receptu',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _preparationTimeController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Zadejte dobu přípravy (minuty)',
              ),
            ),
            const SizedBox(height: 16),
           DropdownButton<String?>(
            hint: const Text('druh pokrmu'),
            onChanged: (String? newValue) {
              setState(() {
                selectedDishType = newValue ?? ''; // Pokud je newValue null, použije se prázdný řetězec
              });
            },
            value: selectedDishType.isEmpty ? null : selectedDishType, // Pokud je selectedDishType prázdný, použije se null
            items: [
              ...dishTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ],
          ),
          

          DropdownButton<Ingredient>(
            hint: const Text('vyberte ingredienci'),
            onChanged: (Ingredient? novaHodnota) {
              setState(() {
                vybranaIngredience = novaHodnota;
                _addIngredientDialog(vybranaIngredience);
              });
            },
            items: dostupneIngredience.map<DropdownMenuItem<Ingredient>>((String hodnota) {
              return DropdownMenuItem<Ingredient>(
                value: Ingredient(name: hodnota, amount: 0, unit: 'ks'),
                child: Text(hodnota),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Vybrané ingredience:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: vybraneIngredience.length,
                  itemBuilder: (BuildContext context, int index) {
                    Ingredient ingredient = vybraneIngredience[index];
                    return Card(
                      elevation: 2.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ingredient.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _editIngredient(index);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteIngredient(index);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text('${ingredient.amount} ${ingredient.unit}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),


            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Kroky postupu:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _addStep();
                  },
                  child: const Text('Přidat krok postupu'),
                ),
                const SizedBox(height: 8.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: steps.length,
                  itemBuilder: (BuildContext context, int index) {
                    int stepNumber = index + 1;
                    Step step = steps[index];
                    return Card(
                      elevation: 2.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '$stepNumber. ${step.text}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _editStep(index);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteStep(index);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text('Čas: ${step.time} (min)'),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),




            const SizedBox(height: 16),
            const Text(
              'Fotka:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                pickedFile = await _pickImage(ImageSource.gallery);
                print('Cesta k souboru: ${pickedFile!.path}');
                setState(() {
                  isImageAdded = true;
                });
              },
              child: const Text('Vybrat z galerie'),
            ),
            const SizedBox(height: 16),
            pickedFile == null && prePickedImage != '' && imageNet == 0
                ? Column(
                    children: [
                      Image.file(
                        File(prePickedImage),
                        fit: BoxFit.cover, width: double.infinity
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                : Container(),
            pickedFile == null && prePickedImage != '' && imageNet == 1
                ? Column(
                    children: [
                      Image.network(
                        prePickedImage,
                        fit: BoxFit.cover, width: double.infinity
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                : Container(),
            isImageAdded
                ? Column(
                    children: [
                      pickedFile != null ?
                      Image.file(
                        File(pickedFile!.path),
                        fit: BoxFit.cover, width: double.infinity
                      ) : Container(),
                      const SizedBox(height: 16),
                    ],
                  )
                : Container(),


            ElevatedButton(
              onPressed: () async {
                if (isFormValid()) {
                  String recipeName = _recipeNameController.text;
                  int preparationTime = int.tryParse(_preparationTimeController.text) ?? 0;
                  String imagePath = pickedFile?.path ?? (prePickedImage != '' ? prePickedImage : ''); // Pokud pickedFile je null, použije se prázdný řetězec
                  sendDataToFirebase(
                    context,
                    imagePath,
                    recipeName,
                    preparationTime,
                    selectedDishType,
                    vybraneIngredience,
                    steps,
                    1,
                    widget.recipeKey,
                  );
                  clearFormFields();
                } else {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: const Text('Vyplňte prosím všechna pole!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  }
                  );
                }
              },
              child: const Text('Uložit'),
            ),

          ],
        ),
      ),
      ),
    );
  }
  
  
  
  Future<XFile?> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    return await picker.pickImage(source: source);
  }

void _addIngredientDialog(Ingredient? ingredience) {
  TextEditingController amountController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Zadejte množství a jednotku pro - ${ingredience?.name}'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Množství'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Množství je povinné pole.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: unitController,
                decoration: const InputDecoration(labelText: 'Jednotka'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jednotka je povinné pole.';
                  }
                  return null;
                },
              ),
            ],
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
            setState(() {
              if (_formKey.currentState?.validate() ?? false) {
                int amount = int.parse(amountController.text);
                String unit = unitController.text;
                if (vybranaIngredience != null) {
                  Ingredient ingredient = vybranaIngredience!.copyWith(
                    name: ingredience?.name,
                    amount: amount,
                    unit: unit,
                  );
                  vybraneIngredience.add(ingredient);
                }
                Navigator.pop(context);
              }
            });
          },
            child: const Text('Přidat'),
          ),
        ],
      );
    },
  );
}

void _editIngredient(int index) {
  Ingredient currentIngredient = vybraneIngredience[index]; // Získání ingredience podle indexu

  TextEditingController amountController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  amountController.text = currentIngredient.amount.toString();
  unitController.text = currentIngredient.unit;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Upravit ingredienci'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Množství'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Množství je povinné pole.';
                  }
                  return null;
                },
              ),
            TextFormField(
                controller: unitController,
                decoration: const InputDecoration(labelText: 'Jednotka'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jednotka je povinné pole.';
                  }
                  return null;
                },
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Zrušit dialog
            },
            child: const Text('Zrušit'),
          ),
          TextButton(
            onPressed: () {
              // Upravit ingredienci na zadaném indexu
              int newAmount = int.tryParse(amountController.text) ?? 0;
              Ingredient updatedIngredient = Ingredient(
                name: currentIngredient.name,
                amount: newAmount,
                unit: unitController.text,
              );
              setState(() {
                vybraneIngredience[index] = updatedIngredient;
              });
              Navigator.pop(context); // Zavřít dialog
            },
            child: const Text('Upravit'),
          ),
        ],
      );
    },
  );
}

void _deleteIngredient(int index) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Opravdu chcete smazat tuto ingredienci?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Zrušit dialog
            },
            child: const Text('Zrušit'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                vybraneIngredience.removeAt(index); // Smazat ingredienci na zadaném indexu
              });
              Navigator.pop(context); // Zavřít dialog
            },
            child: const Text('Smazat'),
          ),
        ],
      );
    },
  );
}




  void _addStep() {
    TextEditingController textController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Přidat krok postupu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'Text kroku'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Text kroku je povinné pole.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: timeController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Čas (minuty)'),
              ),
            ],
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
                String text = textController.text;
                int time = int.tryParse(timeController.text) ?? 0; // Defaultní hodnota je 0, pokud se nepodaří převést na int
                setState(() {
                  steps.add(Step(text: text, time: time));
                });
                Navigator.pop(context);
              },
              child: const Text('Přidat'),
            ),
          ],
        );
      },
    );
}

void _editStep(int index) {
  Step currentStep = steps[index]; // Získání kroku podle indexu

  TextEditingController textController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  textController.text = currentStep.text;
  timeController.text = currentStep.time.toString();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Upravit krok postupu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Text kroku'),
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Text kroku je povinné pole.';
                  }
                  return null;
                },
            ),
            TextFormField(
              controller: timeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Čas (min)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Zrušit dialog
            },
            child: const Text('Zrušit'),
          ),
          TextButton(
            onPressed: () {
              // Upravit krok na zadaném indexu
              int newTime = int.tryParse(timeController.text) ?? 0;
              Step updatedStep = Step(
                text: textController.text,
                time: newTime,
              );
              setState(() {
                steps[index] = updatedStep;
              });
              Navigator.pop(context); // Zavřít dialog
            },
            child: const Text('Upravit'),
          ),
        ],
      );
    },
  );
}

void _deleteStep(int index) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Opravdu chcete smazat tento krok?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Zrušit dialog
            },
            child: const Text('Zrušit'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                steps.removeAt(index); // Smazat krok na zadaném indexu
              });
              Navigator.pop(context); // Zavřít dialog
            },
            child: const Text('Smazat'),
          ),
        ],
      );
    },
  );
}
void clearFormFields() {
  setState(() {
    _recipeNameController.clear();
    _preparationTimeController.clear();
    vybranaIngredience = null;
    vybraneIngredience.clear();
    steps.clear();
    pickedFile = null;
  });
}

  
}
