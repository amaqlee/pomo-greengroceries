//
//  DeleteConfirmationCard.swift
//  pomora
//
//  Created by Amanda Lee on 8/31/26.
//

//are you sure you want to delte
//used by homeview when a FootItemRow's X button is tapped

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
        VStack(spacing: 16){
            Text("Remove item?")
                .font(.headline)
                .foregroundColor(Color.PBrown)
            
            Text("This will remove \u{201C}\(itemName)\u{201D} from your fridge.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.PBrown.opacity(0.75))
            
            //cancel + delete buttons side by side
            HStack(spacing: 12){
                Button(action: onCancel){
                    Text("CANCEL")
                        .font(.subheadline.bold())
                        .foregroundColor(Color.PBrown)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
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
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.PRed)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(24)
        //caps how wide card gets on larger screens
        .frame(maxWidth: 300)
        .background(Color.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.PGrey, lineWidth: 1)
        )
    }
}
