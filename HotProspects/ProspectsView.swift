//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Alex Nguyen on 2023-08-09.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var isShowingSort = false
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            let person = Prospect()
            person.name = details[0]
            person.emailAdress = details[1]
            person.dateAdded = Date.now
            prospects.add(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAdress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Uh oh!")
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        if filter == .none {
                            if prospect.isContacted {
                                Image(systemName: "checkmark.message.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "ellipsis.message")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAdress)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(prospect.wrappedDateAdded.formatted(date: .numeric, time: .omitted))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sort") {
                        isShowingSort = true
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "\(randomNames.randomElement() ?? "George")\nalexnguyen@canistel.ca", completion: handleScan)
            }
            .confirmationDialog("Choose", isPresented: $isShowingSort) {
                Button("Name") {
                    prospects.sorted(.name)
                }
                
                Button("Most Recent") {
                    prospects.sorted(.recent)
                }
            } message: {
                Text("Sort by")
            }
        }
    }
    
    let randomNames = ["Alex", "Bobby", "Chris", "Dave", "Ed", "Frank"]
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
