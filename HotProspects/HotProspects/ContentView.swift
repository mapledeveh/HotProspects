//
//  ContentView.swift
//  HotProspects
//
//  Created by Alex Nguyen on 2023-08-07.
//

import SwiftUI

struct ContentView: View {
    @State private var backgroundColour = Color.red
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .background(backgroundColour)
        
        Text("Change Colour")
            .padding()
            .contextMenu {
                Button("Red") {
                    backgroundColour = .red
                }
                
                Button("Greed") {
                    backgroundColour = .green
                }
                
                Button("Blue") {
                    backgroundColour = .blue
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
