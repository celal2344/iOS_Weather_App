//
//  weatherButton.swift
//  celalTest1
//
//  Created by Eminullah Yaşar on 3.10.2023.
//

import Foundation
import SwiftUI

struct weatherButton: View{
    var title: String
    var textColor: Color
    var backgroundColor: Color
    
    var body: some View{
        Text(title)
            .frame(width: 280, height: 50)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.system(size: 20,weight:.bold,design:.default))
            .cornerRadius(10)
    }
}
