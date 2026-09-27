//
//  AboutView.swift
//  pomora
//
//  Created by Kimiko Low on 9/21/26.
//

//  The About page inside the nav drawer
//  discusses why we created the app and what it hopes to achieve

import SwiftUI

struct AboutView: View {
    // lets us close this screen and return to whatever was showing before
    @Environment(\.dismiss) private var dismiss

    @State private var selectedTab: Apptab = .home
    @State private var showDrawer = false

    var body: some View {
        VStack(spacing: 0) {

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {

                    //  the "Our Mission" label/header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Our Mission")
                            .font(.subheadline)
                            .foregroundColor(Color.PBrown.opacity(0.6))
                        Divider()
                            .overlay(Color.PGrey)
                    }

                    // the big head line with our mission statement
                    Text(
                        "Bridging the gap between \(Text("beauty").foregroundColor(Color.PDGreen)) and \(Text("utility").foregroundColor(Color.PRed)) in your kitchen."
                    )
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color.PBrown)
                        // lets the multi-line headline wrap naturally instead of
                        // getting squeezed/truncated
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("We believe that managing your groceries shouldn’t be a chore. It should be a mindful practice that reduces food waste, inspired culinary creativity, and brings calm order to your home.")
                        .font(.body)
                        .foregroundColor(Color.PBrown.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical, 10)
                    
                    // image + the cause card
                    VStack(alignment: .leading, spacing: 12) {
                        // TOOD: fix the placeholder by putting an actual image of the tomato
                        Image("TomatoesWashing")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 220)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Text("The Cause")
                            .font(.title3.bold())
                            .foregroundColor(Color.PBrown)
                        
                        Text("Every year, millions of tons of perfectly good food are discarded simply because they were forgotten at the back of the fridge. Pomora acts as your digital memory, bringing visibility to your inventory so you can respect the resources that nourish you.")
                            .font(.body)
                            .foregroundColor(Color.PBrown.opacity(0.85))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.PGrey, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
        }
        .background(Color.background.ignoresSafeArea())
        .navigationDrawerOverlay(isOpen: $showDrawer, selectedTab: $selectedTab)
        
        .onChange(of: selectedTab) { _, _ in
                    dismiss()
        }
    }
}
