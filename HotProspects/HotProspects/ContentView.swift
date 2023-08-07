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
        List {
            Text("Paul Hudson")
                .swipeActions {
                    Button(role: .destructive) {
                        print("Hey")
                    } label: {
                        Image(systemName: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        print("Pinning")
                    } label: {
                        Image(systemName: "pin")
                    }
                    .tint(.orange)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
