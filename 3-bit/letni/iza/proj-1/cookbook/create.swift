//
// @file create.swift
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Implementation of the create tab.
// @date 2024-05-26
//

import Firebase
import FirebaseDatabase
import PhotosUI
import SwiftUI

// Model for an ingredient with a unique identifier
struct Ingredient: Identifiable {
    var id = UUID()
    var name: String
    var amount: Int
    var unit: String

    // Function to convert ingredient to a dictionary for Firebase database
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "amount": amount,
            "unit": unit
        ]
    }
}

// Model for a recipe
struct Recipe {
    var name: String
    var dishType: String
    var rating: Int
    var time: Int
    var image: String
    var favorite: Int
    var ingredients: [Ingredient]
    var steps: [Step]

    // Function to convert recipe to a dictionary for Firebase database
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "dishType": dishType,
            "rating": rating,
            "time": time,
            "image": image,
            "favorite": favorite,
            "ingredients": ingredients.map { $0.toDictionary() },
            "steps": steps.map { $0.toDictionary() }
        ]
    }
}

// Model for a step in the recipe with a unique identifier
struct Step: Identifiable {
    var id = UUID()
    var text: String
    var time: Int

    // Function to convert step to a dictionary for Firebase database
    func toDictionary() -> [String: Any] {
        return [
            "text": text,
            "time": time
        ]
    }
}

