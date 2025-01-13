//
//  DatePickerCell.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//simply cell of the DatePicker
struct DatePickerCell: View {
    
    @State var date: Date = Date()
    
    @EnvironmentObject private var vm: AlarmViewModel
//    @Environment(AlarmViewModel.self) var vm
    
    var body: some View {
        
        //selection value comes from the Model.
        DatePicker(
            selection: self.$vm.date,
            displayedComponents: .hourAndMinute
        ) {

            Text(Constant.blank)
            
        }
        .datePickerStyle(.wheel)
        .labelsHidden()
        .environment(\.locale, Locale(identifier: Constant.japaneseIdentifier))
        
    }
    
}

#Preview {
    
    return DatePickerCell()
        .environmentObject(AlarmViewModel())
    
}
