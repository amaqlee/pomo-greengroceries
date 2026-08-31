//
//  RootView.swift
//  pomora
//
//  Created by Amanda Lee on 8/30/26.
//

//outer shell of whole app
//shows the shared header at top and footer at bottom on every tab
//swaps out middle section depending on which tab is selected

import SwiftUI

struct RootView: View {
    //state that needs to be shared across multiple views
    //both header + footer need to know/change which tab is selected
    //header: tapping logo jumps to .home
    //footer:tapping hom/recipes/profile switches tabes
    //pass down as a @Binding (use $ prefix, ex. $selectedTab) so changes made wirte back up to this var
    @State private var selectedTab: Apptab = .home
    
    //similar var to the nav drawer
    //button opens the drawer and drawer overlay needs to know whether it should be shown
    @State private var showDrawer: Bool = false
    
    var body: some View {
        //v(ertical) stack: stacks children top to bottom
        //spacing: 0 means no gap between header / content / foot, so they
        //sit flush w each other instead of having a visible seam
        VStack(spacing: 0){
            //shared header component
            //pass in $selectedTab and $showDrawer as BINDINGS (not just vals)
            //binding: two way pip, if Header changes electedTab internall, that change
            //flows back and updates RootView's copy too, vice versa
            Header(selectedTab: $selectedTab, showDrawer: $showDrawer)
            
            tabContent
                //maxWidth/Height: infinity - middle section expand and fill all leftover
                //vertical space between header and foot
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Footer(selectedTab: $selectedTab)
            
        }
        
        //fills whole screen w background color, so no white shows up
        .background(Color.background.ignoresSafeArea())
        //wraps everyting (header + content + footer) in zstack + slides drawer
        // on top of all when showDrawer becomes true
        .navigationDrawerOverlay(isOpen: $showDrawer)
    }
    
    //@ViewBuilder lets the computed property return SwiftUI view syntax
    @ViewBuilder
    private var tabContent: some View {
        //different cases for each tab
        switch selectedTab {
        case .home:
            //fridge screen, manages own grocery list state internally
            HomeView()
        case .search:
            //not built yet, placeholder so tapping tab isn't broken
            TabPlacedholderView(title: "RECIPES", systemImage: "magnifyingglass")
        case .profile:
            TabPlacedholderView(title: "PROFILE", systemImage: "person")
        }
    }
    
    //placeholder screen for tabs w/o content yet
    struct TabPlacedholderView: View {
        let title: String
        let systemImage: String
        
        var body: some View{
            VStack(spacing: 12){
                Image(systemName: systemImage)
                    .font(.system(size: 40))
                    .foregroundColor(Color.PBrown.opacity(0.4))
                Text("\(title) COMING SOON")
                    .font(.headline)
                    .foregroundColor(Color.PBrown.opacity(0.6))
            }
            //centers placeholder content in whatever space available
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }
    }
}

//Lets you preview in XCode's canvas w/o running whole app

#Preview {
    RootView()
}