// Image picker for selecting an image from the photo library
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool

    // Coordinator to handle image picker events
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        // Called when an image is picked
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.showImagePicker = false
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct CreateTab: View {
    @State private var recipeName = ""
    @State private var preparationTime = ""
    @State private var selectedDishType = "dezert"
    @State private var ingredients: [Ingredient] = []
    @State private var steps: [Step] = []
    @State private var selectedIngredient: String = "avokádo"
    @State private var ingredientAmount = ""
    @State private var ingredientUnit = "balení"
    @State private var stepDescription = ""
    @State private var stepTime = ""
    @State private var pickedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var showRemoveImage = false
    @State private var dishTypes = ["dezert", "hlavní jídlo", "jiné", "nápoj", "polévka", "snídaně", "večeře"]
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showConfirmationDialog = false

    var ingredientOptions = ["bílá čokoláda", "brambory", "cibule", "česnek", "hladká mouka", "hořká čokoláda", "houskový knedlík", "hovězí maso", "hranolky", "hrubá mouka", "instantní káva", "kakao", "koření", "krupicový cukr", "kuřecí maso", "mák", "máslo", "med", "mléko", "moučkový cukr", "olivový olej", "paprika", "polohrubá mouka", "ovoce", "pepř", "prášek do pečiva", "prášek do perníku", "pudinkový prášek", "rajčatová omáčka", "rýže", "řepkový olej", "slunečnicový olej", "sůl", "šunka", "sýr", "těstoviny", "tvaroh", "vaječný bílek", "vaječný žloutek", "vanilkový cukr", "vejce", "vepřové maso", "vlašské ořechy", "voda", "zelenina"]
    let unitOptions = ["balení", "g", "kg", "ks", "l", "lžička (čajová)", "lžíce (polévková)", "ml", "šálek (hrnek)"]

    // Function to add an ingredient to the list
    func addIngredient() {
        guard !selectedIngredient.isEmpty, !ingredientAmount.isEmpty, !ingredientUnit.isEmpty else {
            alertMessage = "Vyplňte všechny zbývající informace o ingredienci"
            showAlert = true
            return
        }
        guard let amount = Int(ingredientAmount) else {
            alertMessage = "Množství musí být celé číslo"
            showAlert = true
            return
        }
        let newIngredient = Ingredient(name: selectedIngredient, amount: amount, unit: ingredientUnit)
        ingredients.append(newIngredient)
        selectedIngredient = "avokádo"
        ingredientAmount = ""
        ingredientUnit = "balení"
    }

    // Function to add a step to the list
    func addStep() {
        guard !stepDescription.isEmpty, !stepTime.isEmpty else {
            alertMessage = "Vyplňte všechny zbývající informace o kroku postupu"
            showAlert = true
            return
        }
        guard let time = Int(stepTime) else {
            alertMessage = "Čas musí být celé číslo"
            showAlert = true
            return
        }
        let newStep = Step(text: stepDescription, time: time)
        steps.append(newStep)
        stepDescription = ""
        stepTime = ""
    }

    // Function to save the recipe to Firebase database
    func saveRecipe() {
        guard !recipeName.isEmpty, !preparationTime.isEmpty, !selectedDishType.isEmpty, !ingredients.isEmpty, !steps.isEmpty else {
            alertMessage = "Vyplňte všechny zbývající informace"
            showAlert = true
            return
        }
        guard let time = Int(preparationTime) else {
            alertMessage = "Doba přípravy musí být celé číslo"
            showAlert = true
            return
        }
        var imagePath: String = ""
        if let pickedImage = pickedImage {
            if let data = pickedImage.jpegData(compressionQuality: 0.8) {
                let filename = getDocumentsDirectory().appendingPathComponent("\(UUID().uuidString).jpg")
                try? data.write(to: filename)
                imagePath = filename.path
            }
        }
        let recipe = Recipe(
            name: recipeName,
            dishType: selectedDishType,
            rating: 0,
            time: time,
            image: imagePath,
            favorite: 1,
            ingredients: ingredients,
            steps: steps
        )
        let db = Database.database().reference().child("recipes").childByAutoId()
        db.setValue(recipe.toDictionary()) { error, _ in
            if let error = error {
                self.alertMessage = "Při ukládání došlo k chybě: \(error.localizedDescription)"
                self.showAlert = true
            }
            else {
                self.showConfirmationDialog = true
            }
        }
    }

    // Function to clear the form fields
    func clearForm() {
        recipeName = ""
        preparationTime = ""
        selectedDishType = "dezert"
        ingredients.removeAll()
        steps.removeAll()
        selectedIngredient = "avokádo"
        ingredientAmount = ""
        ingredientUnit = "balení"
        stepDescription = ""
        stepTime = ""
        pickedImage = nil
        showRemoveImage = false
    }

    // Function to return the URL of the documents directory
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    var body: some View {
        NavigationView {
            Form {
                // Section for general recipe information
                Section(header: Text("Informace").font(.headline)) {
                    VStack(spacing: 16) {
                        TextField("Zadejte název receptu", text: $recipeName)
                        HStack(alignment: .center) {
                            TextField("Zadejte dobu přípravy", text: $preparationTime)
                                .keyboardType(.numberPad)
                            Text("min.")
                        }
                        Picker("Vyberte druh pokrmu", selection: $selectedDishType) {
                            ForEach(dishTypes, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .tint(.black)
                    }
                }
                // Section for adding ingredients
                Section(header: Text("Ingredience").font(.headline)) {
                    VStack(spacing: 16) {
                        Picker("Vyberte ingredienci", selection: $selectedIngredient) {
                            ForEach(ingredientOptions, id: \.self) { ingredient in
                                Text(ingredient)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .tint(.black)
                        TextField("Zadejte množství", text: $ingredientAmount)
                            .keyboardType(.numberPad)
                        Picker("Vyberte jednotku", selection: $ingredientUnit) {
                            ForEach(unitOptions, id: \.self) { unit in
                                Text(unit)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .tint(.black)
                    }
                }
                Section {
                    Button(action: {
                        addIngredient()
                    }) {
                        HStack {
                            Spacer()
                            Text("Přidat ingredienci")
                                .tint(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .tint(.gray)
                        }
                    }
                }
                Section {
                    List {
                        ForEach(ingredients) { ingredient in
                            HStack {
                                Text(ingredient.name)
                                Spacer()
                                Text("\(ingredient.amount) \(ingredient.unit)")
                            }
                        }.onDelete { indices in
                            ingredients.remove(atOffsets: indices)
                        }
                    }
                }
                // Section for adding steps
                Section(header: Text("Postup").font(.headline)) {
                    VStack(spacing: 16) {
                        TextField("Zadejte popis kroku postupu", text: $stepDescription, axis: .vertical)
                        HStack {
                            TextField("Zadejte čas kroku postupu", text: $stepTime)
                                .keyboardType(.numberPad)
                            Text("min.")
                        }
                    }
                }
                Section {
                    Button(action: {
                        addStep()
                    }) {
                        HStack {
                            Spacer()
                            Text("Přidat krok postupu")
                                .tint(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .tint(.gray)
                        }
                    }
                }
                Section {
                    List {
                        ForEach(steps) { step in
                            HStack {
                                Text(step.text)
                                Spacer()
                                Text("\(step.time) min.")
                            }
                        }.onDelete { indices in
                            steps.remove(atOffsets: indices)
                        }
                    }
                }
                // Section for adding an image
                Section(header: Text("Obrázek").font(.headline)) {
                    if let pickedImage = pickedImage {
                        Image(uiImage: pickedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 128)
                    }
                    HStack {
                        if pickedImage != nil {
                            Button(action: {
                                pickedImage = nil
                                showImagePicker = false
                                showRemoveImage = false
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Odebrat obrázek")
                                        .tint(.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .tint(.gray)
                                }
                            }
                        }
                        else {
                            Button(action: {
                                showImagePicker = true
                                showRemoveImage = false
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Přidat obrázek")
                                        .tint(.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .tint(.gray)
                                }
                            }
                        }
                    }
                }
                // Section for saving the recipe
                Section {
                    Button(action: {
                        saveRecipe()
                    }) {
                        HStack {
                            Spacer()
                            Text("Uložit")
                                .fontWeight(.bold)
                                .tint(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .tint(.gray)
                        }
                    }
                    .alert(isPresented: $showConfirmationDialog) {
                        Alert(
                            title: Text("Recept uložen"),
                            message: Text("Recept \"\(recipeName)\" byl úspěšně uložen do databáze"),
                            dismissButton: .default(Text("OK"), action: {
                                clearForm()
                            })
                        )
                    }
                }
            }
            .navigationTitle("Vytvořit")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $pickedImage, showImagePicker: $showImagePicker)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Upozornění"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
