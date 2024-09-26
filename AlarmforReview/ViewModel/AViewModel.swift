//
//  BCAViewModel.swift
//  Alarm
//
//  Created by Kawagoe Wataru on 2024/06/20.
//

import AVFoundation
import BackgroundTasks
import Foundation
import SwiftData
import SwiftDate
import SwiftUI
import UserNotifications

@MainActor
class AViewModel: ObservableObject{
    
    static let shared: AViewModel = AViewModel()
    
    let center = UNUserNotificationCenter.current()
    
    var model: AModel = AModel()
    
    //"checkMarks" index is subscript, and Bool is wheher showing icon or not.
    var checkMarks: [Bool] {
        get {
            return self.model.checkMarks
        }
        set {
            self.model.checkMarks = newValue
        }
    }
    
    //conflictAlert is in InputView, and this alert is called when this viewmodel's date same item's date.
    var conflictAlertIsPresented: Bool {
        get {
            return self.model.conflictAlertIsPresented
        }
        set {
            self.model.conflictAlertIsPresented = newValue
        }
    }
    
    //"date" is time of when is called alarm. using points are day, hour and minute. year and month isn't used.
    var date: Date {
        get {
            return self.model.date
        }
        set {
            self.model.date = newValue
        }
    }
    
    //deleteAlert is in InputView. this alert is shown when EditorialType is ".edit". DeleteButton is shown editing is second time onwards. at first show DeleteSection, DeleteCell and DeleteButton.
    var deleteAlertIsPresented: Bool {
        get {
            return self.model.deleteAlertIsPresented
        }
        set {
            self.model.deleteAlertIsPresented = newValue
        }
    }
    
    //"isOn" show whether shown each icon of MarkView or not. if showing icon, that day's alarm will be ring.
    var isOn: Bool {
        get {
            return self.model.isOn
        }
        set {
            self.model.isOn = newValue
        }
    }
    
    //"itemIndex" is subscript of HourAndMinute. after fetching items, assign "itemIndex" to items.
    var itemIndex: Int {
        get {
            return self.model.itemIndex
        }
        set {
            self.model.itemIndex = newValue
        }
    }
    
    //limit is ammount of items. items are over 16, there are restriction.
    var limitAlertIsPresented: Bool {
        get{
            return self.model.limitAlertIsPresented
        }
        set {
            self.model.limitAlertIsPresented = newValue
        }
    }
    
    //there is a sheet only one, InputView. this sheet is called from AlarmView.
    var sheetIsPresented: Bool {
        get {
            return self.model.sheetIsPresented
        }
        set {
            self.model.sheetIsPresented = newValue
        }
    }
    
    //"title" is for item's variable of showing title of AlarmView.
    var title: String {
        get {
            return self.model.title
        }
        set {
            self.model.title = newValue
        }
    }
    
    //this "uuid" is used when be called request and delete notification.
    var uuid: UUID {
        get {
            return self.model.uuid
        }
        set {
            self.model.uuid = newValue
        }
    }
    
    //zeroTrue alert is called when there is no icon at MarkView.  this situation is avoided because include risk on never ringing alarm
    var zeroTrueAlertIsPresented: Bool {
        get {
            return self.model.zeroTrueAlertIsPresented
        }
        set {
            self.model.zeroTrueAlertIsPresented = newValue
        }
    }
    
    //EditorialType include ".add", and ".edit". ".add" is creating new, and ".edit" is editing data again on InputView.
    var type: EditorialType {
        get {
            return self.model.type
        }
        set {
            self.model.type = newValue
        }
    }
    
    // at AlarmView and InputView, assign data to "item". item is HourAndMinute byself.
    var item: HourAndMinute {
        get {
            return self.model.item
        }
        set {
            self.model.item = newValue
        }
    }
    
    //ModelContainer is used at fetching data, adding, saving, editing and deleting.
    var sharedModelContainer: ModelContainer {
        get {
            return self.model.sharedModelContainer
        }
    }
    
    //notificationDelegate is from UNUserNotificationCenterDelegate. userNotifcation include "willPresentnotification" and "didReceiveresponse". "willPresentnotification" is set [.list, .banner, .badge, .sound].
    let notificationDelegate = ForegroundNotificationDelegate()

