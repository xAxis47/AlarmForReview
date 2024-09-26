//
//  Model.swift
//  Alarm
//
//  Created by Kawagoe Wataru on 2024/06/20.
//

import AVFoundation
import Foundation
import Observation
import SwiftData

@Observable final class AModel {
    
    var checkMarks: [Bool]
    var conflictAlertIsPresented: Bool
    var date: Date
    var deleteAlertIsPresented: Bool
    var isOn: Bool
    var itemIndex: Int
    var limitAlertIsPresented: Bool
    var sheetIsPresented: Bool
    var title: String
    var uuid: UUID
    var zeroTrueAlertIsPresented: Bool
    
    var type: EditorialType

    var item: HourAndMinute
    
    var sharedModelContainer: ModelContainer = {
        
        let schema = Schema([
            HourAndMinute.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
            
        } catch {
            
            fatalError("Could not create ModelContainer: \(error)")
            
        }
        
    }()
    
    init() {
        
        self.checkMarks = Constant.trueArray
        self.conflictAlertIsPresented = false
        self.date = Constant.initialDate
        self.deleteAlertIsPresented = false
        self.isOn = true
        self.itemIndex = 0
        self.limitAlertIsPresented = false
        self.sheetIsPresented = false
        self.title = ""
        self.uuid = UUID()
        self.zeroTrueAlertIsPresented = false
        
        self.type = .add
        
        self.item = HourAndMinute()
        
    }
    
}
