//
//  FoodItemRow.swift
//  pomora
//
//  Created by Amanda Lee on 8/22/26.
//
import SwiftUI

// FoodItemRow
// Displays a single grocery item as a row on the Home screen: name, days until
// expiration, and a quantity stepper. The colored bar on the left and the days
// badge both turn red if the item is expiring soon, or green if it's still fresh.
// If the user decrements quantity down to 0, this row tells HomeView to remove
// the item entirely via the onQuantityZero callback.
struct FoodItemRow: View{
    // A binding (not just a value) so changes made here, like the quantity
    // stepper, write directly back into the real `items` array in HomeView,
    // instead of just updating a disconnected local copy.
    @Binding var item: GroceryItem
    
    // Callback fired when this item's quantity reaches 0, telling HomeView
    // to remove it from the list.
    var onQuantityZero: () -> Void
    
    var body : some View {
        HStack(spacing: 0){
            // Thin colored bar on the left edge: red if expiring soon, green if fresh.
            Rectangle()
                .fill(item.isExpiringSoon ? Color.PRed : Color.PDGreen)
                .frame(width: 4)
            
            VStack(alignment: .leading, spacing: 8){
                // Top row: item name (left) and "X DAYS" badge (right).
                HStack {
                    Text(item.name.uppercased())
                        .font(.title3.bold())
                        .foregroundColor(Color.PBrown)
                    Spacer()
                    // Badge color also reflects expiration status.
                    Text("\(item.daysUntilExpiration) DAYS")
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(item.isExpiringSoon ? Color(hex: "FFDBD5") : Color(hex: "D4E3C8"))
                        .foregroundColor(item.isExpiringSoon ? Color.PRed : Color.PDGreen)
                        .clipShape(Capsule())
                }
                
                // Bottom row: quantity stepper (- / count / +).
                HStack {
                    Stepper(value: $item.quantity, in: 0...99){
                        Text("\(item.quantity) ct")
                            .foregroundColor(Color.PBrown)
                    }
                    // Watches for quantity changes. If it hits 0, tell HomeView
                    // to remove this item from the list.
                    .onChange(of: item.quantity){ _, newValue in
                        if(newValue == 0){
                            onQuantityZero()
                        }
                    }
                }
            }
            .padding()
        }
        // Card styling: light gray background, thin border, rounded corners
        .background(Color(.systemGray6))
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal)
    }
}
