//
//  AlarmModel.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/12/05.
//

import AVFoundation
import BackgroundTasks
import Foundation
import SwiftData
import SwiftDate
import SwiftUI
import UIKit
import UserNotifications

@MainActor
class AlarmModel: ObservableObject {
    
    let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
    
    //notificationDelegate is from UNUserNotificationCenterDelegate. userNotifcation include "willPresentnotification" and "didReceiveresponse". "willPresentnotification" is set [.list, .banner, .badge, .sound].
    let notificationDelegate = ForegroundNotificationDelegate()
    
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
    func changeToggle(isOn: inout Bool, bool: Bool) {
        
        isOn = bool
        
        do {
            
            let context = self.sharedModelContainer.mainContext
            
            try context.save()
            
        } catch {
            
            fatalError("\(error)")
            
        }
        
        self.registerAllNotifications()
        
        
    }
    
    //"checkMarks[index]" is express on or off of the days of the week. if not isToday is next day. index is assigned from temporary.
    func checkDailyCondition(checkMarks: [CheckMark], isToday: Bool) -> CheckMark {
      
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
    
    //delete item on ViewModel. after that, for deleted item, register notifications again. this function is called at AlertButtons in InputView.
    func deleteItem(item: HourAndMinute) {
        
        let context = self.sharedModelContainer.mainContext
        
        context.delete(item)
        
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
    
    func fetchItem(uuid: UUID) -> HourAndMinute {
        
        let context = self.sharedModelContainer.mainContext
        
        do {
            
            let descriptor = FetchDescriptor<HourAndMinute>(
                predicate: #Predicate { item in item.uuid ==  uuid },
                sortBy: [SortDescriptor(\.date, order: .forward)]
            )
            
            let items = try context.fetch(descriptor)
            
            return items.first ?? HourAndMinute()
            
        } catch {
            
            fatalError("\(error)")
            
        }
        
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
    func pickUpDaysString(checkMarks: [CheckMark]) -> String {
        
        let trueCount = checkMarks.filter { $0.bool }

        if(trueCount.count == 7) {
            
            return Constant.everyday
            
        } else {
            
            let days = checkMarks.enumerated().map { checkMark in
                
                if(checkMark.element.bool) {
                    
                    return Constant.dayInitialsArray[checkMark.offset]
                    
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
        
        self.center.removeAllPendingNotificationRequests()
        self.center.removeAllDeliveredNotifications()
        
        let currentDate = Date()
          
        let items = self.fetchItems()
        
        items.forEach { item in
            
            if(item.isOn) {
                
                let condition = self.checkDailyCondition(
                    checkMarks: item.checkMarks,
                    isToday: true
                )
                
                if(condition.bool) {
                    
                    self.addNotification(
                        count: Constant.today,
                        currentDate: currentDate,
                        item: item
                    )
                    
                }
                
            }
            
        }
      
        items.forEach { item in
            
            if(item.isOn) {
                
                let condition = self.checkDailyCondition(
                    checkMarks: item.checkMarks,
                    isToday: false
                )
                
                if(condition.bool) {
                    
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
    func saveItemOrCallAlert(conflictAlertIsPresented: inout Bool, dismiss: DismissAction, indexUUID: UUID, item: HourAndMinute, type: EditorialType) {
        
        let context = self.sharedModelContainer.mainContext
        
        let items = self.fetchItems()
        
       //when dates of items overlap, "overlap" not 0
        let overlap = items
            .filter { $0.date == item.date }
           .count
        
        let updateItem = self.fetchItem(uuid: indexUUID)
        
        //EditorialType
        
        //when ".add", dont overlap items and title is blank, can insert new item of "HourAndMinute". then new item's title is "Constant.other".
        if(type == .add && overlap == 0 && item.title == Constant.blank) {
            
            print("0")
            
            let newItem = HourAndMinute(
                checkMarks: item.checkMarks,
                date: item.date,
                isOn: item.isOn,
                title: Constant.other,
                uuid: item.uuid
            )
           
            context.insert(newItem)
           
            dismiss()
         
            //when ".add", dont overlap items and title is blank, can insert new item of "HourAndMinute". then new item's title is "self.title".
        } else if(type == .add && overlap == 0 && item.title != Constant.blank) {

            print("1")
            
            let newItem = HourAndMinute(
                checkMarks: item.checkMarks,
                date: item.date,
                isOn: item.isOn,
                title: item.title,
                uuid: item.uuid
            )
           
            context.insert(newItem)
           
            dismiss()
           
        //when ".add", and if overlap items, that conflict SwiftData.
        } else if(type == .add && overlap != 0) {

            print("2")
            
            conflictAlertIsPresented = true
           
        //if variables of "HourAndMinute" dont change anything, simply dismiss.
        } else if(type == .edit && updateItem.checkMarks == item.checkMarks && updateItem.date == item.date && updateItem.title == item.title) {
            
            print("3")

            dismiss()

        //when ".edit", and dont overlap items, need to save item. because in this case, "checkMarks" or "date" was changed and "title" was inserted blank necessarily. item's title is inserted "Constant.other".
        } else if(type == .edit && overlap == 0 && item.title == Constant.blank) {
            
            print("4")

            updateItem.checkMarks = item.checkMarks
            updateItem.date = item.date
            updateItem.isOn = item.isOn
            updateItem.title = Constant.other
           
            do {
               
                try context.save()
               
            } catch {
               
                fatalError("\(error)")
               
            }
           
            dismiss()
            
            //when ".edit", and dont overlap items, need to save item. because in this case, "checkMarks" or "date" or "title" was changed necessarily. item's title is inserted "self.title".
        } else if(type == .edit && overlap == 0 && item.title != Constant.blank) {
            
            print("5")

            updateItem.checkMarks = item.checkMarks
            updateItem.date = item.date
            updateItem.isOn = item.isOn
            updateItem.title = item.title
           
            do {
               
                try context.save()
               
            } catch {
               
                fatalError("\(error)")
               
            }
           
            dismiss()
         
        //when ".edit", and overlap items, dont change "date", "title" is inserted blank, need to save item. in this case, changed "checkMarks" and "title".
        } else if(type == .edit && overlap != 0 && updateItem.date == item.date && item.title == Constant.blank) {
            
            print("6")
            
            updateItem.checkMarks = item.checkMarks
            updateItem.date = item.date
            updateItem.isOn = item.isOn
            updateItem.title = Constant.other
           
            do {
               
                try context.save()
               
            } catch {
               
                fatalError("\(error)")
               
            }
           
            dismiss()
         
        //when ".edit", and overlap items, dont change "date", "title" isnt inserted blank, need to save item. in this case, changed "checkMarks" or "title".
        } else if(type == .edit && overlap != 0 && updateItem.date == item.date && item.title != Constant.blank) {
            
            print("7")
            
            updateItem.checkMarks = item.checkMarks
            updateItem.date = item.date
            updateItem.isOn = item.isOn
            updateItem.title = item.title
           
            do {
               
                try context.save()
               
            } catch {
               
                fatalError("\(error)")
               
            }
           
            dismiss()
           
        //other case is conflict SwiftData. call conflictAlert.
        } else {
            
            print("8")
            
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
    func setUpInputView(checkMarks: inout [CheckMark], date: inout Date, indexOfUUID: inout UUID, isOn: inout Bool, title: inout String, type: EditorialType, uuid: inout UUID ) {
        
        if(type == .add) {
            
            print("add")
            
            checkMarks = Constant.trueArray
            date = Constant.initialDate
            isOn = true
            title = ""
            uuid = UUID()
            
            indexOfUUID = uuid
            
//            self.item = HourAndMinute()
            
        } else {
            
            print("edit")
            
            let item = fetchItem(uuid: indexOfUUID)
            
            checkMarks = item.checkMarks
            date = item.date
            isOn = item.isOn
            title = item.title
            uuid = item.uuid
            
//            self.item = item
            
        }
        
    }
    
}
