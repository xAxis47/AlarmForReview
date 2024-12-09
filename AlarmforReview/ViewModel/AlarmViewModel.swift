//
//  AlarmViewModel.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/12/05.
//

import AVFoundation
import BackgroundTasks
import Foundation
import Observation
import SwiftData
import SwiftDate
import SwiftUI
import UserNotifications

@MainActor
final class AlarmViewModel: ObservableObject {
    
    static let shared: AlarmViewModel = AlarmViewModel()
    
    let model: AlarmModel = AlarmModel()
    
    let sharedModelContainer: ModelContainer
    
    @Published var checkMarks: [Bool] = Constant.trueArray
    @Published var conflictAlertIsPresented: Bool = false
    @Published var date: Date = Constant.initialDate
    @Published var deleteAlertIsPresented: Bool = false
    @Published var isOn: Bool = true
    @Published var indexUUID: UUID = UUID()
    @Published var limitAlertIsPresented: Bool = false
    @Published var sheetIsPresented: Bool = false
    @Published var title: String = ""
    @Published var uuid: UUID = UUID()
    @Published var zeroTrueAlertIsPresented: Bool = false
    
    var type: EditorialType = .add

//    var item: HourAndMinute = HourAndMinute()
    
    init() {
        
        self.sharedModelContainer = model.sharedModelContainer
        
    }
    
    func changeToggle(bool: Bool) {
        
        model.changeToggle(isOn: &isOn, bool: bool)
        
    }
    
    func deleteItem() {
        
        let item = model.fetchItem(uuid: indexUUID)
        
        model.deleteItem(item: item)
        
    }
    
    func deleteItems(indexSet: IndexSet) {
        
        model.deleteItems(offsets: indexSet)
        
    }
    
    func pickUpDaysString(checkMarks: [Bool]) -> String {
        
        return model.pickUpDaysString(checkMarks: checkMarks)
        
    }
    
    func pickUpHourAndMinuteString(date: Date) -> String {
        
        return model.pickUpHourAndMinuteString(date: date)
        
    }
    
    //items need?
    func prepareList(items: [HourAndMinute]) -> [String] {
        
        return model.prepareList(items: items)
        
    }
    
    func registerAllNotifications() {
     
        model.registerAllNotifications()
        
    }
    
    func saveItemOrCallAlert(dismiss: DismissAction) {
        
        let item = HourAndMinute(
            checkMarks: self.checkMarks,
            date: self.date,
            isOn: self.isOn,
            title: self.title,
            uuid: self.uuid
        )
        
        print("checkMark is \(self.checkMarks)")
        print("date is \(self.date)")
        print("isOn is \(self.isOn)")
        print("title is \(self.title)")
        print("uuid is \(self.uuid)")
        
        model.saveItemOrCallAlert(
            conflictAlertIsPresented: &conflictAlertIsPresented,
            dismiss: dismiss,
            item: item,
            type: self.type
        )
        
    }
    
    func scheduleAppRefresh() {
        
        model.scheduleAppRefresh()
        
    }
    
    func setUpInputView() {
        
        model.setUpInputView(
            checkMarks: &self.checkMarks,
            date: &self.date,
            indexUUID: &self.indexUUID,
            isOn: &self.isOn,
            title: &self.title,
            type: self.type,
            uuid: &self.uuid
        
        )
        
    }
    
}
