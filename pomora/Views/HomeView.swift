//
//  HomeView.swift
//  pomora
//
//  Created by Amanda Lee on 8/22/26.
//


// HomeView
// The app's main/home screen. Shows:
// (appears when selectedTab == .home in RootView)
//   - A fixed header (logo, title, FRIDGE label, item count)
//   - Two stat cards (Freshness % and Expiring Soon count) — also fixed
//   - A scrollable list of grocery items (FoodItemRow for each one)
//   - A floating "ADD NEW ITEM" button pinned to the bottom
// Tapping "ADD NEW ITEM" opens AddItemSheet, which sends new items back here
// through a closure.
// Tapping the X on a row asks HomeView to confirm deletion via a DeleteConfirmationCard
// Grocery data currently lives in a local @State array
// (mock data). this will later be replaced with real persisted storage
import SwiftUI

// A custom PreferenceKey used to read how far the grocery list has been
// scrolled. This lets HomeView react to scroll position (e.g. to show/hide
// a "scroll for more" hint, currently commented out below).
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct HomeView: View {
    // Controls whether the "Add New Item" sheet is currently showing.
    @State private var showAddItemSheet = false
    
    // The grocery items shown on screen. Mock/sample data for now
    // will eventually come from persisted storage instead of being hardcoded.
    @State private var items: [GroceryItem] = [
        GroceryItem(name: "Eggs", quantity: 6, daysUntilExpiration: 2),
        GroceryItem(name: "Oranges", quantity: 3, daysUntilExpiration: 3),
        GroceryItem(name: "Tomatoes", quantity: 3, daysUntilExpiration: 7),
        GroceryItem(name: "Carrots", quantity: 12, daysUntilExpiration: 8)
    ]
    
    // Tracks the grocery list's current scroll position (used for the
    // scroll-hint chevron feature, currently disabled/commented out).
    @State private var scrollOffset: CGFloat = 0
    
    //which item (if any) the user has tapped the X on and is being asked to confirm deletion
    @State private var itemPendingDelete: GroceryItem? = nil
    
    //smalle helper to drive .animation(...) off a boolean
    private var isShowingDeleteConfirmation: Bool {
        itemPendingDelete != nil
    }
    
    // Number of items that count as "expiring soon": supports the expiring soon card
    var expiringSoonCount: Int {
        items.filter { $0.isExpiringSoon }.count
    }
    
    // Percentage of items that are NOT expiring soon, supports the freshness card
    // Returns 0 if there are no items at all, to avoid dividing by zero.
    var freshnessPercent: Int {
        guard !items.isEmpty else { return 0 }
        let freshCount = items.filter { !$0.isExpiringSoon}.count
        return Int((Double(freshCount) / Double(items.count)) * 100)
    }
    
    
    var body: some View {
        //navigationStack wraps screen so .sheet(...) and future
        //push styl navigation like tapping an item to see detail
        //has proper nav context to work inside of
        NavigationStack {
            VStack(spacing: 0){
                // ---- Fixed header + stats section (does NOT scroll) ----
                VStack(spacing: 16){
                    // "FRIDGE" label + item count badge.
                    HStack {
                        Text("FRIDGE")
                            .font(.headline)
                            .foregroundColor(Color.PBrown)
                        Spacer()
                        
                        //grouping item count and + button to the right
                        HStack(spacing: 8){
                            Text("\(items.count) items")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray5))
                                .foregroundColor(Color.PBrown)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.PGrey, lineWidth: 1)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            //add item button
                            Button(action: {
                                showAddItemSheet = true
                            }) {
                                HStack(spacing: 4){
                                    Image(systemName: "plus")
                                        .font(.caption.bold())
                                    Text("ADD NEW ITEM")
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
                    
                    // Freshness % and Expiring Soon count cards, side by side.
                    HStack(spacing: 12) {
                        StatCard(
                            icon: "leaf.fill",
                            title: "FRESHNESS",
                            value: "\(freshnessPercent)%",
                            backgroundColor: Color(hex: "D4E3C8"),
                            borderColor: Color(hex: "BBC9A3"),
                            textColor: Color.PDGreen
                        )
                        StatCard(
                            icon: "exclamationmark.triangle.fill",
                            title: "EXPIRING SOON",
                            value: "\(expiringSoonCount)",
                            backgroundColor: Color(hex: "FFDBD5"),
                            borderColor: Color(hex: "EEA7A3"),
                            textColor: Color.PDRed
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 12)
                // Solid background + zIndex(1) keep this header visually
                // "in front of" the scrolling list beneath it, so items
                // don't show through as they scroll past this section.
                //higher numbers draws on top
                .background(Color.background)
                .zIndex(1)
                
                //swipe-to-delete is a List only feature
                //style a list to look like a ScrollView
                List {
                    if items.isEmpty {
                        //empty state, shown when there are no groceries
                        Text("NO FOOD YET!")
                            .font(.headline)
                            .foregroundColor(Color.PBrown)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 180)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }else{
                        //one row per grocery item, passing a binding ($item)
                        //so quantity changes write back into real array
                        ForEach($items) { $item in
                            FoodItemRow(
                                item: $item,
                                onQuantityZero: {
                                    //runs when item quantity hits 0
                                    //removes item with a fade animation
                                    withAnimation{items.removeAll {$0.id == item.id}}
                                }
                            )
                            //hides default List appearance
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                            //edge: .trailing means swipe from right to left activates delete
                            //sets itemPendingDelete
                            .swipeActions(edge: .trailing, allowsFullSwipe: true){
                                Button(role: .destructive) {
                                    itemPendingDelete = item
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(Color.PRed)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                //lets background color show through
                .scrollContentBackground(.hidden)
                .background(Color.background)
            }
            .background(Color.background.ignoresSafeArea())
            //fades where list meets footer
            .overlay(alignment: .bottom){
                LinearGradient(
                    colors: [Color.background.opacity(0), Color.background],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 60)
                .allowsHitTesting(false)
            }
            //delete confirmation overlar
            .overlay {
                if let item = itemPendingDelete {
                    ZStack {
                        Color.black.opacity(0.25)
                            .ignoresSafeArea()
                            .onTapGesture {
                                itemPendingDelete = nil
                            }
                        DeleteConfirmationCard(
                            itemName: item.name,
                            onCancel: {
                                itemPendingDelete = nil
                            },
                            onDelete: {
                                withAnimation{
                                    items.removeAll { $0.id == item.id }
                                }
                                itemPendingDelete = nil
                            }
                        )
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isShowingDeleteConfirmation)
            
            //shows the add item popup
            .sheet(isPresented: $showAddItemSheet) {
                AddItemSheet { name, qty in
                    //called when user taps "ADD NEW ITEM"
                    //TODO: change so daysUntilExpiration isn't hardcoded
                    items.append(GroceryItem(name : name, quantity: qty, daysUntilExpiration: 7))
                }
                .presentationDetents([.height(590)]) //fixed sheet height
                .presentationDragIndicator(.hidden)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview{
    HomeView()
}
