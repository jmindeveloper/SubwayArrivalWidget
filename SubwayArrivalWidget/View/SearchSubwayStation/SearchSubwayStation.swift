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
    @State private var selectedStation: Station?
    
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
        }
    }
    
    @ViewBuilder
    private func stationList() -> some View {
        List {
            if viewModel.searchSubwayStationName.isEmpty ||
                viewModel.searchStationList.isEmpty {
                ForEach(viewModel.lineNumbers, id: \.self) { lineNum in
                    Section {
                        ForEach(viewModel.allStationList[lineNum] ?? [], id: \.self) { station in
                            Button {
                                selectedStation = station
                            } label: {
                                SubwayStationInfoView(subwayName: station.stationName, lineNumber: station.lineNum)
                            }
                        }
                    } header: {
                        Text(lineNum)
                    }
                }
                .fullScreenCover(item: $selectedStation) { station in
                    SubwayArrivalView(station: station, viewModel: SubwayArrivalViewModel())
                }
            } else {
                ForEach(viewModel.lineNumbers, id: \.self) { lineNum in
                    Section {
                        ForEach(viewModel.searchStationList[lineNum] ?? [], id: \.self) { station in
                            Button {
                                selectedStation = station
                            } label: {
                                SubwayStationInfoView(subwayName: station.stationName, lineNumber: station.lineNum)
                            }
                        }
                    } header: {
                        Text(lineNum)
                    }
                }
                .fullScreenCover(item: $selectedStation) { station in
                    SubwayArrivalView(station: station, viewModel: SubwayArrivalViewModel())
                }
            }
        }
    }
}

//@available(iOS 17, *)
//#Preview {
//    SearchSubwayStation(viewModel: SearchSubwayStationViewModel())
//}
