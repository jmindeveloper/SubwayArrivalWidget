//
//  RealTimeArrivalInfoToggle.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/30.
//

import SwiftUI

struct RealTimeArrivalInfoToggle: View {
    @State var toggleOn: Bool = false
    @State var lineColor: Color
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Capsule()
                    .fill(Color(uiColor: .lightGray))
                
                HStack(spacing: 0) {
                    Text("실시간")
                        .font(.system(size: 12))
                        .frame(width: proxy.size.width / 2, height: proxy.size.height)
                        .onTapGesture {
                            toggleOn = false
                        }
                    
                    Text("시간표")
                        .font(.system(size: 12))
                        .frame(width: proxy.size.width / 2, height: proxy.size.height)
                        .onTapGesture {
                            toggleOn = true
                        }
                }
                
                HStack {
                    if toggleOn {
                        Spacer()
                    }
                    
                    RealTimeArrivalInfoToggleHighlight(lineColor: lineColor, toggle: $toggleOn)
                        .frame(width: proxy.size.width / 2, height: proxy.size.height)
                    
                    if !toggleOn {
                        Spacer()
                    }
                }
                .animation(.easeIn(duration: 0.1), value: toggleOn)
            }
        }
    }
}

struct RealTimeArrivalInfoToggleHighlight: View {
    @State var lineColor: Color
    @Binding var toggle: Bool
    
    var body: some View {
        ZStack {
            Capsule()
                .stroke(lineColor)
                .background { Capsule().fill(.white) }
            
            Text(toggle ? "시간표" : "실시간")
                .font(.system(size: 12))
                .foregroundColor(lineColor)
        }
    }
}

struct RealTimeArrivalInfoToggle_Previews: PreviewProvider {
    static var previews: some View {
        RealTimeArrivalInfoToggle(lineColor: .green)
            .frame(width: 80, height: 30)
            .previewLayout(.sizeThatFits)
    }
}
