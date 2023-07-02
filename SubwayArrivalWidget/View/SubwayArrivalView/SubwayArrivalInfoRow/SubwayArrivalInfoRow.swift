//
//  SubwayArrivalInfoRow.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/02.
//

import SwiftUI

struct SubwayArrivalInfoRow<ViewModel>: View where ViewModel: SubwayArrivalInfoRowViewModelInterface {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.destination)
                .foregroundColor(Color(uiColor: .darkGray))
                .padding(.leading, 16)
            
            Spacer()
            
            Text(viewModel.arrivalInfo)
                .fontWeight(.semibold)
                .padding(.trailing, 16)
        }
    }
}

struct SubwayArrivalInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        SubwayArrivalInfoRow(viewModel: SubwayArrivalInfoRowViewModel(info: RealtimeArrivalInfo(totalCount: 4, rowNum: 1, selectedCount: 4, subwayID: "1075", updnLine: .up1, trainLineNm: "오이도행 - 연수방면", statnFid: "3939", statnTid: "340", statnID: "3030", statnNm: "송도", trnsitCo: "1", ordkey: "0100오이도0", subwayList: "19029", statnList: "94949494", btrainSttus: "일반", barvlDt: "0", btrainNo: "4040", bstatnID: "33", bstatnNm: "오이도", recptnDt: "ㄷ93", arvlMsg2: "송도 도착", arvlMsg3: "송도", arvlCD: "1")))
            .frame(width: UIScreen.main.bounds.width, height: 60)
            .previewLayout(.sizeThatFits)
    }
}
