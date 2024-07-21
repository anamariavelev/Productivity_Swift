//
//  TLButtonView.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 19.02.2024.
//

import SwiftUI

struct TLButtonView: View {
    
    let title: String
    let background: Color
    let action: ()-> Void
    
    var body: some View {
        Button{
            action()
        }label:{
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    //.size(width: 320, height: 35)
                    .foregroundColor(background)
                Text(title)
                    .bold()
                    .foregroundColor(.white)
                    
            }
        }
        .padding(8)
    }
}

#Preview {
    TLButtonView(title: "Value", background: .blue){
        
    }
}
