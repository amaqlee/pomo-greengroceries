//
//  StatCard.swift
//  pomora
//
//  Created by Amanda Lee on 8/22/26.
//

import SwiftUI

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let tint: Color
    
    var body: some View { //the freshnes/expiring %
        VStack(alignment: .leading, spacing: 8){
            Image(systemName: icon)
                .foregroundColor(tint)
            Text(title)
                .font(.caption.bold())
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 34, weight: .bold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(tint.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
