//
//  SearchSubwayStation.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/18.
//

import SwiftUI

struct SearchSubwayStation<ViewModel>: View where ViewModel: SearchSubwayStationViewModelInterface {
    
    @ObservedObject var viewModel: ViewModel
    @FocusState private var searchBarFocused: Bool
    
    var body: some View {
        VStack {
            TextField("검색", text: $viewModel.searchSubwayStationName)
                .textFieldStyle(.roundedBorder)
                .focused($searchBarFocused)
                .padding()
            
            Spacer()
        }
        .onTapGesture {
            searchBarFocused = false
        }
    }
}

@available(iOS 17, *)
#Preview {
    SearchSubwayStation(viewModel: SearchSubwayStationViewModel())
}
