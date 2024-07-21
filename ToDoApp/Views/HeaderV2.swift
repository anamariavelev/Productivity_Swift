//
//  HeaderV2.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 23.04.2024.
//

import SwiftUI

struct HeaderV2: View {
    var title: String
    var subtitle: String
    
    @Environment(\.colorScheme) var colorScheme  // Environment property to detect theme mode

    var themeColor: Color {
        colorScheme == .light ? .green : .orange
    }
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(themeColor.opacity(0.2))
                    .frame(width: UIScreen.main.bounds.width, height: 120)
                    .offset(y: -50)

                Rectangle()
                    .foregroundColor(themeColor)
                    .frame(height: 2)
                    .offset(y: -100)
                    .rotationEffect(Angle(degrees: 0))

                Rectangle()
                    .foregroundColor(themeColor)
                    .frame(height: 2)
                    .offset(y: 0)
                    .rotationEffect(Angle(degrees: 0))

                VStack {
                    Text(title)
                        .font(.system(size: 30))
                        .foregroundColor(.primary)
                        .bold()
                        .offset(x: 5, y: -55)
                    Text(subtitle)
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                        .offset(x: 5, y: -55)
                }
                .padding(.top, 10)
            }
            .offset(y: -50)
        }
    }


#Preview {
    HeaderV2(title: "title", subtitle: "subtitle")
}
