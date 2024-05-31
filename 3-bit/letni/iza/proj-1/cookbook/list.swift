//
// @file list.swift
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Implementation of the list tab.
// @date 2024-05-26
//

import SwiftUI

// Define an item in the shopping list
struct ListItem: Identifiable {
    var id = UUID()
    var name: String
    var isPressed: Bool = false
}

struct ListTab: View {
    // State variables to manage the list and user input
    @State private var newItemName = ""
    @State private var showDeleteItemAlert = false
    @State private var itemToDelete: ListItem?
    @State private var showDeleteAllItemsAlert = false

    // Shared data model for the shopping list
    @EnvironmentObject var sharedData: Shared

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Přidat").font(.headline)) {
                    // Input field to add a new item to the shopping list
                    TextField("Zadejte název položky...", text: $newItemName)
                    // Button to add a new item
                    Button(action: {
                        if !newItemName.isEmpty {
                            sharedData.shoppingList.append(ListItem(name: newItemName))
                            newItemName = ""
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Uložit položku")
                                .tint(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .tint(.gray)
                        }
                    }
                    .disabled(newItemName.isEmpty)
                }
                Section(header: Text("Detail").font(.headline)) {
                    // List view displaying each item in the shopping list
                    List {
                        ForEach(sharedData.shoppingList) { item in
                            HStack {
                                // Checkmark icon to indicate if the item is pressed (checked)
                                Image(systemName: item.isPressed ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.isPressed ? .green : .black)
                                    .onTapGesture {
                                        // Toggle the pressed state of the item when tapped
                                        if let index = sharedData.shoppingList.firstIndex(where: { $0.id == item.id }) {
                                            sharedData.shoppingList[index].isPressed.toggle()
                                        }
                                    }
                                // Display the name of the item
                                Text(item.name)
                                Spacer()
                                // Button to delete the item
                                Button(action: {
                                    itemToDelete = item
                                    showDeleteItemAlert = true
                                }) {
                                    Image(systemName: "trash")
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Seznam")
            // Button to delete all items in the shopping list
            .navigationBarItems(trailing:
                Button(action: {
                    showDeleteAllItemsAlert = true
                }) {
                    Image(systemName: "trash")
                }
                .buttonStyle(.borderedProminent)
                .disabled(sharedData.shoppingList.isEmpty)
                .foregroundColor(.white)
                .tint(.red)
                .alert(isPresented: $showDeleteAllItemsAlert) {
                    // Alert to confirm deletion of all items
                    Alert(
                        title: Text("Odstranit všechny položky"),
                        message: Text("Opravdu chcete odstranit všechny položky?"),
                        primaryButton: .cancel(Text("Ne")),
                        secondaryButton: .destructive(Text("Ano")) {
                            sharedData.shoppingList.removeAll()
                        }
                    )
                }
            )
        }
        // Alert to confirm deletion of a specific item
        .alert(item: $itemToDelete) { item in
            Alert(
                title: Text("Odstranit položku"),
                message: Text("Opravdu chcete odstranit položku \"\(item.name)\"?"),
                primaryButton: .cancel(Text("Ne")),
                secondaryButton: .destructive(Text("Ano")) {
                    if let index = sharedData.shoppingList.firstIndex(where: { $0.id == item.id }) {
                        sharedData.shoppingList.remove(at: index)
                    }
                }
            )
        }
    }
}
