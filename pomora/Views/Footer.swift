import SwiftUI
//
//  Footer.swift
//  pomora
//
//  Created by Kimiko Low on 8/29/26.
//
struct Footer: View {
    @Binding var selectedTab: Apptab
    
    var body: some View {
        // the buttons
        HStack {
            tabButton(tab: .home, icon: "house", label: "HOME") // home button
            Spacer()
            
            tabButton(tab: .search, icon: "search", label: "RECIPES") // search button
            Spacer()
            
            tabButton(tab: .profile, icon: "person", label: "PROFILE")
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 14)
        .background(Color.background)
    }
    
    // building the buttons so that it handles red/brown coloring and tap action
    @ViewBuilder
    private func tabButton(tab: Apptab, icon: String, label: String) -> some View{
        // isActive is recalculated everytime selected tab changes
        // this makes the red highight move to whatever tab we are on
        let isActive = selectedTab == tab
        
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(label)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .tracking(0.3)
            }
            .foregroundStyle(isActive ? Color.PRed : Color.PBrown)
        }
        .buttonStyle(.plain)
    }
}
