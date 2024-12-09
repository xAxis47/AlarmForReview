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
@Observable
final class AlarmViewModel: ObservableObject {
    
    static let shared: AlarmViewModel = AlarmViewModel()
    
    let model: AlarmModel = AlarmModel()
    
    let sharedModelContainer: ModelContainer
    
    var checkMarks: [CheckMark] = Constant.trueArray
    var date: Date = Constant.initialDate
    var isOn: Bool = true
    var title: String = ""
    var uuid: UUID = UUID()
    
    var indexOfHourAndMinuteUUID: UUID = UUID()
    
    var conflictAlertIsPresented: Bool = false
    var deleteAlertIsPresented: Bool = false
    var limitAlertIsPresented: Bool = false
    var sheetIsPresented: Bool = false
    var zeroTrueAlertIsPresented: Bool = false
    
    var type: EditorialType = .add

//    var item: HourAndMinute = HourAndMinute()
    
    init() {
        
        self.sharedModelContainer = model.sharedModelContainer
        
    }
    
    func changeToggle(bool: Bool) {
        
        model.changeToggle(isOn: &isOn, bool: bool)
        
    }
    
    func deleteItem() {
        
        let item = model.fetchItem(uuid: indexOfHourAndMinuteUUID)
        
        model.deleteItem(item: item)
        
    }
    
    func deleteItems(indexSet: IndexSet) {
        
        model.deleteItems(offsets: indexSet)
        model.registerAllNotifications()
        
    }
    
    func pickUpDaysString(checkMarks: [CheckMark]) -> String {
        
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
//        
//        print("checkMark is \(self.checkMarks)")
//        print("date is \(self.date)")
//        print("isOn is \(self.isOn)")
//        print("title is \(self.title)")
//        print("uuid is \(self.uuid)")
//        
        model.saveItemOrCallAlert(
            conflictAlertIsPresented: &conflictAlertIsPresented,
            dismiss: dismiss,
            indexUUID: self.indexOfHourAndMinuteUUID,
            item: item,
            type: self.type
        )
        
    }
    
    func scheduleAppRefresh() {
        
        model.scheduleAppRefresh()
        
    }
    
    func setUpInputView() {
        
        print("type is \(self.type)")
        
        model.setUpInputView(
            checkMarks: &self.checkMarks,
            date: &self.date,
            indexOfHourAndMinuteUUID: &self.indexOfHourAndMinuteUUID,
            isOn: &self.isOn,
            title: &self.title,
            type: type,
            uuid: &self.uuid
        )
        
    }
    
}
