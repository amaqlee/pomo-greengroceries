//
//  NavDrawer.swift
//  pomora
//
//  Created by Kimiko Low on 8/26/26.
//

import SwiftUI

struct DrawerMenuItem: Identifiable {
    let id = UUID()  // unique ID auto-generated for each item
    let title: String   // text shown nex to the icon, e.g. "ABOUT"
    let systemImage: String   // SF Symbols icon name, e.g "info.cirle"
}

// ViewModifier is what allows us to have the nav drawer show up over any exisiting string that
// attach .withNavigationDrawer to
// TODO: - HomeView needs some edits for this to work as intended
//      1. add '@State private var showDrawer = false' near other @State vars
//      2. Wrap its exisiting hamburger image in a button that does
//         'withAnimation(.easeInOut(duration: 0.25)) { showDrawer.toggle() }'
//      3. Add '.navigationDrawerOverlay(isOpen: $showDrawer)' onto the outer ZStack,
//         alongside its existing .sheed(..) and .navigationBarHidden(true).
struct NavigationDrawerOverlay: ViewModifier {
    // tells us if the drawer is open
    @Binding var isOpen: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            // layer 1: whatever screen called .withNavigationDrawer()
            
            // layer 2: the middle aka the tap-to-dismiss overlay
            if isOpen {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture {  // makes it so that when you tap outside of drawer it closes
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isOpen = false
                        }
                    }
            }
            
            // layer 3: the sliding draer panel
            if isOpen {
                NavigationDrawerView(isOpen: $isOpen)
                    .frame(width: 320)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
    }
}

extension View {
    func navigationDrawerOverla(isOpen: Binding<Bool>) -> some View {
        modifier(NavigationDrawerOverlay(isOpen: isOpen))
    }
}

struct NavigationDrawerModifer: ViewModifier {
    @State private var isDrawerOpen = false
    
    // SwiftUI calls this automatically and hands us the view the modifer was attached
    // to as "content" - whatever screen was underneath
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            // layer 1: whatever screen called .withNavigationDrawer()
            
            // layer 2: dimmer overlay - same as above
            if isDrawerOpen {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isDrawerOpen = false
                        }
                    }
            }
            
            // layer 3: the sliding panel
            if isDrawerOpen {
                NavigationDrawerView(isOpen: $isDrawerOpen)
                    .frame(width: 320)
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
    }
}

extension View {
    func navigationDrawerOverlap(isOpen: Binding<Bool>) -> some View {
        modifier(NavigationDrawerOverlay(isOpen: isOpen))
    }
}

// drawer content
// this is the actual content of the drawer
// just needs a binding to isOpen so buttons in side it like [Sign Out] could close the drawer
struct NavigationDrawerView: View {
    @Binding var isOpen: Bool //shares same value as showDrawer in whichever screen presents this
    
    //3 menu rows shown in the drawer
    private let menuItems: [DrawerMenuItem] = [
        DrawerMenuItem(title: "ABOUT", systemImage: "info.circle"),
        DrawerMenuItem(title: "SHOPPING LIST", systemImage: "cart"),
        DrawerMenuItem(title: "TRENDS", systemImage: "chart.line.uptrend.xyaxis")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {  // stacks everything vertically and makes it left aligned
            // top of nav drawer  (avatar + username)
            HStack(spacing: 14) {
                ZStack {  // layers the circle backgroun behind the avatar
                    Circle()
                        .fill(Color.background)
                        .frame(width: 44, height: 44)
                        .overlay(Circle().stroke(Color.black.opacity(0.25), lineWidth: 1))
                    Image("PomoLogo") // idk if this actually works the way we want it to, just thought i'd try
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .padding()
                }
                Text("@pomothetoemo") // placeholder username, replace later with real user data
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.PBrown)
                Spacer() // pushes everything else to the left, fills remaining space
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            .padding(.bottom, 20)
            
            // the think horizontal line separating the (avatar + username) from the menu items
            Divider()
                .overlay(Color.PGrey)
                .padding(.horizontal, 24)
            
            
            // list of buttons in nav drawer
            VStack(alignment: .leading, spacing: 4) {
                // for each loop goes through the array we made earlier and builds a row with buttons for each item
                ForEach(menuItems) { item in
                    Button {
                        // TODO: navigate to the relevant screen based on item.title
                        // e.g. if item.title == "ABOUT" {...go to ABOUT screen...}
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: item.systemImage)
                                .font(.system(size: 17, weight: .regular))
                                .frame(width: 22) // fixed width keeps icons aligned in a column
                                .foregroundStyle(Color.PBrown)
                            Text(item.title)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .tracking(0.4) //slightly spaces out letters --> do we want this? claude did it
                                .foregroundStyle(Color.PBrown)
                            Spacer()  // makes the whole row tappable not just the text
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                    }
                    .buttonStyle(.plain) // removes the default blue button tint/highlighting
                                         // that way it just looks likea normal row of text rather than a button
                }
            }
            .padding(.top, 12)
            
            Spacer() // expands to fill all remaining vertical space, pushing sign out button to bottom of drawer
            
            // SIGN OUT BUTTON
            Divider()
                .overlay(Color.PGrey)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            
            Button {
                // TODO: hookup actual signout logic here
                // e.g. clear session, then optonally isOpen = false
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "rectangle.portrait.and.arrow.right") // logout icon
                        .font(.system(size: 14, weight: .semibold))
                    Text("SIGN OUT")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .tracking(0.5)
                }
                .foregroundStyle(Color.background)
                .frame(maxWidth: .infinity) // on a full width button
                .padding(.vertical, 14)
                .background(Color.PDGreen) // fill button with PDGreen
                .clipShape(RoundedRectangle(cornerRadius: 10))  // make button rounded
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
        }
        .frame(maxHeight: .infinity) // makes drawer stretch the full screen height
        .background(Color.background)
    }
}
