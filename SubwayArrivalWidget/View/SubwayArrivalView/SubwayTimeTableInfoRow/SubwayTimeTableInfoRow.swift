//
//  SubwayTimeTableInfoRow.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/03.
//

import SwiftUI

struct SubwayTimeTableInfoRow<ViewModel>: View where ViewModel: SubwayTimeTableInfoViewModelInterface {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        HStack {
            Text("\(viewModel.destination)행")
                .padding(.leading, 16)
            
            if viewModel.isExpress {
                Text("급행")
                    .foregroundColor(.red)
                    .font(.system(size: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.red, lineWidth: 0.3)
                            .frame(width: 28, height: 16)
                    }
            }
            
            Spacer()
            
            Text("\(viewModel.time)")
                .padding(.trailing, 16)
        }
    }
}
