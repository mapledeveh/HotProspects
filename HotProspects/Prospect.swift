//
//  Prospect.swift
//  HotProspects
//
//  Created by Alex Nguyen on 2023-08-10.
//

import SwiftUI

class Prospect: Identifiable, Codable {
//class Prospect: Identifiable, Codable, Comparable {
//    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
//        lhs.name == rhs.name
//    }
//
//    static func < (lhs: Prospect, rhs: Prospect) -> Bool {
//        lhs.name < rhs.name
//    }
    
    var id = UUID()
    var name = "Anonymous"
    var emailAdress = ""
    var dateAdded: Date?
    
    var wrappedDateAdded: Date {
        dateAdded ?? Date.now
    }
    // fileprivate: this property can be read from anywhere,
    // fileprivate(set): but only written from the current file
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
        @Published private(set) var people: [Prospect]
    //    let saveKey = "SavedData"
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SaveData.json")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            people = []
        }
        //        if let data = UserDefaults.standard.data(forKey: saveKey) {
        //            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
        //                people = decoded
        //                return
        //            }
        //        }
        //        // no saved data:
        //        people = []
    }
    
    private func save() {
        //        if let encoded = try? JSONEncoder().encode(people) {
        //            UserDefaults.standard.set(encoded, forKey: saveKey)
        //        }
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func sorted(_ sortBy: SortType) {
        switch sortBy {
        case .name:
            people = people.sorted { $0.name < $1.name }
        case .recent:
            people = people.sorted { $0.wrappedDateAdded < $1.wrappedDateAdded }
        }
    }
    
    enum SortType {
        case name, recent
    }
}

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
