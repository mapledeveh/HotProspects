//
//  Prospect.swift
//  HotProspects
//
//  Created by Alex Nguyen on 2023-08-10.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAdress = ""
    // fileprivate: this property can be read from anywhere,
    // fileprivate(set): but only written from the current file
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published var people: [Prospect]
    
    init() {
        people = []
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
    }
}
