//
//  GroceryItem.swift
//  pomora
//
//  Created by Amanda Lee on 8/22/26.
//

import SwiftUI

struct GroceryItem: Identifiable {
    let id = UUID();
    var name: String
    var quantity: Int
    var daysUntilExpiration: Int
    
    var isExpiringSoon: Bool {
        daysUntilExpiration <= 3
    }
}
