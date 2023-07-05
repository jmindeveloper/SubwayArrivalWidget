//
//  StationFavoriteView.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/05.
//

import SwiftUI

struct StationFavoriteView: View {
    var body: some View {
        NavigationView {
            Text("Hello, SwiftUi!!")
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
    }
}
