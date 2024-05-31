//
// @file detail.swift
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Implementation of the detail tab.
// @date 2024-05-26
//

import FirebaseDatabase
import SwiftUI

// Define a custom Rating view
struct Rating: View {
    @Binding var rating: Double
    // Define the body of the view
    var body: some View {
        // Horizontal stack to hold the star images
        HStack(spacing: 2) {
            ForEach(0..<5) { star in
                // Display a star image filled or empty based on the rating
                Image(systemName: star < Int(rating) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        // Update rating when tapped
                        rating = Double(star + 1)
                    }
            }
        }
    }
}

struct DetailTab: View {
    // Reference to Firebase database
    let db = Database.database().reference()
    // Unique key for the recipe
    let recipeKey: String

    // State variables to hold recipe details and UI state
    @State private var recipeName = ""
    @State private var recipeType = ""
    @State private var recipeTime = ""
    @State private var recipeRating = 0.0
    @State private var recipeFavorite = 0
    @State private var recipeIngredientsName = [String]()
    @State private var recipeIngredientsAmount = [Int]()
    @State private var recipeIngredientsUnit = [String]()
    @State private var recipeIngredientsPressed = [Int]()
    @State private var recipeStepsText = [String]()
    @State private var recipeStepsTime = [Int]()
    @State private var recipeStepsPressed = [Int]()
    @State private var image = ""
    @State private var countdownTimer = 0
    @State private var isTimerRunning = false
    @State private var portions = 1
    @State private var timer: Timer? = nil
    @State private var showAlert = false
    @State private var showConfirm = false

    // Shared data model for the shopping list
    @EnvironmentObject var sharedData: Shared

    // Function to format timer display
    func formatTimer(seconds: Int) -> String {
        // Convert total seconds to hours, minutes, and remaining seconds
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        // Return formatted string
        return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
    }

