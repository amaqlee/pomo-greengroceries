//
//  HomeView.swift
//  pomora
//
//  Created by Amanda Lee on 8/22/26.
//


// HomeView
// The app's main/home screen. Shows:
//   - A fixed header (logo, title, FRIDGE label, item count)
//   - Two stat cards (Freshness % and Expiring Soon count) — also fixed
//   - A scrollable list of grocery items (FoodItemRow for each one)
//   - A floating "ADD NEW ITEM" button pinned to the bottom
// Tapping "ADD NEW ITEM" opens AddItemSheet, which sends new items back here
// through a closure. Grocery data currently lives in a local @State array
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

//hi hi hi test test test
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
        NavigationStack {
            // ZStack lets us layer the floating "Add New Item" button on top
            // of the scrollable content, pinned to the bottom of the screen.
            ZStack(alignment: .bottom) {
                // Base background color, extended to fill the whole screen
                // (including behind the notch/home indicator areas).
                Color.background
                    .ignoresSafeArea()
                VStack(spacing: 0){
                    // ---- Fixed header + stats section (does NOT scroll) ----
                    VStack(spacing: 16){
                        // App logo + wordmark + menu icon.
                        HStack {
                            Image("PomoLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .scaleEffect(2.2)
                            Text("POMORA")
                                .font(.title2.bold())
                                .foregroundColor(Color.PBrown)
                            Spacer()
                            Image(systemName: "line.3.horizontal")
                                .font(.title2)
                        }
                        
                        // "FRIDGE" label + item count badge.
                        HStack {
                            Text("FRIDGE")
                                .font(.headline)
                                .foregroundColor(Color.PBrown)
                            Spacer()
                            Text("\(items.count) items")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray5))
                                .foregroundColor(Color.PBrown)
                                .clipShape(Capsule())
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
                    .padding(.bottom, 12)
                    // Solid background + zIndex(1) keep this header visually
                    // "in front of" the scrolling list beneath it, so items
                    // don't show through as they scroll past this section.
                    .background(Color.background)
                    .zIndex(1)
                    
                    // ---- Scrollable grocery list (only this part scrolls) ----
                    ScrollView {
                        VStack(spacing: 12){
                            if items.isEmpty {
                                // Empty state, shown when there are no groceries at all.
                                Text("NO FOOD YET!")
                                    .font(.headline)
                                    .foregroundColor(Color.PBrown)
                                    .padding(.top, 180)
                            }else{
                                // One row per grocery item. Passing a binding ($item)
                                // so quantity changes write back into the real array.
                                ForEach($items) { $item in
                                    FoodItemRow(item: $item){
                                        // Runs when this item's quantity hits 0 —
                                        // remove it from the list with a fade animation.
                                        withAnimation {items.removeAll { $0.id == item.id }}
                                    }
                                }
                            }
                        }
                        .padding(.top, 12)
                        // leaves room so the last item isn't hidden under the floating button
                        .padding(.bottom, 90)
                        .background(
                            // Invisible helper view that reports this content's
                            // scroll position up via ScrollOffsetKey.
                            GeometryReader { geo in
                                Color.clear.preference(key: ScrollOffsetKey.self, value:
                                geo.frame(in: .named("scroll")).minY)
                            }
                        )
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetKey.self) { value in
                        scrollOffset = value
                    }
                }
                
                // Scroll-hint chevron (currently disabled). Was meant to show a
                // "scroll for more" arrow when there are more than 4 items and
                // the user hasn't scrolled yet.
                
//                if items.count > 4 && scrollOffset > -10 {
//                    VStack {
//                        Image(systemName: "chevron.down")
//                            .font(.title3.bold())
//                            .foregroundColor(.secondary)
//                            .padding(10)
//                            .background(Color(.systemBackground))
//                            .clipShape(Circle())
//                            .shadow(radius: 2)
//                    }
//                    .padding(.bottom, 80)
//                    .transition(.opacity)
//                    .animation(.easeInOut, value: scrollOffset)
//                }
                
                // ---- Floating "Add New Item" button (always visible, bottom of screen)
                Button(action: {
                    showAddItemSheet = true
                }){
                    Text("ADD NEW ITEM")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.PDGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                // Subtle gradient fade behind the button so scrolled items
                // fade out smoothly instead of getting cut off abruptly
                .background(
                    LinearGradient(
                        colors: [Color(.systemBackground).opacity(0), Color(.systemBackground)],
                        startPoint: .top, endPoint: .bottom
                    )
                    .frame(height: 90)
                    .allowsHitTesting(false),
                    alignment: .top
                )
            }
            
            // Shows the Add Item popup sheet when showAddItemSheet is true.
            .sheet(isPresented: $showAddItemSheet) {
                AddItemSheet { name, qty in
                    // Called when the user taps "ADD NEW ITEM" inside the sheet
                    // appends a new GroceryItem to our list.
                    items.append(GroceryItem(name: name, quantity: qty, daysUntilExpiration: 7))
                }
                .presentationDetents([.height(590)]) // fixed sheet height
                .presentationDragIndicator(.hidden) // using our own custom drag handle instead
            }
        }
        // Hides the (empty, unused) navigation bar so there's no extra
        // blank space reserved at the top of the screen.
        .navigationBarHidden(true)
    }
}

#Preview{
    HomeView()
}
