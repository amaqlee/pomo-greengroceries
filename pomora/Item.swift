//
//  Item.swift
//  pomora
//
//  Created by Amanda Lee on 8/22/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
