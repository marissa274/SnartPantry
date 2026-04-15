//
//  Item.swift
//  SmartPantry
//
//  Created by Marissa Belle Bindeki on 2026-03-29.
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
