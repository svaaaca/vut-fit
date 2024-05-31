//
// @file navigation.swift
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Implementation of a bottom bar of the application.
// @date 2024-05-26
//

import SwiftUI

struct Navigation: View {
    // State variable to keep track of the current selected tab
    @State private var currentIndex = 0
    
    var body: some View {
        // TabView to create a tab-based navigation interface
        TabView(selection: $currentIndex) {
            Group {
                // First tab: Search
                SearchTab()
                    .tabItem {
                        Label("Hledat", systemImage: "magnifyingglass")
                    }
                    .tag(0)
                
                // Second tab: Create
                CreateTab()
                    .tabItem {
                        Label("Vytvořit", systemImage: "square.and.pencil")
                    }
                    .tag(1)
                
                // Third tab: Favorites
                FavoritesTab()
                    .tabItem {
                        Label("Oblíbené", systemImage: "heart")
                    }
                    .tag(2)
                
                // Fourth tab: List
                ListTab()
                    .tabItem {
                        Label("Seznam", systemImage: "cart")
                    }
                    .tag(3)
            }
            // Setting toolbar background visibility and color for tab bar
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.black, for: .tabBar)
        }
        // Setting the accent color for selected tab item
        .accentColor(.yellow)
    }
}
