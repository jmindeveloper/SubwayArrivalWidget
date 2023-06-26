//
//  SubwayArrivalView.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/26.
//

import SwiftUI

struct SubwayArrivalView: View {
    @State var subwayName: String
    
    var body: some View {
        VStack {
            Text("아메리카노")
        }
        .navigationTitle(Text(subwayName))
        .navigationBarTitleDisplayMode(.inline)
    }
}
