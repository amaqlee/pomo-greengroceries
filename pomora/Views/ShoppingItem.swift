//
//  ShoppingItem.swift
//  pomora
//
//  Created by Kimiko Low on 9/26/26.
//

// represents an individual item in the shopping list

import Foundation

struct ShoppingItem: Identifiable {
    let id = UUID()
    var name: String
    var quantity: Int
    // starts false AKA unchecked every time a new item is added
    var isChecked: Bool = false
}
