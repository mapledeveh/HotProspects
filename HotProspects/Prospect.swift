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
    var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published var people: [Prospect]
    
    init() {
        people = []
    }
}
