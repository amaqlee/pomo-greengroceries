//
//  StatCard.swift
//  pomora
//
//  Created by Amanda Lee on 8/22/26.
//

//reusable card on home page that shows stats like freshness and expiring soon
//icon, title, value(%), and colors are pass in
import SwiftUI

struct StatCard: View {
    //synbol shown at top of card
    let icon: String
    //small title labeling freshness/expiring soon
    let title: String
    //big percentage/number shown under
    let value: String
    //fill color
    let backgroundColor: Color
    //border color
    let borderColor: Color
    //font color
    let textColor: Color
    
    
    var body: some View { //the freshness/expiring %
        VStack(alignment: .leading, spacing: 8){
            Image(systemName: icon)
                .foregroundColor(textColor)
            Text(title)
                .font(.caption)
                .foregroundColor(textColor.opacity(0.85))
            Text(value)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(textColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(backgroundColor)
        //adds thin border
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
