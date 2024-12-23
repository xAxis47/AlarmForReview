//
//  Constant.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/06/21.
//

import Foundation

struct Constant {
    
    static let alarm: String = "アラーム"
    static let blank: String = ""
    static let cancel: String = "キャンセル"
    static let conflictAlertBody: String = "この時間は登録できません。別の時間を登録してください。"
    static let conflictAlertTitle: String = "すでに同じ時間が登録されています。"
    static let delete: String = "削除する"
    static let deleteEnglish: String = "delete"
    static let deleteAlertBody: String = "一度消すと取り消しはできません。"
    static let deleteAlertTitle: String = "このアラームを消しますか？"
    static let everyday: String = "毎日"
    static let goodMorning: String = "起床"
    static let initialBool: Bool = true
    static let initialDate: Date = Date(timeIntervalSince1970: 0)
    static let initialTitle: String = ""
    static let initialUUID: UUID = UUID()
    static let isOn: String = "アラームをかける"
    static let japaneseIdentifier: String = "ja_JP"
    static let letsStart: String = "始ましょう"
    static let limitAlertTitle: String = "登録出来る上限を超えたアラームを登録しようとしています。"
    static let limitAlertBody: String = "登録しているアラームを整理してください。"
    static let nextDay: Int = 1
    static let other: String = "その他"
    static let refreshIdentifier: String = "com.gmail.dev.kawagoe.wataru.schedule"
    static let repetition: String = "繰り返し"
    static let today: Int = 0
    static let timeSetting: String = "時間の設定"
    static let title: String = "タイトル"
    static let save: String = "保存"
    static let silence: String = "forsilence.mp3"
    static let snooze: String = "スヌーズ"
    static let snoozeTimeInterval: TimeInterval = 60 * 1
    static let soundLength: TimeInterval = 29
    static let suffix00: String = "00"
    static let suffix01: String = "01"
    static let suffix02: String = "02"
    static let suffix03: String = "03"
    static let suffix04: String = "04"
    static let suffix05: String = "05"
    static let testSound: String = "sound.mp3"
    static let timeHasCome: String = "時間になりました"
    static let zeroTrueAlertBody = "どれか一つの曜日を必ず選択してください。"
    static let zeroTrueAlertTitle = "最低限一つの曜日を選択する必要があります。"
    
    static let singleComma: String = ","
    static let multipleComma: String = ",,"
    
    
    static let checkMarkFalse: CheckMark = CheckMark(bool: false)
    static let checkMarkTrue: CheckMark = CheckMark(bool: true)
    static let falseArray: [CheckMark] = [checkMarkFalse, checkMarkFalse, checkMarkFalse, checkMarkFalse, checkMarkFalse, checkMarkFalse, checkMarkFalse]
    static let trueArray: [CheckMark] = [checkMarkTrue, checkMarkTrue, checkMarkTrue, checkMarkTrue, checkMarkTrue, checkMarkTrue, checkMarkTrue]
    
    static let dayArray: [String] = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
    static let dayInitialsArray: [String] = ["日", "月", "火", "水", "木", "金", "土"]
    
}
