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
    
    var indexOfUUID: UUID = UUID()
    
    var conflictAlertIsPresented: Bool = false
    var deleteAlertIsPresented: Bool = false
    var limitAlertIsPresented: Bool = false
    var sheetIsPresented: Bool = false
    var zeroTrueAlertIsPresented: Bool = false
    
    var type: EditorialType = .add

//    @Query(sort: [SortDescriptor(\HourAndMinute.date)]) var items: [HourAndMinute]
    
    init() {
        
        self.sharedModelContainer = model.sharedModelContainer
        
    }
    
    func changeToggle(bool: Bool) {
        
        self.model.changeToggle(isOn: &isOn, bool: bool)
        
    }
    
    func deleteItem() {
        
        let item = model.fetchItem(uuid: indexOfUUID)
        
        self.model.deleteItem(item: item)
        
    }
    
    func deleteItems(indexSet: IndexSet) {
        
        self.model.deleteItems(offsets: indexSet)
        self.model.registerAllNotifications()
        
    }
    
    func filterTitles(items: [HourAndMinute]) -> [String] {
        
        return Array(Set(items.map({ $0.title })))
            .sorted(by: { $0 < $1 })
            .filter { $0 != Constant.goodMorning }
            .filter { $0 != Constant.blank }
        
    }
    
    func pickUpDaysString(checkMarks: [CheckMark]) -> String {
        
        return self.model.pickUpDaysString(checkMarks: checkMarks)
        
    }
    
    func pickUpHourAndMinuteString(date: Date) -> String {
        
        return self.model.pickUpHourAndMinuteString(date: date)
        
    }
    
    //items need?
    func prepareList(items: [HourAndMinute]) -> [String] {
        
        return self.model.prepareList(items: items)
        
    }
    
    func registerAllNotifications() {
     
        self.model.registerAllNotifications()
        
    }
    
    func saveItemOrCallAlert(dismiss: DismissAction) {
        
        let item = HourAndMinute(
            checkMarks: self.checkMarks,
            date: self.date,
            isOn: self.isOn,
            title: self.title,
            uuid: self.uuid
        )
        
        self.model.saveItemOrCallAlert(
            conflictAlertIsPresented: &conflictAlertIsPresented,
            dismiss: dismiss,
            indexUUID: self.indexOfUUID,
            item: item,
            type: self.type
        )
        
    }
    
    func scheduleAppRefresh() {
        
        self.model.scheduleAppRefresh()
        
    }
    
    //when call this function, setup this ViewModel's variables at new value or edited value.
    func setUpInputView() {
        
        if(self.type == .add) {
            
            print("add")
            
            self.checkMarks = Constant.trueArray
            self.date = Constant.initialDate
            self.isOn = true
            self.title = ""
            self.uuid = UUID()
            
            self.indexOfUUID = uuid
            
        } else {
            
            print("edit")
            
            let item = self.model.fetchItem(uuid: indexOfUUID)
            
            self.checkMarks = item.checkMarks
            self.date = item.date
            self.isOn = item.isOn
            self.title = item.title
            self.uuid = item.uuid
            
        }
        
    }
    
    func tapAlarmCell(item: HourAndMinute) {
        
        //index is for setting InputView.
        self.indexOfUUID = item.uuid
        
        self.type = .edit
        self.setUpInputView()
        self.sheetIsPresented = true
        
    }
    
    func tapDeleteButton() {
        
        self.deleteAlertIsPresented = true
        
    }
    
    func tapMenuButton() {
        
        self.title = title
        
    }
    
    //when alarm is over 16 items, alert is called and stop adding alarm. otherwise can transition to InputView.
    func tapPlusButton(items: [HourAndMinute]) {
        
        if(items.count > 16) {
            
            self.limitAlertIsPresented = true
            
        } else {
            
            self.type = .add
            self.setUpInputView()
            self.sheetIsPresented = true
            
        }
        
    }
    
}
