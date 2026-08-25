//
//  HomeView.swift
//  pomora
//
//  Created by Amanda Lee on 8/22/26.
//
//TODO:
//text for 50% and 2 is too bold, change all text to pbrown
//add pomo logo
//adjust coloring
import SwiftUI

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct HomeView: View {
    @State private var showAddItemSheet = false
    @State private var items: [GroceryItem] = [
        GroceryItem(name: "Eggs", quantity: 6, daysUntilExpiration: 2),
        GroceryItem(name: "Oranges", quantity: 3, daysUntilExpiration: 3),
        GroceryItem(name: "Tomatoes", quantity: 3, daysUntilExpiration: 7),
        GroceryItem(name: "Carrots", quantity: 12, daysUntilExpiration: 8)
    ]
    
    @State private var scrollOffset: CGFloat = 0
    
    var expiringSoonCount: Int {
        items.filter { $0.isExpiringSoon }.count
    }
    
    var freshnessPercent: Int {
        guard !items.isEmpty else { return 0 }
        let freshCount = items.filter { !$0.isExpiringSoon}.count
        return Int((Double(freshCount) / Double(items.count)) * 100)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0){
                    VStack(spacing: 16){
                        HStack {
                            //figure out how to add logo instead
                            Text("pomo logo").font(.largeTitle)
                            Text("POMORA")
                                .font(.title2.bold())
                            Spacer()
                            Image(systemName: "line.3.horizontal")
                                .font(.title2)
                        }
                        
                        HStack {
                            Text("FRIDGE")
                                .font(.headline)
                            Spacer()
                            Text("\(items.count) items")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray5))
                                .clipShape(Capsule())
                        }
                        
                        HStack(spacing: 12) {
                            StatCard(icon: "leaf.fill", title: "FRESHNESS", value: "\(freshnessPercent)%", tint: .green)
                            StatCard(icon: "exclamationmark.triangle.fill", title: "EXPIRING SOON", value: "\(expiringSoonCount)", tint: .red)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    ScrollView {
                        VStack(spacing: 12){
                            if items.isEmpty {
                                Text("NO FOOD YET!")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 100)
                            }else{
                                ForEach($items) { $item in
                                    FoodItemRow(item: $item){
                                        withAnimation {items.removeAll { $0.id == item.id }}
                                    }
                                }
                            }
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 90)
                        .background(
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
                
                Button(action: {
                    showAddItemSheet = true
                }){
                    Text("ADD NEW ITEM")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.35, green: 0.4, blue: 0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
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
            .sheet(isPresented: $showAddItemSheet) {
                AddItemSheet { name, qty in
                    items.append(GroceryItem(name: name, quantity: qty, daysUntilExpiration: 7))
                }
                .presentationDetents([.height(590)])
                .presentationDragIndicator(.hidden)
            }
        }
    }
}

#Preview{
    HomeView()
}
