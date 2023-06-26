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
        NavigationView {
            VStack {
                TextField("검색", text: $viewModel.searchSubwayStationName)
                    .textFieldStyle(.roundedBorder)
                    .focused($searchBarFocused)
                    .padding()
                
                stationList()
            }
            .navigationTitle("역정보")
//            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private func stationList() -> some View {
        List {
            if viewModel.searchSubwayStationName.isEmpty ||
                viewModel.searchStationList.isEmpty {
                ForEach(viewModel.allStationList, id: \.self) { station in
                    NavigationLink(station.stationName) {
                        SubwayArrivalView(subwayName: station.stationName)
                    }
                }
            } else {
                ForEach(viewModel.searchStationList, id: \.self) { station in
                    NavigationLink(station.stationName) {
                        SubwayArrivalView(subwayName: station.stationName)
                    }
                }
            }
        }
    }
}

//@available(iOS 17, *)
//#Preview {
//    SearchSubwayStation(viewModel: SearchSubwayStationViewModel())
//}
