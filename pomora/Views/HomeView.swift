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

struct HomeView: View {
    @State private var showAddItemSheet = false
    @State private var items: [GroceryItem] = [
        GroceryItem(name: "Eggs", quantity: 6, daysUntilExpiration: 2),
        GroceryItem(name: "Oranges", quantity: 3, daysUntilExpiration: 3),
        GroceryItem(name: "Tomatoes", quantity: 3, daysUntilExpiration: 7),
        GroceryItem(name: "Carrots", quantity: 12, daysUntilExpiration: 8)
    ]
    
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
            ScrollView {
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
                    .padding(.horizontal)
                    
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
                    .padding(.horizontal)
                    
                    HStack(spacing: 12) {
                        StatCard(icon: "leaf.fill", title: "FRESHNESS", value: "\(freshnessPercent)%", tint: .green)
                        StatCard(icon: "exclamationmark.triangle.fill", title: "EXPIRING SOON", value: "\(expiringSoonCount)", tint: .red)
                    }
                    .padding(.horizontal)
                    
                    if items.isEmpty {
                        Text("NO FOOD YET!")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.top, 100)
                    }else{
                        ForEach(items) { item in
                            FoodItemRow(item: item)
                        }
                    }
                    
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
                }
            }
        }
        .sheet(isPresented: $showAddItemSheet) {
            AddItemSheet { name, qty in
                items.append(GroceryItem(name: name, quantity: qty, daysUntilExpiration: 7))
            }
            .presentationDetents([.height(500), .large])
            .presentationDragIndicator(.hidden)
        }
    }
}

#Preview{
    HomeView()
}
