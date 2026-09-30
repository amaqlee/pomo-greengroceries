//
//  ShoppingListView.swift
//  pomora
//
//  Created by Kimiko Low on 9/26/26.
//

//  Screen that appears when user navigates to the shopping list inside nav drawer
//  AKA: selectedTab == .shoppingList in RootView
//  uses same AddItemSheet popup to add new items to the shopping list

import SwiftUI

struct ShoppingListView: View {
    // controls whether the AddItemSheet is currently showing
    @State private var showAddItemSheet = false
    
    // fake things for now, will later come from persisted storage
    // TODO: adjust this so that items come from persisted storage!
    @State private var items: [ShoppingItem] = [
        ShoppingItem(name: "Heirloom Tomatoes", quantity: 4),
        ShoppingItem(name: "Avocados", quantity: 2),
        ShoppingItem(name: "Eggs", quantity: 12, isChecked: true),
        ShoppingItem(name: "Milk", quantity: 1),
    ]
    
    @State private var showConfirmationCard = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Title ("shopping list") + item count + add item button
            HStack {
                Text("Shopping List")
                    .font(.headline)
                    .foregroundColor(.PBrown)
                Spacer()
                
                HStack(spacing: 8) {
                    // clear list button
                    Button {
                        showConfirmationCard = true
                    } label: {
                        Text("CLEAR LIST")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(items.isEmpty ? Color(.systemGray5) : Color(hex: "FFDBD5"))
                            // changes button color to grey if list is empty
                            .foregroundColor(items.isEmpty ? Color.PBrown : Color.PRed)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.PGrey, lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .disabled(items.isEmpty) // disables button if there are no items in shopping list
                    
                    // add new item button (same as from homeview)
                    Button {
                        showAddItemSheet = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                                .font(.caption.bold())
                            Text("ADD ITEM")
                                .font(.caption.bold())
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "D4E3C8"))
                        .foregroundColor(Color.PDGreen)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "BBC9A3"), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 12)
            
            Divider()
                .overlay(Color.PGrey)
                .padding(.horizontal, 24)
            
            
            
            // scrollable part of the screen containing the shopping list items
            ScrollView{
                VStack(spacing: 0) {
                    if items.isEmpty {
                        Text("start planning your next shopping trip!")
                            .font(.headline)
                            .foregroundColor(Color.PBrown)
                            .padding(.top, 180)
                    } else {
                        // $items lets each row bind to its own item
                        ForEach($items) { $item in
                            ShoppingItemRow(item: $item)
                            Divider()
                                .overlay(Color.PGrey.opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .background(Color.background.ignoresSafeArea())
        
        // reuses AddItemSheet as it already exists
        .sheet(isPresented: $showAddItemSheet) {
            AddItemSheet { name, qty in
                items.append(ShoppingItem(name: name, quantity: qty))
            }
            .presentationDetents([.height(590)])
            .presentationDragIndicator(.hidden)
        }
        
        // confrimation card appears when you try to clear list
        .overlay {
            if showConfirmationCard {
                ZStack {
                    // dimmed background, tapping it also cancels
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showConfirmationCard = false
                        }
                            
                    ConfirmationCard(
                        title: "Clear entire list?",
                        message: "This will remove all \(items.count) items, checked and unchecked.",
                        confirmLabel: "CLEAR LIST",
                        onCancel: {
                            showConfirmationCard = false
                        },
                        onConfirm: {
                            withAnimation {
                                items.removeAll()
                            }
                            showConfirmationCard = false
                        }
                    )
                }
                .transition(.opacity)
            }
        }
        // Smoothly animate the card fading in and out
        .animation(.easeInOut(duration: 0.3), value: showConfirmationCard)
    }
}
