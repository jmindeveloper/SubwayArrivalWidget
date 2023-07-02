//
//  BottomLabelImageButton.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/30.
//

import SwiftUI

struct BottomLabelImageButton: View {
    var imageName: String = ""
    var labelText: String = ""
    var imageColor: Color = .black
    var textColor: Color = .black
    var action: (() -> Void) = { }
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Image(systemName: imageName)
                    .foregroundColor(imageColor)
                
                Text(labelText)
                    .foregroundColor(textColor)
                    .padding(.top, 3)
            }
        }
    }
    
    func imageColor(_ color: Color) -> BottomLabelImageButton {
        return BottomLabelImageButton(imageName: imageName, labelText: labelText, imageColor: color, textColor: textColor, action: action)
    }
    
    func textColor(_ color: Color) -> BottomLabelImageButton {
        return BottomLabelImageButton(imageName: imageName, labelText: labelText, imageColor: imageColor, textColor: color, action: action)
    }
    
    func image(_ name: String) -> BottomLabelImageButton {
        return BottomLabelImageButton(imageName: name, labelText: labelText, imageColor: imageColor, textColor: textColor, action: action)
    }
    
    func text(_ text: String) -> BottomLabelImageButton {
        return BottomLabelImageButton(imageName: imageName, labelText: text, imageColor: imageColor, textColor: textColor, action: action)
    }
    
    func action(_ action: @escaping (() -> Void)) -> BottomLabelImageButton {
        return BottomLabelImageButton(imageName: imageName, labelText: labelText, imageColor: imageColor, textColor: textColor, action: action)
    }
}
