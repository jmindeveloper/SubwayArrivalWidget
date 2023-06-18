//
//  ContentView.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/18.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    var body: some View {
        VStack {
            Button {
                
            } label: {
                Text("+")
                    .font(.system(size: 70))
            }
            .frame(width: 100, height: 100, alignment: .center)
        }
        .padding()
    }
}

@available(iOS 17, *)
#Preview {
    ContentView()
}
