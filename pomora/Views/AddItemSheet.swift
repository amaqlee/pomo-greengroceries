//
//  AddItemSheet.swift
//  pomora
//
//  Created by Amanda Lee on 8/23/26.
//

import SwiftUI

//popup that appears when user taps "ADD NEW ITEM" button on home screen
//user can
//1. type grocery name and choose from autocomplete suggestions
//2. choose quantity using stepper
//3. tap "ADD NEW ITEM" to return to home screen, with added item appearing
struct AddItemSheet: View {
    // Lets us close (dismiss) this sheet programmatically, e.g. after adding an item.
    @Environment(\.dismiss) private var dismiss
    // What the user has typed into the "Item Name" search field.
    @State private var itemName: String = ""
    // The quantity selected in the stepper, starts at 1.
    @State private var quantity: Int = 1
    // Tracks whether the search field is currently focused (being edited).
    // Used to decide whether to show the autocomplete dropdown.
    @FocusState private var isSearchFocused: Bool
    
    //mock list of groceries for now, add grocery/recipe dataset later
    // TODO: replace with a real grocery/recipe dataset later.
    let commonGroceryItems = [
        "Baby Spinach", "Baby Spinach (Organic)", "Spinach",
        "Eggs", "Whole Milk", "Oranges", "Tomatoes", "Carrots",
        "Chicken Breast", "Greek Yogurt", "Broccoli",
        "Bell Peppers", "Bananas", "Avocado", "Ground Beef"
    ]
    
    // Filters commonGroceryItems down to whatever matches what the user typed
    // Returns an empty list if the search field is empty
    // Capped at 5 results so the dropdown doesn't get too long
    var suggestions: [String] {
        guard !itemName.isEmpty else { return [] }
        return commonGroceryItems
            .filter {$0.localizedCaseInsensitiveContains(itemName)}
            .prefix(5)
            .map{ $0 }
    }
    
    
    // Callback passed in from HomeView. Called when the user taps "ADD NEW ITEM",
    // sending the chosen name and quantity back up to be added to the grocery list
    var onAdd: (String, Int) -> Void
    
    
    var body: some View {
        VStack(spacing: 0){
            // Small gray capsule at the top of the sheet, "drag handle" (draggin deez nuts across ur face)
            Capsule()
                .fill(Color.background)
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 0){
                // Header row: title + close (X) button
                HStack {
                    Text("Add New Item")
                        .font(.title2.bold())
                        .foregroundColor(Color.PBrown)
                    Spacer()
                    Button(action: { dismiss() }){
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(Color.PBrown)
                    }
                }
                .padding(.vertical)
                
                //adds horizontal line underneath
                Divider()
                
                VStack(alignment: .leading, spacing: 8){
                    // "Item Name" label above the search field.
                    Text("Item Name")
                        .font(.subheadline)
                        .foregroundColor(Color.PBrown)
                        .padding(.top)
                    
                    HStack {
                        // The text field where the user types the item name, with a search icon.
                        TextField("Type item to add...", text: $itemName)
                            .focused($isSearchFocused)
                            
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.PBrown)
                    }
                    .padding(.bottom, 8)
                    //adds horizontal line underneath
                    Divider()
                    
                    // Autocomplete dropdown, only shows while the user is actively
                    // typing something into a focused search field.
                    if isSearchFocused && !itemName.isEmpty {
                        // Height of a single suggestion row
                        let rowHeight: CGFloat = 52
                        //max number of rows to show before the list scrolls instead of growing.
                        let maxVisibleRows: CGFloat = 4
                        
                        VStack(spacing: 0){
                            // Only show the scrollable suggestions list if there are
                            // actual matches
                            //otherwise skip to "Add as custom item".
                            if(!suggestions.isEmpty){
                                ScrollView{
                                    VStack(spacing: 0){
                                        // One row per matching suggestion.
                                        ForEach(suggestions, id: \.self){ suggestion in
                                            Button(action: {
                                                // Selecting a suggestion fills in the field
                                                // and closes the dropdown (via focus change)
                                                itemName = suggestion
                                                isSearchFocused = false
                                            }) {
                                                HStack {
                                                    Image(systemName: "magnifyingglass")
                                                        .foregroundColor(Color.PBrown)
                                                        .font(.caption)
                                                    // Shows the suggestion text with the matching part from search bar bolded
                                                    highlightedText(suggestion, match: itemName)
                                                    Spacer()
                                                }
                                                .padding()
                                            }
                                            .buttonStyle(.plain)
                                            Divider()
                                        }
                                    }
                                }
                                // Height grows with the number of results, but never
                                // taller than maxVisibleRows worth of space
                                // after that it scrolls instead of expanding further
                                .frame(height: min(CGFloat(suggestions.count) * rowHeight, maxVisibleRows * rowHeight))
                            }
                            
                            // Fallback row: lets the user add whatever they typed
                            // even if it didn't match anything in the list.
                            Button(action: {
                                isSearchFocused = false
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                        .foregroundColor(Color.PBrown)
                                    Text("Add \"\(itemName)\" as custom item")
                                    Spacer()
                                }
                                .padding()
                                .foregroundColor(Color.PBrown)
                            }
                            .buttonStyle(.plain)
                        }
                        .background(Color.lightBack)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                
                Spacer()
                
                // Quantity selector: minus button, current count, plus button
                // all inside one connected bordered control
                VStack(alignment: .leading, spacing: 12){
                    Text("Quantity")
                        .font(.subheadline)
                        .foregroundColor(Color.PBrown)
                    
                    HStack (spacing: 0){
                        // Decrease quantity, but never below 1
                        Button(action: {if quantity > 1 { quantity -= 1} }) {
                            Image(systemName: "minus")
                                .frame(width: 44, height: 44)
                                .background(Color.background)
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                        
                        Divider().frame(height: 24)
                        
                        // Current quantity value.
                        Text("\(quantity)")
                            .font(.title3.bold())
                            .frame(width: 60, height: 44)
                            .foregroundColor(Color.PBrown)
                        
                        Divider().frame(height: 24)
                        
                        // Increase quantity.
                        Button(action: {quantity += 1}) {
                            Image(systemName: "plus")
                                .frame(width: 44, height: 44)
                                .background(Color.background)
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )

                        }
                        .buttonStyle(.plain)
                    }
                    // Shared background/border wraps all three pieces so they look
                    // like one connected control instead of three separate boxes.
                    .background(Color.lightBack)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .fixedSize()
                }

                // Final "confirm" button. Only adds the item if a name was entered,
                // then calls onAdd to send the data back to HomeView and closes the sheet.
                Button(action: {
                    guard !itemName.isEmpty else {return }
                    onAdd(itemName, quantity)
                    dismiss()
                }) {
                    Text("ADD NEW ITEM")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.35, green: 0.4, blue: 0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.vertical)
            }
            .padding(.horizontal, 24)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
    
    // Takes a suggestion string and bolds the part that matches what the user typed.
    // Example: typing "Sp" on "Baby Spinach" bolds just the "Sp".
    // If no match is found (shouldn't normally happen here), returns the plain text.
    func highlightedText(_ text: String, match: String) -> Text {
        guard let range = text.range(of: match, options: .caseInsensitive) else {
            return Text(text)
        }
        
        let before = String(text[..<range.lowerBound])
        let matched = String(text[range])
        let after = String(text[range.upperBound...])
        return Text("\(before)\(Text(matched).bold())\(after)")
            .foregroundColor(Color.PBrown)
    }
}
