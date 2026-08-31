import SwiftUI
//
//  Footer.swift
//  pomora
//
//  Created by Kimiko Low on 8/29/26.
//
//bottom tab bar with Home / Recipes / Profile buttons

struct Footer: View {
    //@Binding since footer is just reading/writing a val from RootView
    //tapping a button her updates RootView's selectedTab
    @Binding var selectedTab: Apptab
    
    var body: some View {
        // the buttons
        HStack {
            tabButton(tab: .home, icon: "house", label: "HOME") // home button
            Spacer()
            
            tabButton(tab: .search, icon: "magnifyingglass", label: "RECIPES") // search button
            Spacer()
            
            tabButton(tab: .profile, icon: "person", label: "PROFILE")
        }
        .padding(.horizontal, 40)
        .padding(.top, 14)
        .padding(.bottom, 0)
        .background(Color.background)
        .overlay(alignment: .top){
            Rectangle()
                .fill(Color.PGrey)
                .frame(height: 0.5)
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    // building the buttons so that it handles red/brown coloring and tap action
    @ViewBuilder
    private func tabButton(tab: Apptab, icon: String, label: String) -> some View{
        // isActive is recalculated everytime selected tab changes
        // this makes the red highight move to whatever tab we are on
        let isActive = selectedTab == tab
        
        Button {
            //tapping this button writes the new tab back into RootView's
            //selectedTab via binding
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(label)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .tracking(0.3)
            }
            //red when active tab, brown otherwise
            .foregroundStyle(isActive ? Color.PRed : Color.PBrown)
        }
        .buttonStyle(.plain)
    }
}
