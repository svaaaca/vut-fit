//
// @file shared.swift
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Implementation of the shared data.
// @date 2024-05-26
//

import SwiftUI

// Define a shared data model class conforming to ObservableObject
class Shared: ObservableObject {
    // Published property to notify views when the shopping list changes
    @Published var shoppingList = [ListItem]()

    // Function to add a new item to the shopping list
    func add(name: String) {
        let newItem = ListItem(name: "\(name)")
        shoppingList.append(newItem)
    }
}
