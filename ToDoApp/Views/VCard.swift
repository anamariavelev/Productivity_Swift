//
//  VCard.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 23.04.2024.
//

import SwiftUI

struct VCard: View {
    @Environment(\.colorScheme) var colorScheme  // Environment property to detect theme mode

    var themeColor: Color {
        colorScheme == .light ? .green : .orange
    }
    
    let title: String
    let description: String
    let color: Color
    let textColor: Color

    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(textColor)
                            .padding(.bottom, 5)
                        
                        
                        
                    }
                    Spacer()
                }
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .background(themeColor.opacity(0.2)) // Set background color with opacity
            .cornerRadius(10)
            .frame(width: 350, height: 150) // Set a fixed size for the VCard
            
            Rectangle()
                .stroke(themeColor, lineWidth: 3) // Outline with green/orange depending on theme
                .frame(width: 352, height: 112)
                .cornerRadius(10)
        }
    }
}



#if DEBUG
struct ClassifyForMeView_Previews: PreviewProvider {
    static var previews: some View {
        @Environment(\.colorScheme) var colorScheme  // Environment property to detect theme mode

        var themeColor: Color {
            colorScheme == .light ? .green : .orange
        }
        
        VCard(title: "Title", description: "Description", color: themeColor, textColor: .primary)
    }
}
#endif
