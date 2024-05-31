//
// @file search.swift
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Implementation of the search tab.
// @date 2024-05-26
//

import FirebaseDatabase
import SwiftUI

// Recipe model conforming to Identifiable for use in SwiftUI
struct RecipeModel: Identifiable {
    var id: String
    var name: String
}

struct SearchTab: View {
    // Firebase reference to the recipes database
    let db = Database.database().reference().child("recipes")
    // Options for the first dropdown menu
    let items = ["", "druh pokrmu", "doba přípravy", "ingredience"]

    // State variables to manage UI state
    @State private var selectedItem = ""
    @State private var selectedCriterion = ""
    @State private var searchText = ""
    @State private var itemsCriteria = [String]()
    @State private var recipes = [RecipeModel]()
    @State private var hasRecipes = true
    @State private var showAlert = false
    @State private var recipeToDelete: RecipeModel?

    // Function to load recipes from Firebase
    func loadData() {
        db.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(), let recipesMap = snapshot.value as? [String: [String: Any]] else {
                return
            }
            // Convert Firebase data to Recipe objects
            self.recipes = recipesMap.compactMap { (key, value) in
                guard let name = value["name"] as? String else {
                    return nil
                }
                return RecipeModel(id: key, name: name)
            }
        }
    }

    // Function to update the second dropdown menu items based on the selected criterion
    func updateCriteria() {
        switch selectedItem {
            case "druh pokrmu":
                itemsCriteria = ["dezert", "hlavní jídlo", "jiné", "nápoj", "polévka", "snídaně", "večeře"]
            case "doba přípravy":
                itemsCriteria = ["30 min. a méně", "31 až 90 min.", "91 min. a více"]
            case "ingredience":
                itemsCriteria = ["bílá čokoláda", "brambory", "cibule", "česnek", "hladká mouka", "hořká čokoláda", "houskový knedlík", "hovězí maso", "hranolky", "hrubá mouka", "instantní káva", "kakao", "koření", "krupicový cukr", "kuřecí maso", "mák", "máslo", "med", "mléko", "moučkový cukr", "olivový olej", "paprika", "polohrubá mouka", "ovoce", "pepř", "prášek do pečiva", "prášek do perníku", "pudinkový prášek", "rajčatová omáčka", "rýže", "řepkový olej", "slunečnicový olej", "sůl", "šunka", "sýr", "těstoviny", "tvaroh", "vaječný bílek", "vaječný žloutek", "vanilkový cukr", "vejce", "vepřové maso", "vlašské ořechy", "voda", "zelenina"]
            default:
                itemsCriteria = []
        }
        selectedCriterion = itemsCriteria.first ?? ""
        self.filterRecipes()
    }

    // Function to filter recipes based on search text and selected criteria
    func filterRecipes() {
        db.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(), let recipesMap = snapshot.value as? [String: [String: Any]] else {
                return
            }
            self.recipes = recipesMap.compactMap { (key, value) in
                guard let name = value["name"] as? String else {
                    return nil
                }
                // Check if the recipe matches the search text
                let matchesSearchText = searchText.isEmpty || name.localizedCaseInsensitiveContains(searchText)
                // Check if the recipe matches the selected criteria
                var matchesCriteria = false
                switch selectedItem {
                    case "druh pokrmu":
                        if let type = value["dishType"] as? String {
                            matchesCriteria = type.localizedCaseInsensitiveContains(selectedCriterion)
                        }
                    case "doba přípravy":
                        if let time = value["time"] as? Int {
                            switch selectedCriterion {
                                case "30 min. a méně":
                                    matchesCriteria = time <= 30
                                case "31 až 90 min.":
                                    matchesCriteria = time >= 31 && time <= 90
                                case "91 min. a více":
                                    matchesCriteria = time >= 91
                                default:
                                    matchesCriteria = false
                            }
                        }
                    case "ingredience":
                        if let ingredients = value["ingredients"] as? [[String: Any]] {
                            matchesCriteria = ingredients.contains { ingredient in
                                if let ingredientName = ingredient["name"] as? String {
                                    return ingredientName.localizedCaseInsensitiveContains(selectedCriterion)
                                }
                                return false
                            }
                        }
                    // If no criteria is selected, consider it as matching
                    default:
                        matchesCriteria = true
                }
                // Return the recipe if it matches both the search text and the selected criteria
                if matchesSearchText && matchesCriteria {
                    return RecipeModel(id: key, name: name)
                }
                return nil
            }
            // Sort the recipes alphabetically by name
            self.recipes.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            self.hasRecipes = !self.recipes.isEmpty
        }
    }

    // Function to confirm recipe deletion
    func confirmDelete(at offsets: IndexSet) {
        if let first = offsets.first {
            self.recipeToDelete = recipes[first]
            self.showAlert = true
        }
    }

    // Function to delete a recipe from database
    func deleteConfirmedRecipe() {
        if let recipe = recipeToDelete {
            db.child(recipe.id).removeValue { error, _ in
                if error == nil {
                    if let index = self.recipes.firstIndex(where: { $0.id == recipe.id }) {
                        self.recipes.remove(at: index)
                        self.hasRecipes = !self.recipes.isEmpty
                    }
                }
            }
            self.recipeToDelete = nil
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Recept").font(.headline)) {
                        // Search text field
                        TextField("Zadejte název receptu...", text: $searchText)
                            .onChange(of: searchText) {
                                self.filterRecipes()
                            }
                    }
                    Section(header: Text("Filtrovat").font(.headline)) {
                        // First dropdown menu
                        Picker(selection: $selectedItem, label: Text("Vyberte filtr")) {
                            ForEach(items, id: \.self) { item in
                                Text(item)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(.black)
                        .onChange(of: selectedItem) {
                            self.updateCriteria()
                        }
                        // Second dropdown menu, visible only if a criterion is selected
                        Picker(selection: $selectedCriterion, label: Text("Vyberte možnost")) {
                            ForEach(itemsCriteria, id: \.self) { item in
                                Text(item)
                            }
                        }
                        .opacity(selectedItem == "" ? 0 : 1)
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(.black)
                        .onChange(of: selectedCriterion) {
                            self.filterRecipes()
                        }
                    }
                    Section(header: Text("Výsledek hledání").font(.headline)) {
                        // Display either the list of recipes or a message if no recipes found
                        if hasRecipes {
                            // List of recipes with navigation links to detail views
                            List {
                                ForEach(recipes) { recipe in
                                    NavigationLink(destination: DetailTab(recipeKey: recipe.id)) {
                                        Text(recipe.name)
                                    }
                                }
                                // Swipe from right to delete recipe from the database
                                .onDelete(perform: confirmDelete)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Hledat")
            .onAppear {
                self.loadData()
                self.updateCriteria()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Odstranit recept"),
                message: Text("Opravdu chcete odstranit recept \"\(recipeToDelete?.name ?? "")\" z databáze?"),
                primaryButton: .destructive(Text("Odstranit")) {
                    deleteConfirmedRecipe()
                },
                secondaryButton: .cancel(Text("Zrušit"))
            )
        }
    }
}
