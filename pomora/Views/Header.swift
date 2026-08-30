import SwiftUI
//
//  Header.swift
//  pomora
//
//  this is the header that will appear above almost every screen
//
//  Created by Kimiko Low on 8/29/26.
//
struct Header: View {
    @Binding var selectedTab: Apptab
    @Binding var showDrawer: Bool
    
    var body: some View {
        HStack {
            // making it so that the logo + POMORA text are one button that can take you to home page
            Button {
                selectedTab = .home
            } label:  {
                HStack(spacing: 10) {
                    Image("PomoLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                    Text("POMORA")
                        .font(.title2.bold())
                        .foregroundStyle(Color.PBrown)
                }
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // nav drawer button (three lines)
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    showDrawer.toggle()
                }
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundStyle(Color.PBrown)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 14)
        .background(Color.background)
    }
}
