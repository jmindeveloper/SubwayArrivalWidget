//
//  RealTimeArrivalInfoToggle.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/30.
//

import SwiftUI

struct RealTimeArrivalInfoToggle: View {
    @Binding var toggle: Bool
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
                            toggle = true
                        }
                    
                    Text("시간표")
                        .font(.system(size: 12))
                        .frame(width: proxy.size.width / 2, height: proxy.size.height)
                        .onTapGesture {
                            toggle = false
                        }
                }
                
                HStack {
                    if !toggle {
                        Spacer()
                    }
                    
                    RealTimeArrivalInfoToggleHighlight(lineColor: lineColor, toggle: $toggle)
                        .frame(width: proxy.size.width / 2, height: proxy.size.height)
                    
                    if toggle {
                        Spacer()
                    }
                }
                .animation(.easeIn(duration: 0.1), value: toggle)
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
            
            Text(toggle ? "실시간" : "시간표")
                .font(.system(size: 12))
                .foregroundColor(lineColor)
        }
    }
}
