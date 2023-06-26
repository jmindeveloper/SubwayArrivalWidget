//
//  SubwayStationInfoView.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/26.
//

import SwiftUI

struct SubwayStationInfoView: View {
    @State var subwayName: String
    @State var lineNumber: LineNum
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(subwayName)
            
            Text(lineNumber.str)
                .font(.system(size: 13))
                .foregroundColor(lineNumber.lineColor)
        }
    }
}