    // Function to start the timer for a recipe step
    func startTimer(duration: Int, index: Int) {
        // Invalidate existing timer if any
        timer?.invalidate()
        // Set initial timer values
        countdownTimer = duration * 60
        isTimerRunning = true
        recipeStepsPressed[index] = 0
        // Create and schedule a new timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.countdownTimer > 0 {
                self.countdownTimer -= 1
            }
            else {
                // End timer when countdown reaches 0
                timer.invalidate()
                self.isTimerRunning = false
                self.recipeStepsPressed[index] = 1
                self.showAlert = false
            }
        }
    }

    // Function to end the timer
    func endTimer() {
        // Invalidate the timer
        timer?.invalidate()
        isTimerRunning = false
    }

    // Function to update recipe rating in Firebase
    func updateRating(rating: Double) {
        db.child("recipes/\(recipeKey)/rating").setValue(rating)
        recipeRating = rating
    }

    // Function to toggle recipe favorite status in Firebase
    func updateFavorite() {
        let newFavoriteValue = recipeFavorite == 1 ? 0 : 1
        db.child("recipes/\(recipeKey)/favorite").setValue(newFavoriteValue)
        recipeFavorite = newFavoriteValue
    }

    // Function to decrease recipe portions
    func decreasePortions() {
        portions = max(1, portions - 1)
    }

    // Function to increase recipe portions
    func increasePortions() {
        portions += 1
    }

    // Function to toggle tapped ingredient state
    func changeTappedIngredient(index: Int) {
        recipeIngredientsPressed[index] = recipeIngredientsPressed[index] == 1 ? 0 : 1
    }

    // Function to toggle tapped recipe step state
    func changeTappedStep(index: Int) {
        recipeStepsPressed[index] = recipeStepsPressed[index] == 1 ? 0 : 1
    }

    // Function to add ingredient to list
    func addToList(name: String) {
        sharedData.add(name: name)
    }

    // Function to load recipe details from database
    func loadRecipe() {
        db.child("recipes/\(recipeKey)").observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(), let recipe = snapshot.value as? [String: Any] else {
                return
            }
            // Extract recipe details from snapshot
            recipeType = recipe["dishType"] as? String ?? ""
            recipeTime = "\(recipe["time"] ?? 0) min"
            recipeRating = recipe["rating"] as? Double ?? 0.0
            recipeFavorite = recipe["favorite"] as? Int ?? 0
            if let ingredients = recipe["ingredients"] as? [[String: Any]] {
                recipeIngredientsName = ingredients.compactMap { $0["name"] as? String }
                recipeIngredientsAmount = ingredients.compactMap { $0["amount"] as? Int }
                recipeIngredientsUnit = ingredients.compactMap { $0["unit"] as? String }
                recipeIngredientsPressed = Array(repeating: 0, count: recipeIngredientsName.count)
            }
            if let steps = recipe["steps"] as? [[String: Any]] {
                recipeStepsText = steps.compactMap { $0["text"] as? String }
                recipeStepsTime = steps.compactMap { $0["time"] as? Int }
                recipeStepsPressed = Array(repeating: 0, count: recipeStepsText.count)
            }
            image = recipe["image"] as? String ?? ""
            recipeName = recipe["name"] as? String ?? ""
        }
    }

    var body: some View {
        // Scroll view to allow scrolling when content exceeds screen size
        ScrollView {
            VStack {
                ZStack {
                    // Conditional display of image or placeholder
                    if !image.isEmpty {
                        AsyncImage(url: URL(string: image)) { phase in
                            switch phase {
                                // Placeholder if image loading fails
                                case .failure:
                                    Image("placeholder")
                                        .font(.largeTitle)
                                // Display image if loading is successful
                                case .success(let img):
                                    img
                                        .resizable()
                                // Show loading indicator while image is loading
                                default:
                                    ProgressView()
                            }
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 256)
                        .clipped()
                    }
                    else {
                        Image("placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: 256)
                            .clipped()
                    }
                }
                // Horizontal stack for displaying recipe time, type, rating, and favorite button
                HStack {
                    Text(recipeTime)
                        .foregroundColor(.white)
                        .padding()
                        .font(.footnote)
                    Text(recipeType)
                        .foregroundColor(.white)
                        .padding()
                        .font(.footnote)
                    Spacer()
                    // Custom rating view
                    Rating(rating: $recipeRating)
                    Button(action: {
                        updateFavorite()
                    }) {
                        Image(systemName: recipeFavorite == 1 ? "heart.fill" : "heart")
                            .foregroundColor(recipeFavorite == 1 ? .red : .white)
                            .padding()
                    }
                }
                .background(Color.black)
                // Horizontal stack for adjusting portions and displaying ingredient count
                HStack {
                    Text("Ingredience")
                        .font(.title2)
                    Spacer()
                    Button(action: decreasePortions) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                    Text("\(portions < 5 ? "\(portions) porce" : "\(portions) porcí")")
                    Button(action: increasePortions) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
                .padding()
                // Loop for displaying each ingredient with checkboxes, amounts, and "add to list" button
                ForEach(0..<recipeIngredientsName.count, id: \.self) { index in
                    HStack {
                        HStack {
                            Image(systemName: recipeIngredientsPressed[index] == 1 ? "checkmark.circle.fill" : "checkmark.circle")
                            Text("\(recipeIngredientsName[index])")
                        }
                        .foregroundColor(recipeIngredientsPressed[index] == 1 ? .green : .black)
                        .onTapGesture {
                            changeTappedIngredient(index: index)
                        }
                        Spacer()
                        Text("\(recipeIngredientsAmount[index] * portions) \(recipeIngredientsUnit[index])")
                            .foregroundColor(.black)
                        Button(action: {
                            addToList(name: "\(recipeIngredientsName[index]) (\(recipeIngredientsAmount[index] * portions) \(recipeIngredientsUnit[index]))")
                            self.showConfirm = true
                        }) {
                            Image(systemName: "cart.badge.plus.fill")
                                .foregroundColor(.black)
                        }
                        .buttonStyle(.borderedProminent)
                        .alert(isPresented: $showConfirm) {
                            Alert(title: Text("Položka přidána"), message: Text("Položka \"\(recipeIngredientsName[index]) (\(recipeIngredientsAmount[index] * portions) \(recipeIngredientsUnit[index]))\" byla přidána do seznamu"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                // Divider for separating ingredients and steps
                Divider()
                // Title for recipe steps
                Text("Postup")
                    .font(.title2)
                    .padding()
                // Loop for displaying each step with checkboxes, timers, and "start" button
                ForEach(0..<recipeStepsText.count, id: \.self) { index in
                    HStack {
                        HStack {
                            Image(systemName: recipeStepsPressed[index] == 1 ? "checkmark.circle.fill" : "checkmark.circle")
                            Text(recipeStepsText[index])
                        }
                        .foregroundColor(recipeStepsPressed[index] == 1 ? .green : .black)
                        .onTapGesture {
                            changeTappedStep(index: index)
                        }
                        Spacer()
                        Button(action: {
                            startTimer(duration: recipeStepsTime[index], index: index)
                            self.showAlert = true
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                recipeStepsTime[index] >= 5 ? Text("\(recipeStepsTime[index]) minut") : (recipeStepsTime[index] >= 2 ? Text("\(recipeStepsTime[index]) minuty") : Text("\(recipeStepsTime[index]) minuta"))
                            }
                            .foregroundColor(.black)
                        }
                        .buttonStyle(.borderedProminent)
                        .opacity(recipeStepsTime[index] > 0 ? 1 : 0)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Časovač"), message: Text("\(formatTimer(seconds: countdownTimer))"),
                                dismissButton: .default(Text("Ukončit")) {
                                    endTimer()
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                Spacer()            }
        }
        // Load recipe data when view appears
        .onAppear(perform: loadRecipe)
        // Set navigation bar title
        .navigationBarTitle(recipeName, displayMode: .inline)
        // Set toolbar background color
        .toolbarBackground(.gray, for: .navigationBar)
        // Make toolbar visible
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
