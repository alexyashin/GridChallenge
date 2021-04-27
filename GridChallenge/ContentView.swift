//
//  ContentView.swift
//  GridChallenge
//
//  Created by Alexey Yashin on 27.04.2021.
//

import SwiftUI

struct Photo: Identifiable {
    var id = UUID()
    var name: String
}

let samplePhotos = (1...20).map { Photo(name: "coffee-\($0)") }

struct ContentView: View {
    @State var gridLayout: [GridItem] = Array(repeating: GridItem(), count: 3)
    @State var prevAmount: CGFloat = 1
    
    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { changeAmount in
                let roundedAmount = (changeAmount * 10).rounded() / 10
                if roundedAmount > prevAmount {
                    self.prevAmount = roundedAmount
                    changeGrid(toBigger: true)
                } else if roundedAmount < prevAmount {
                    self.prevAmount = roundedAmount
                    changeGrid(toBigger: false)
                }
            }
            .onEnded { endAmount in
                self.prevAmount = 1
            }
    }
    
    func changeGrid(toBigger: Bool) {
        let colCount = self.gridLayout.count
        if toBigger && colCount < 5 {
            self.gridLayout = Array(repeating: GridItem(), count: colCount + 1)
        } else if !toBigger && colCount > 1 {
            self.gridLayout = Array(repeating: GridItem(), count: colCount - 1)
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) { ForEach(samplePhotos.indices) { index in
                Image(samplePhotos[index].name)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: gridLayout.count == 1 ? 200 : 100)
                    .cornerRadius(10)
            }
            .animation(.interactiveSpring())
            }
        }
        .padding(.all, 10)
        .gesture(magnification)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
