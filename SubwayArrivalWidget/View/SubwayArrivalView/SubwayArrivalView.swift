//
//  SubwayArrivalView.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/26.
//

import SwiftUI

struct SubwayArrivalView<ViewModel>: View where ViewModel: SubwayArrivalViewModelInterface {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModel
    @State private var selectHour: String = ""
    
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
                    RealTimeArrivalInfoToggle(toggle: $viewModel.isRealtimeArrival, lineColor: viewModel.station.lineNum.lineColor ?? .black)
                        .frame(width: 80, height: 30)
                    
                    Spacer()
                    
                    HStack {
                        Text(viewModel.fetchTime.timeToString())
                            .foregroundColor(Color(uiColor: .systemGray))
                        
                        Button {
                            viewModel.getSubwayArrivalData()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(viewModel.lineColor)
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
                            .foregroundColor(viewModel.lineColor)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(alignment: .bottom, spacing: 2) {
                        Text(viewModel.stationName)
                            .font(.title)
                        Text(viewModel.station.lineNum.str)
                            .foregroundColor(viewModel.lineColor)
                    }
                }
            }
        }
        .onAppear {
            viewModel.getSubwayArrivalData()
        }
    }
    
    @ViewBuilder
    private func stationInfoCapsuleView() -> some View {
        ZStack {
            Capsule()
                .fill(viewModel.lineColor)
                .frame(width: 120, height: 50)
            Capsule()
                .fill(.white)
                .frame(width: 110, height: 40)
            HStack {
                Text(String(viewModel.station.lineNum.str.first ?? " "))
                    .foregroundColor(.white)
                    .background {
                        Circle()
                            .fill(viewModel.lineColor)
                            .frame(width: 21, height: 21)
                    }
                
                Text(viewModel.stationName)
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
                viewModel.setStationBookMark()
            }
            .image("star.fill")
            .text("저장")
            .imageColor(viewModel.isStationBookMark ? Color.yellow : Color(uiColor: .darkGray))
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
                        viewModel.isUp = true
                    } label: {
                        Text("상행(내선)")
                            .foregroundColor(Color(uiColor: .label))
                            .frame(width: (proxy.size.width) / 2, height: 40)
                    }
                    
                    Button {
                        viewModel.isUp = false
                    } label: {
                        Text("하행(외선)")
                            .foregroundColor(Color(uiColor: .label))
                            .frame(width: (proxy.size.width) / 2, height: 40)
                    }
                }
                
                HStack {
                    
                    if !viewModel.isUp {
                        Spacer()
                    }
                    
                    Rectangle()
                        .fill(Color(uiColor: .label))
                        .frame(width: proxy.size.width / 2, height: 4)
                    
                    if viewModel.isUp {
                        Spacer()
                    }
                }
                .animation(.linear(duration: 0.1), value: viewModel.isUp)
                
                Divider()
                
                if !viewModel.isRealtimeArrival {
                    selectTimeHour()
                    ScrollView(.vertical) {
                        ScrollViewReader { scrollProxy in
                            ForEach(0..<viewModel.subwayTimeTableInfo.count, id: \.self) { index in
                                Section {
                                    HStack {
                                        Text("\(viewModel.subwayTimeTableInfo[index].key)시")
                                            .id(viewModel.subwayTimeTableInfo[index].key)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 3)
                                    .background(Color(uiColor: .systemGray2))
                                }
                                ForEach(viewModel.subwayTimeTableInfo[index].value) { info in
                                    let vm = SubwayTimeTableInfoViewModel(info: info)
                                    SubwayTimeTableInfoRow(viewModel: vm)
                                        .padding(.vertical, 6)
                                        .frame(width: proxy.size.width)
                                }
                            }
                            .onChange(of: selectHour) { value in
                                withAnimation {
                                    scrollProxy.scrollTo(value, anchor: .top)
                                }
                            }
                        }
                    }
                    .safeAreaInset(edge: .top) {
                        EmptyView()
                            .frame(height: 6)
                    }
                } else {
                    ForEach(viewModel.isUp ? viewModel.upSubwayArrivalInfo : viewModel.downSubwayArrivalInfo) { info in
                        let vm = SubwayArrivalInfoRowViewModel(info: info)
                        SubwayArrivalInfoRow(viewModel: vm)
                            .padding(.vertical, 6)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func selectTimeHour() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(5..<25) { index in
                    Text("\(index)시")
                        .frame(width: 50, height: 26)
                        .background {
                            Capsule()
                                .fill(Color(uiColor: .red))
                        }
                        .onTapGesture {
                            selectHour = String(format: "%02d", index)
                        }
                }
            }
        }
        .safeAreaInset(edge: .leading) {
            EmptyView()
                .frame(width: 4)
        }
        .safeAreaInset(edge: .trailing) {
            EmptyView()
                .frame(width: 4)
        }
        .frame(height: 26)
        .padding(.top, 6)
    }
}

struct BottomLabelImageButton_Previews: PreviewProvider {
    static var previews: some View {
        SubwayArrivalView(viewModel: SubwayArrivalViewModel(station: Station(lineNum: LineNum.lineSecond, stationName: "강남", stationCode: "0222")))
    }
}
