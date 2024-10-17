//
//  Item.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/06/20.
//

import Foundation
import SwiftData

@Model
final class HourAndMinute {
    
    var checkMarks: [Bool] = Constant.trueArray
    @Attribute(.unique) var date: Date = Constant.initialDate
    var isOn: Bool = true
    var title: String = Constant.goodMorning
    @Attribute(.unique) var uuid: UUID = UUID()
    
    init() {
        
        self.checkMarks = Constant.trueArray
        self.date = Constant.initialDate
        self.isOn = true
        self.title = Constant.blank
        self.uuid = UUID()
        
    }
    
    init(checkMarks: [Bool], date: Date, isOn: Bool, title: String, uuid: UUID) {
        
        self.checkMarks = checkMarks
        self.date = date
        self.isOn = isOn
        self.title = title
        self.uuid = uuid
        
    }
    
}
