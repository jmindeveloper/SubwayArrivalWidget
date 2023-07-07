//
//  StationBookMarkView.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/05.
//

import SwiftUI
import Combine

struct StationBookMarkView<ViewModel>: View where ViewModel: StationBookMarkViewModelInterface {
    @ObservedObject var viewModel: ViewModel
    @State private var selectedStation: Station?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.lineNumbers, id: \.self) { lineNum in
                    Section {
                        ForEach(viewModel.favoriteStationList[lineNum] ?? [], id: \.self) { station in
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
                    SubwayArrivalView(viewModel: SubwayArrivalViewModel(station: station))
                }
            }
            .navigationTitle("즐겨찾기")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SearchSubwayStationView(viewModel: SearchSubwayStationViewModel())
                    } label: {
                        Text("전체역 보기")
                            .foregroundColor(Color(uiColor: .label))
                    }
                }
            }
        }
        .onAppear {
            viewModel.getFavoriteStations()
        }
    }
}

protocol StationBookMarkViewModelInterface: ObservableObject {
    var lineNumbers: [String] { get set }
    var favoriteStationList: [String: [Station]] { get set }
    
    func getFavoriteStations()
}

final class StationBookMarkViewModel: StationBookMarkViewModelInterface {
    @Published var lineNumbers: [String] = []
    @Published var favoriteStationList: [String : [Station]] = [:]
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        binding()
    }
    
    private func binding() {
        StationBookMark.chaingeStationBookMarkListPublisher
            .sink { [weak self] in
                self?.getFavoriteStations()
            }.store(in: &subscriptions)
    }
    
    func getFavoriteStations() {
        let bookMarks = StationBookMark.getStationBookMark()
        favoriteStationList = splitToLineNum(stations: bookMarks)
    }
    
    private func splitToLineNum(stations: [Station]) -> [String: [Station]] {
        var dic: [String: [Station]] = [:]
        for station in stations {
            let lineNum = station.lineNum.str
            if var stations = dic[lineNum] {
                stations.append(station)
                dic[lineNum] = stations
            } else {
                dic[lineNum] = [station]
            }
        }
        lineNumbers = dic.keys.sorted()
        return dic
    }
}
