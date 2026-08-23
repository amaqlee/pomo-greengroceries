//
//  FoodItemRow.swift
//  pomora
//
//  Created by Amanda Lee on 8/22/26.
//
import SwiftUI

struct FoodItemRow: View{
    @State var item: GroceryItem
    
    var body : some View {
        HStack(spacing: 0){
            Rectangle()
                .fill(item.isExpiringSoon ? Color.red.opacity(0.7) : Color.green.opacity(0.7))
                .frame(width: 4)
            
            VStack(alignment: .leading, spacing: 8){
                HStack {
                    Text(item.name.uppercased())
                        .font(.title3.bold())
                    Spacer()
                    Text("\(item.daysUntilExpiration) DAYS")
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(item.isExpiringSoon ? Color.red.opacity(0.15) : Color.green.opacity(0.15))
                        .foregroundColor(item.isExpiringSoon ? .red : .green)
                        .clipShape(Capsule())
                }
                
                HStack {
                    Stepper(value: $item.quantity, in: 0...99){
                        Text("\(item.quantity) ct")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
}
