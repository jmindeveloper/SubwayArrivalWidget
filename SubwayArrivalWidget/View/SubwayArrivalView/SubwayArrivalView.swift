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
    @State private var isUp: Bool = true
    
    @State private var isSave: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(height: 40)
                
                stationInfoCapsuleView()
                
                Divider()
                    .frame(width: UIScreen.main.bounds.width * 0.93)
                    .padding(.bottom, 10)
                
                menu()
                    .frame(height: 60)
                
                Rectangle()
                    .fill(Color(uiColor: .systemGray6))
                    .frame(width: UIScreen.main.bounds.width, height: 14)
                
                HStack(alignment: .bottom) {
                    RealTimeArrivalInfoToggle(lineColor: station.lineNum.lineColor ?? .black)
                        .frame(width: 80, height: 30)
                    
                    Spacer()
                    
                    HStack {
                        Text(viewModel.fetchTime.timeToString())
                            .foregroundColor(Color(uiColor: .systemGray))
                        
                        Button {
                            viewModel.getSubwayArrivalData(station.stationName)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(station.lineNum.lineColor ?? .black)
                                .frame(width: 15, height: 15)
                        }
                    }
                }
                .padding([.top, .horizontal], 16)
                
                arrivalInfoTabel()
                    .border(Color(uiColor: .label), width: 1)
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
                
                Spacer()
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
    
    @ViewBuilder
    private func menu() -> some View {
        HStack(alignment: .center) {
            
            Divider()
                .frame(width: 1)
            
            BottomLabelImageButton() {
                print("전화")
            }
            .image("phone.fill")
            .text("전화")
            .imageColor(Color(uiColor: .darkGray))
            .textColor(Color(uiColor: .darkGray))
            .frame(width: 50, height: 50)
            
            Divider()
                .frame(width: 1)
            
            BottomLabelImageButton() {
                isSave.toggle()
            }
            .image("star.fill")
            .text("저장")
            .imageColor(isSave ? Color.yellow : Color(uiColor: .darkGray))
            .textColor(Color(uiColor: .darkGray))
            .frame(width: 50, height: 50)
            
            Divider()
                .frame(width: 1)
            
            BottomLabelImageButton() {
                print("공유")
            }
            .image("square.and.arrow.up.fill")
            .text("공유")
            .imageColor(Color(uiColor: .darkGray))
            .textColor(Color(uiColor: .darkGray))
            .frame(width: 50, height: 50)
            
            Divider()
                .frame(width: 1)
        }
    }
    
    @ViewBuilder
    private func arrivalInfoTabel() -> some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button {
                        isUp = true
                    } label: {
                        Text("상행(내선)")
                            .foregroundColor(Color(uiColor: .label))
                            .frame(width: (proxy.size.width) / 2, height: 40)
                    }
                    
                    Button {
                        isUp = false
                    } label: {
                        Text("하행(외선)")
                            .foregroundColor(Color(uiColor: .label))
                            .frame(width: (proxy.size.width) / 2, height: 40)
                    }
                }
                
                HStack {
                    
                    if !isUp {
                        Spacer()
                    }
                    
                    Rectangle()
                        .fill(Color(uiColor: .label))
                        .frame(width: proxy.size.width / 2, height: 4)
                    
                    if isUp {
                        Spacer()
                    }
                }
                .animation(.linear(duration: 0.1), value: isUp)
                
                Divider()
                
                ForEach(isUp ? viewModel.upSubwayArrivalInfo : viewModel.downSubwayArrivalInfo) { info in
                    let vm = SubwayArrivalInfoRowViewModel(info: info)
                    SubwayArrivalInfoRow(viewModel: vm)
                        .padding(.vertical, 6)
                }
            }
        }
    }
}

struct BottomLabelImageButton_Previews: PreviewProvider {
    static var previews: some View {
        SubwayArrivalView(station: Station(lineNum: LineNum.lineSecond, stationName: "강남"), viewModel: SubwayArrivalViewModel())
    }
}
