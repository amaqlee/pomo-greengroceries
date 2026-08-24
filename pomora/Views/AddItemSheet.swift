//
//  AddItemSheet.swift
//  pomora
//
//  Created by Amanda Lee on 8/23/26.
//

import SwiftUI

struct AddItemSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var itemName: String = ""
    @State private var quantity: Int = 1
    @FocusState private var isSearchFocused: Bool
    
    //mock list of groceries for now, add grocery/recipe dataset later
    let commonGroceryItems = [
        "Baby Spinach", "Baby Spinach (Organic)", "Spinach",
        "Eggs", "Whole Milk", "Oranges", "Tomatoes", "Carrots",
        "Chicken Breast", "Greek Yogurt", "Broccoli",
        "Bell Peppers", "Bananas", "Avocado", "Ground Beef"
    ]
    
    var suggestions: [String] {
        guard !itemName.isEmpty else { return [] }
        return commonGroceryItems.filter {$0.localizedCaseInsensitiveContains(itemName)}
    }
    
    var onAdd: (String, Int) -> Void
    
    var body: some View {
        VStack(spacing: 0){
            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            HStack {
                Text("Add New Item")
                    .font(.title2.bold())
                Spacer()
                Button(action: { dismiss() }){
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8){
                Text("Item Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top)
                
                HStack {
                    TextField("Type item to add...", text: $itemName)
                        .focused($isSearchFocused)
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                if !itemName.isEmpty {
                    VStack(spacing: 0){
                        ForEach(suggestions, id: \.self){ suggestion in
                            Button(action: {
                                itemName = suggestion
                                isSearchFocused = false
                            }) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                    highlightedText(suggestion, match: itemName)
                                    Spacer()
                                }
                                .padding()
                            }
                            .buttonStyle(.plain)
                            Divider()
                        }
                        
                        Button(action: { isSearchFocused = false}) {
                            HStack {
                                Image(systemName: "plus")
                                    .foregroundColor(.secondary)
                                Text("Add \"\(itemName)\" as custom item")
                                Spacer()
                            }
                            .padding()
                            .foregroundColor(.primary)
                        }
                        .buttonStyle(.plain)
                    }
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 12){
                Text("Quantity")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack{
                    Button(action: {if quantity > 1 { quantity -= 1} }) {
                        Image(systemName: "minus")
                            .frame(width: 44, height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Text("\(quantity)")
                        .font(.title3.bold())
                        .frame(width: 60, height: 44)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Button(action: {quantity += 1}) {
                        Image(systemName: "plus")
                            .frame(width: 44, height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                guard !itemName.isEmpty else {return }
                onAdd(itemName, quantity)
                dismiss()
            }) {
                Text("ADD")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.35, green: 0.4, blue: 0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
        }
        .background(Color(red: 0.98, green: 0.96, blue: 0.92))
    }
    
    //bolds the matched protion of ea suggestion
    func highlightedText(_ text: String, match: String) -> Text {
        guard let range = text.range(of: match, options: .caseInsensitive) else {
            return Text(text)
        }
        
        let before = String(text[..<range.lowerBound])
        let matched = String(text[range])
        let after = String(text[range.upperBound...])
        return Text(before) + Text(matched).bold() + Text(after)
    }
}
