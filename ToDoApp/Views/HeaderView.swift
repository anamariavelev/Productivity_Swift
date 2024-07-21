//
//  HeaderView.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    let angle: Double
    let background: Color
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(background)
                .rotationEffect(Angle(degrees: angle))
            
            VStack{
                Text(title)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .bold()
                    .offset(x:5, y:-5)
                Text(subtitle)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .offset(x:5, y:-5)

            }
            .padding(.top, 10)
        }
        .frame(width: UIScreen.main.bounds.width * 3, height: 150)
        .offset(y:-65)
    }
}

#Preview {
    HeaderView(title: "To Do List", subtitle: "Get things done", angle: -15, background: .pink)
}
