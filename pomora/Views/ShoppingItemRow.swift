//
//  ShoppingItemRow.swift
//  pomora
//
//  Created by Kimiko Low on 9/26/26.
//

// One row in the shopping list: tappable checkbox + item name + quantity
// once checkbox has been checked, entire row will be slashed through with line

import SwiftUI

struct ShoppingItemRow: View {
    // Binding so that tapping checkbox writes back to the real 'items' list
    // in the shoppinglistview
    @Binding var item: ShoppingItem
    
    var body: some View {
        HStack(spacing: 14) {
            // checkbox - tapping toggles isChecked --> fills box and slashes through
            Button {
                item.isChecked.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.PGrey, lineWidth: 1.5)
                // when checked the box becomes solid
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(item.isChecked ? Color.PDGreen : Color.clear)
                    )
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
            
            Text(item.name)
                .font(.body)
                .foregroundColor(Color.PBrown)
            // the slashed line
                .strikethrough(item.isChecked, color: Color.PBrown)
            // dims the text of the slashed/checked items
                .opacity(item.isChecked ? 0.5 : 1.0)
            
            Spacer()
            
            Text("\(item.quantity)")
                .font(.body)
                .foregroundColor(Color.PBrown.opacity(0.7))
        }
        .padding(.vertical, 12)
    }
}
