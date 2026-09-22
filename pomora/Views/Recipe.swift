//
//  Recipe.swift
//  pomora
//
//  Created by Amanda Lee.
//
// Data model for a recipe, used by RecipeDetailView and recipe
// search/browse page.

import SwiftUI

//one ingredient line
//isChecked: ingredient already in fridge
struct RecipeIngredient: Identifiable {
    //generates unique ID for each ingredient
    let id = UUID()
    var name: String
    var isChecked: Bool = false
}

//Recipe difficulty label in recipe page metabar
enum RecipeDifficulty: String {
    case easy = "EASY"
    case medium = "MEDIUM"
    case hard = "HARD"
}

struct Recipe: Identifiable {
    let id = UUID()
    var name: String
    var imageName: String? //can hold a string or nil
    var isGoodMatch: Bool //shows/hides the "Good Match" badge
    var prepTimeMinutes: Int
    var difficulty: RecipeDifficulty
    var servings: Int
    var ingredients: [RecipeIngredient]
    var instructions: [String]
}

//example recipe for display
extension Recipe {
    static let sample = Recipe(
        name: "Marry Me Chicken Pasta",
        imageName: nil, //no photo yet, so show placeholder
        isGoodMatch: true,
        prepTimeMinutes: 30,
        difficulty: .easy,
        servings: 2,
        ingredients: [
            RecipeIngredient(name: "12oz pasta of choice"),
            RecipeIngredient(name: "1 tbsp olive oil"),
            RecipeIngredient(name: "1/2 onion (diced)"),
            RecipeIngredient(name: "3-4 cloves of garlic minced"),
            RecipeIngredient(name: "1 lb of chicken breast (chopped)"),
            RecipeIngredient(name: "1 cup heavy cream"),
            RecipeIngredient(name: "1 cup parmesan"),
            RecipeIngredient(name: "seasonings of choice"),
            RecipeIngredient(name: "1 tbsp butter"),
            RecipeIngredient(name: "4 tbsp tomato paste"),
        ],
        instructions: [
            "Boil a large pot of water and salt it generously",
            "Once boiling, add pasta. Cook until al dente following package instructions",
            "While pasta cooks, heat olive oil in a large skillet over medium heat",
            "Add onion and garlic, cook until fragrant, about 2 minutes",
            "Add chicken and cook until browned and cooked through",
            "Stir in tomato paste and cook for 1 minute",
            "Lower heat, add heavy cream and parmesan, stir until combined",
            "Toss in drained pasta and butter, coating everything evenly",
            "Season to taste and serve warm"
        ]
    )
}
