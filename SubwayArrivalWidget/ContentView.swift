//
//  ContentView.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/18.
//

import SwiftUI
import Combine

struct ContentView: View {
    let manager = SubwayArrivalManager()
    @State private var subscriptions = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            manager.getArrivalData("합정")
                .sink { subscribe in
                    switch subscribe {
                    case .failure(.wrongURL):
                        print("잘못된 url")
                    case .failure(.response(code: let code)):
                        print("statusCode --> ", code)
                    case .failure(.decodingError(error: let error)):
                        decodingError(error: error)
                    case .failure(.wrappedError(error: let error)):
                        print("error --> ", error.localizedDescription)
                    case .finished:
                        break
                    }
                } receiveValue: { str in
                    print(str)
                }.store(in: &subscriptions)

        }
    }
    
    func decodingError(error: Error) {
        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .typeMismatch(let type, let context):
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            case .valueNotFound(let value, let context):
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            case .keyNotFound(let key, let context):
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            case .dataCorrupted(_):
                break
            }
        } else {
            print("this is not decodingError")
        }
    }
}

#Preview {
    ContentView()
}
