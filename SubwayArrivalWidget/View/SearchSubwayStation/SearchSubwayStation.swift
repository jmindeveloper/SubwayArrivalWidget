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
                            ZStack {
                                NavigationLink(
                                    destination: SubwayArrivalView(subwayName: station.stationName)) {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                    .buttonStyle(.plain)
                                
                                HStack {
                                    SubwayStationInfoView(subwayName: station.stationName, lineNumber: station.lineNum)
                                    Spacer()
                                }
                            }
                        }
                    } header: {
                        Text(lineNum)
                    }
                }
            } else {
                ForEach(viewModel.lineNumbers, id: \.self) { lineNum in
                    Section {
                        ForEach(viewModel.searchStationList[lineNum] ?? [], id: \.self) { station in
                            ZStack {
                                NavigationLink(
                                    destination: SubwayArrivalView(subwayName: station.stationName)) {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                    .buttonStyle(.plain)
                                
                                HStack {
                                    SubwayStationInfoView(subwayName: station.stationName, lineNumber: station.lineNum)
                                    Spacer()
                                }
                            }
                        }
                    } header: {
                        Text(lineNum)
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
