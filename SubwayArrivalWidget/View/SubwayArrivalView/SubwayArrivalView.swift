//
//  SubwayArrivalView.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/26.
//

import SwiftUI

struct SubwayArrivalView<ViewModel>: View where ViewModel: SubwayArrivalViewModelInterface {
    @State var station: Station
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                stationInfoCapsuleView()
                
                VStack {
                    HStack {
                        Divider()
                        
                        Button {
                            // TODO: - 즐겨찾기 버튼
                        } label: {
                            Image(systemName: "star")
                                .resizable()
                                .foregroundColor(.yellow)
                                .frame(width: 45, height: 45)
                        }
                        
                        Divider()
                    }
                    .frame(height: 45)
                    
                    RealTimeArrivalInfoToggle(lineColor: station.lineNum.lineColor ?? .black)
                        .frame(width: 80, height: 30)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(station.lineNum.lineColor ?? Color(uiColor: .label))
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(alignment: .bottom, spacing: 2) {
                        Text(station.stationName)
                            .font(.title)
                        Text(station.lineNum.str)
                            .foregroundColor(station.lineNum.lineColor)
                    }
                }
            }
        }
        .onAppear {
            viewModel.getSubwayArrivalData(station.stationName)
        }
    }
    
    @ViewBuilder
    private func stationInfoCapsuleView() -> some View {
        ZStack {
            Capsule()
                .fill(station.lineNum.lineColor ?? .white)
                .frame(width: 120, height: 50)
            Capsule()
                .fill(.white)
                .frame(width: 110, height: 40)
            HStack {
                Text(String(station.lineNum.str.first ?? " "))
                    .foregroundColor(.white)
                    .background {
                        Circle()
                            .fill(station.lineNum.lineColor ?? .black)
                            .frame(width: 21, height: 21)
                    }
                
                Text(station.stationName)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.leading, 3)
            }
        }
    }
}
