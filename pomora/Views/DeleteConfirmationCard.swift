//
//  DeleteConfirmationCard.swift
//  pomora
//
//  Created by Amanda Lee on 8/31/26.
//

//Generates an confirmation popup to delete a grocery item.
//Used by homeview when a FootItemRow's X button is tapped

import SwiftUI

struct DeleteConfirmationCard: View {
    //name of item being considered for deletion
    //shown in message, so user can double check
    let itemName: String
    
    //Called when the user taps CANCEL (or dimmed background)
    var onCancel: () -> Void
    
    //Called when the user taps DELETE, notifies HomeView to delete
    var onDelete: () -> Void
    
    
    var body: some View {
        //alignment: .leading so title and body are left aligned
        VStack(alignment: .leading, spacing: 20){
            Text("Remove item?")
                .font(.headline)
                .foregroundColor(Color.PBrown)
            
            Text("This will remove \(Text(itemName).bold()) from your fridge.")
                .font(.body)
                .foregroundColor(Color.PBrown.opacity(0.85))
                //lets text wrap across multiple lines
                .fixedSize(horizontal: false, vertical: true)
            
            //cancel + delete buttons side by side
            HStack(spacing: 12){
                Spacer()
                Button(action: onCancel){
                    Text("CANCEL")
                        .font(.subheadline.bold())
                        .foregroundColor(Color.PBrown)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.PLGrey)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.PGrey, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                
                Button(action: onDelete){
                    Text("REMOVE")
                        .font(.subheadline.bold())
                        .foregroundColor(Color.background)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.PDRed)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(28)
        //caps how wide card gets on larger screens
        .frame(maxWidth: 340)
        .background(Color.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.PGrey, lineWidth: 1)
        )
    }
}

#Preview {
    DeleteConfirmationCard(itemName: "Pasture Eggs", onCancel: {}, onDelete: {})
}
