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
        
        model.changeToggle(isOn: &isOn, bool: bool)
        
    }
    
    func deleteItem() {
        
        let item = model.fetchItem(uuid: indexOfUUID)
        
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
        
        model.saveItemOrCallAlert(
            conflictAlertIsPresented: &conflictAlertIsPresented,
            dismiss: dismiss,
            indexUUID: self.indexOfUUID,
            item: item,
            type: self.type
        )
        
    }
    
    func scheduleAppRefresh() {
        
        model.scheduleAppRefresh()
        
    }
    
    //when call this function, setup this ViewModel's variables at new value or edited value.
    func setUpInputView() {
        
        if(type == .add) {
            
            print("add")
            
            checkMarks = Constant.trueArray
            date = Constant.initialDate
            isOn = true
            title = ""
            uuid = UUID()
            
            indexOfUUID = uuid
            
        } else {
            
            print("edit")
            
            let item = model.fetchItem(uuid: indexOfUUID)
            
            checkMarks = item.checkMarks
            date = item.date
            isOn = item.isOn
            title = item.title
            uuid = item.uuid
            
        }
        
    }
    
    //when alarm is over 16 items, alert is called and stop adding alarm. otherwise can transition to InputView.
    func tapPlusButton(items: [HourAndMinute]) {
        
        if(items.count > 16) {
            
            limitAlertIsPresented = true
            
        } else {
            
            type = .add
            setUpInputView()
            sheetIsPresented = true
            
        }
        
    }
    
}
