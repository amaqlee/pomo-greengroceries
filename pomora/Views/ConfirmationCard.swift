//
//  ConfirmationCard.swift
//  pomora
//
//  Created by Kimiko Low on 9/30/26.
//

// a generic "are you sure?" popup that matches the style of DeleteConfirmationCard
// TODO: decide whether this file is only used for deleting shopping list or more
// TODO: discuss with Amanda whether this should be combined with DeleteConfirmationCard or not

import SwiftUI

struct ConfirmationCard: View {
    // main heading -> "are you sure?"
    let title: String
    // body text -> explains consequence of clearing list
    let message: String
    // text on the delete button (e.g. "clear list")
    let confirmLabel: String
    
    // called when user selects cancel or dimmed backgroun AKA anywhere but the card
    var onCancel: () -> Void
    // called when user taps the confirm button
    var onConfirm: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color.PBrown)
            
            Text(message)
                .font(.body)
                .foregroundColor(Color.PBrown.opacity(0.85))
                // lets message wrap across many lines instead of cuttong off
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(spacing: 12) {
                Spacer()
                Button(action: onCancel) {
                    Text("CANCEL")
                        .font(.subheadline.bold())
                        .foregroundColor(Color.PBrown)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.PGrey)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.PGrey, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                
                Button(action: onConfirm) {
                    Text(confirmLabel)
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
        // caps how large the card can get on wider screens
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
    ConfirmationCard(
        title: "Clear entire list?",
        message: "This will remove all 4 items, checked and unchecked.",
        confirmLabel: "CLEAR LIST",
        onCancel: {},
        onConfirm: {}
    )
}
