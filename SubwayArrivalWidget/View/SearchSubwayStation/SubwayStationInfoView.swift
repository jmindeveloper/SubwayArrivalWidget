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
                .foregroundColor(Color(uiColor: .label))
            
            Text(lineNumber.str)
                .font(.system(size: 13))
                .foregroundColor(lineNumber.lineColor)
        }
        .padding(.vertical, 1)
    }
}