    init() {
        
        //this is request permission. if permitted, notificationDelegate assign self.center.delegate.
        self.center.requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: { (granted, _) in
                
                if(granted) {
                    
                    self.center.delegate = self.notificationDelegate
        
                }
                
            }
            
        )
        
    }
    
    //2 notification are added. first is ringing notification and second notification is silence. after request notification, identifier add suffix and count. timeInterval need over 0.
    func addNotification(count: Int, currentDate: Date, item: HourAndMinute) {

        let timeInterval = getDateDifference(
            count: count,
            currentDate: currentDate,
            item: item
        )
        
        if(timeInterval > 0) {
            
            let identifier = String(describing: item.uuid)
            
            requestNotification(
                body: Constant.timeHasCome,
                identifier: identifier,
                soundName: Constant.testSound,
                suffix: Constant.suffix00,
                count: count,
                timeInterval: timeInterval,
                title: item.title
            )
            
            //second notification needs no sound
            requestNotification(
                body: Constant.letsStart,
                identifier: identifier,
                soundName: Constant.silence,
                suffix: Constant.suffix01,
                count: count,
                timeInterval: timeInterval,
                title: item.title
            )
            
            //let id = identifier + suffix + String(describing: count)

        }
        
    }
    
    //this fuction called at AlarmView. isOn is toggle of AlarmCell.
    func changeToggle(isOn: Bool) {
        
        self.isOn = isOn
        
        do {
            
            let context = self.sharedModelContainer.mainContext
            
            try context.save()
            
        } catch {
            
            fatalError("\(error)")
            
        }
        
        self.registerAllNotifications()
        
        
    }
    
    //"checkMarks[index]" is express on or off of the days of the week. if not isToday is next day. index is assigned from temporary.
    func checkDailyCondition(checkMarks: [Bool], isToday: Bool) -> Bool {
      
        //weekday return 1 ~ 7. 1 is Sunday and 7 is Saturday.
        let weekday = Date().weekday
        
        let temporary: Int

        //day minus 1 from "weekday" because subscript is 0 ~ 6.
        if(isToday) {
            
            //if isToday, don't add anything.
            temporary = weekday - 1
            
        } else {
            
            //if not isToday, qeual next day, add 1.
            temporary = weekday - 1 + 1
            
        }

        let index: Int
        
        //when "temporary" is over 7, need to minus 7 to 0 ~ 6.
        if(temporary >= 7) {
            
            index = temporary - 7
            
        } else {
            
            index = temporary
            
        }
        
        //call specific days of the week
        return checkMarks[index]
        
    }
    
    //simply call removeAllPendingNotificationRequests. only delete all registered notification.
    func deleteAllNotification() {
        
        self.center.removeAllPendingNotificationRequests()
        
    }
    
    //delete item on ViewModel. after that, for deleted item, register notifications again. this function is called at AlertButtons in InputView.
    func deleteItem() {
        
        let context = self.sharedModelContainer.mainContext
        
        context.delete(self.item)
        
    }
    
    //delete the item, with the amount equal to "offsets". this function is called at AlarmSection in AlarmView.
    func deleteItems(offsets: IndexSet) {
        
        let items = fetchItems()
        
        withAnimation {
            
            for index in offsets {
                
                let context = self.sharedModelContainer.mainContext
                
                context.delete(items[index])
                
            }
            
        }
        
    }
    
    //delete specific notification from UUID.
    func deleteNotification(item: HourAndMinute) {
        
        let identifier = String(describing: item.uuid)
                
        self.center.removePendingNotificationRequests(withIdentifiers: [identifier])
        
    }
    
    //bring all of HourAndMinute sorted by Date and asending.
    func fetchItems() -> [HourAndMinute] {
        
        let context = self.sharedModelContainer.mainContext
        
        do {
            
            let descriptor = FetchDescriptor<HourAndMinute>(
                sortBy: [SortDescriptor(\.date, order: .forward)]
            )
            
            let items = try context.fetch(descriptor)
            
            return items
            
        } catch {
            
            fatalError("\(error)")
            
        }
        
    }
    
    //get the difference between today's or tomorrow's date and the item's date. item's date is 1970/01/01.
    func getDateDifference(count: Int, currentDate: Date, item: HourAndMinute) -> TimeInterval {
        
        let targetDate = DateInRegion(
            components: {
                $0.year = currentDate.year
                $0.month = currentDate.month
                $0.day = currentDate.day + count        //here is adding count
                $0.hour = item.date.hour                //change only hours
                $0.minute = item.date.minute            // and minutes
                $0.second = 0
                $0.nanosecond = 0
            }
        )!.date
        
        let timeInterval = (targetDate - currentDate).timeInterval
        
        return timeInterval
        
    }
    
    //write string of the days of the week or "everyday".
    func pickUpDaysString(checkMarks: [Bool]) -> String {
        
        let trueCount = checkMarks.filter { $0 }

        if(trueCount.count == 7) {
            
            return Constant.everyday
            
        } else {
            
            let days = checkMarks.enumerated().map { bool in
                
                if(bool.element) {
                    
                    return Constant.dayInitialsArray[bool.offset]
                    
                } else {
                    
                    return Constant.blank
                    
                }
                
            }
            .filter { $0 != Constant.blank }
            .joined(separator: Constant.singleComma)
            
            return days
            
        }
        
    }
    
    //write hour and minute of the date. when minutes is 0 ~ 9, is written "00" ~ "09"
    func pickUpHourAndMinuteString(date: Date) -> String {
        
        let region = Region(
            calendar: Calendars.gregorian,
            zone: Zones.current,
            locale: Locales.current
        )
        
        let convertedDate = date.convertTo(region: region)
        
        let hour = convertedDate.hour
        let minute = convertedDate.minute
        
        if(minute >= 0 && minute <= 9) {
            
            return "\(hour):0\(minute)"
            
        } else {
            
            return "\(hour):\(minute)"
            
        }
        
    }
    
    //this "List" is the list on AlarmView made by items. "header" is assigned sorted list.
    func prepareList(items: [HourAndMinute]) -> [String] {
        
        let titles = Array(Set(items.map({ $0.title })))
            .sorted(by: { $0 < $1 })
        
        let bool = titles.contains(Constant.goodMorning)
        
        let header: [String]
        
        if(bool == true) {
            
            header = titles
                .filter { $0 != Constant.goodMorning }
                .add(Constant.goodMorning)
            
        } else {
            
            header = titles
        
        }
        
        return header
        
    }
    
    //this function is most important of this App. at first remove registered notification, bring and assign items to itemsToday or itemsNextDay. after that check conditions(isOn and through checkMarks), carry out function.
    func registerAllNotifications() {
        
        print("registered")
        
        self.center.removeAllPendingNotificationRequests()
        self.center.removeAllDeliveredNotifications()
        
        let currentDate = Date()
          
        let itemsToday = self.fetchItems()
        
        itemsToday.forEach { item in
            
            if(item.isOn) {
                
                let condition = self.checkDailyCondition(
                    checkMarks: item.checkMarks,
                    isToday: true
                )
                
                if(condition) {
                    
                    self.addNotification(
                        count: Constant.today,
                        currentDate: currentDate,
                        item: item
                    )
                    
                }
                
            }
            
        }
      
        let itemsNextDay = self.fetchItems()
        
        itemsNextDay.forEach { item in
            
            if(item.isOn) {
                
                let condition = self.checkDailyCondition(
                    checkMarks: item.checkMarks,
                    isToday: false
                )
                
                if(condition) {
                    
                    self.addNotification(
                        count: Constant.nextDay,
                        currentDate: currentDate,
                        item: item
                    )
                    
                }
                
            }
            
        }
        
    }
    
    //request include string at content, trigger at time interval, and identifier.
    func requestNotification(body: String, identifier: String, soundName: String, suffix: String, timeInterval: TimeInterval, title: String) {
        
        let sound = UNNotificationSound(
            named: UNNotificationSoundName(soundName)
        )
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        content.sound = sound
        
        let id = identifier + suffix
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        
        self.center.add(request)
        
    }
    
    //this is almost same request above. difference is "count". count is used on making identifier.
    func requestNotification(body: String, identifier: String, soundName: String, suffix: String, count: Int, timeInterval: TimeInterval, title: String) {
        
        let sound = UNNotificationSound(
            named: UNNotificationSoundName(soundName)
        )
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        content.sound = sound
        
        let id = identifier + suffix + String(describing: count)

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        
        self.center.add(request)
        
    }
    
    //save editing item on InputView or creating new, or is called conflictAlert. "overlap" means items' dates' overlap. when overlap, cant save item. then call conflictAlert.
    func saveItemOrCallAlert(dismiss: DismissAction) {
        
        let context = self.sharedModelContainer.mainContext
        
        let items = self.fetchItems()
        
       //when dates of items overlap, "overlap" not 0
        let overlap = items
           .filter { $0.date == self.date }
           .count
       
        //EditorialType
        let type = self.type
        
        //when ".add", dont overlap items and title is blank, can insert new item of "HourAndMinute". then new item's title is "Constant.other".
        if(type == .add && overlap == 0 && self.title == Constant.blank) {
            
            let newItem = HourAndMinute(
                checkMarks: self.checkMarks,
                date: self.date,
                isOn: self.isOn,
                title: Constant.other,
                uuid: self.uuid
            )
           
            context.insert(newItem)
           
            dismiss()
         
            //when ".add", dont overlap items and title is blank, can insert new item of "HourAndMinute". then new item's title is "self.title".
        } else if(type == .add && overlap == 0 && self.title != Constant.blank) {

            let newItem = HourAndMinute(
                checkMarks: self.checkMarks,
                date: self.date,
                isOn: self.isOn,
                title: self.title,
                uuid: self.uuid
            )
           
            context.insert(newItem)
           
            dismiss()
           
        //when ".add", and if overlap items, that conflict SwiftData.
        } else if(type == .add && overlap != 0) {

            self.conflictAlertIsPresented = true
           
        //if variables of "HourAndMinute" dont change anything, simply dismiss.
        } else if(type == .edit && self.item.checkMarks == self.checkMarks && self.item.date == self.date && self.item.title == self.title) {

            dismiss()

        //when ".edit", and dont overlap items, need to save item. because in this case, "checkMarks" or "date" was changed and "title" was inserted blank necessarily. item's title is inserted "Constant.other".
        } else if(type == .edit && overlap == 0 && self.title == Constant.blank) {

            self.item.checkMarks = self.checkMarks
            self.item.date = self.date
            self.item.isOn = self.isOn
            self.item.title = Constant.other
           
            do {
               
                try context.save()
               
            } catch {
               
                fatalError("\(error)")
               
            }
           
            dismiss()
            
            //when ".edit", and dont overlap items, need to save item. because in this case, "checkMarks" or "date" or "title" was changed necessarily. item's title is inserted "self.title".
        } else if(type == .edit && overlap == 0 && self.title != Constant.blank) {

            self.item.checkMarks = self.checkMarks
            self.item.date = self.date
            self.item.isOn = self.isOn
            self.item.title = self.title
           
            do {
               
                try context.save()
               
            } catch {
               
                fatalError("\(error)")
               
            }
           
            dismiss()
         
        //when ".edit", and overlap items, dont change "date", "title" is inserted blank, need to save item. in this case, changed "checkMarks" and "title".
        } else if(type == .edit && overlap != 0 && self.item.date == self.date && self.title == Constant.blank) {
            
            self.item.checkMarks = self.checkMarks
            self.item.date = self.date
            self.item.isOn = self.isOn
            self.item.title = Constant.other
           
            do {
               
                try context.save()
               
            } catch {
               
                fatalError("\(error)")
               
            }
           
            dismiss()
         
        //when ".edit", and overlap items, dont change "date", "title" isnt inserted blank, need to save item. in this case, changed "checkMarks" or "title".
        } else if(type == .edit && overlap != 0 && self.item.date == self.date && self.title != Constant.blank) {
            
            self.item.checkMarks = self.checkMarks
            self.item.date = self.date
            self.item.isOn = self.isOn
            self.item.title = self.title
           
            do {
               
                try context.save()
               
            } catch {
               
                fatalError("\(error)")
               
            }
           
            dismiss()
           
        //other case is conflict SwiftData. call conflictAlert.
        } else {
            
             conflictAlertIsPresented = true
            
        }
       
    }
    
    //this schedule is background task schedule. in this app, use AppRefresh. this time every 3 hours.
    func scheduleAppRefresh() {
        
        let today = Date()
        let interval = DateComponents(hour: 3)
        let next = Calendar.current.date(byAdding: interval, to: today)
    
        let request = BGAppRefreshTaskRequest(identifier: Constant.refreshIdentifier)
        request.earliestBeginDate = next
        
        do {
            
            try BGTaskScheduler.shared.submit(request)
            
        } catch {
            
            fatalError("\(error)")
            
        }
        
    }
    
    //when call this function, setup this ViewModel's variables at new value or edited value.
    func setUpInputView() {
        
        if(self.type == .add) {
            
            self.checkMarks = Constant.trueArray
            self.date = Constant.initialDate
            self.isOn = true
            self.title = ""
            self.uuid = UUID()
            
            self.item = HourAndMinute()
            
        } else {
            
            let items = fetchItems()

            let item = items[itemIndex]
            
            self.checkMarks = item.checkMarks
            self.date = item.date
            self.isOn = item.isOn
            self.title = item.title
            self.uuid = item.uuid
            
            self.item = item
            
        }
        
    }
    
}
