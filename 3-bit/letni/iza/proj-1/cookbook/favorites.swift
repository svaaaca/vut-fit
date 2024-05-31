//
// @file favorites.swift
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Implementation of the favorites tab.
// @date 2024-05-26
//

import FirebaseDatabase
import SwiftUI

struct FavoritesTab: View {
    // State variable to hold an array of favorite recipes
    @State private var recipes: [(name: String, image: String, key: String)] = []

    // Function to load favorite recipes from Firebase Realtime Database
    func loadRecipes() {
        // Reference to the Firebase database
        let db = Database.database().reference()
        // Fetch data from the 'recipes' node once
        db.child("recipes").observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            var loadedRecipes: [(name: String, image: String, key: String)] = []
            // Iterate through each recipe in the data
            for (key, value) in data {
                if let recipe = value as? [String: Any], recipe["favorite"] as? Int == 1 {
                    let recName = recipe["name"] as? String ?? ""
                    let recImage = recipe["image"] as? String ?? ""
                    // Add the recipe to the array
                    loadedRecipes.append((name: recName, image: recImage, key: key))
                }
            }
            // Sort recipes alphabetically by name
            self.recipes = loadedRecipes.sorted(by: { $0.name < $1.name })
        }
    }

    var body: some View {
        NavigationView {
            List {
                // Iterate through each recipe and create a section
                ForEach(recipes, id: \.key) { recipe in
                    Section(header: Text(recipe.name).font(.headline)) {
                        // Navigation link to navigate to detail view of each recipe
                        NavigationLink(destination: DetailTab(recipeKey: recipe.key)) {
                            VStack {
                                // Display recipe image asynchronously
                                if !recipe.image.isEmpty {
                                    AsyncImage(url: URL(string: recipe.image)) { phase in
                                        switch phase {
                                            case .failure:
                                                Image("placeholder")
                                                    .resizable()
                                            case .success(let img):
                                                img
                                                    .resizable()
                                            default:
                                                ProgressView()
                                        }
                                    }
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity, maxHeight: 164)
                                    .clipped()
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                }
                                else {
                                    // Display a placeholder image if recipe image is not available
                                    Image("placeholder")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity, maxHeight: 164)
                                        .clipped()
                                        .background(Color.black)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(height: 164)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            // Call load recipes function when the view appears
            .onAppear {
                loadRecipes()
            }
            .navigationTitle("Oblíbené")
        }
    }
}
