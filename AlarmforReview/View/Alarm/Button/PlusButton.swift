//
//  PlusButton.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftData
import SwiftUI

//The PlusButton is placed in the top right of the screen. this button is for making alarm.
struct PlusButton: View {
    
    @EnvironmentObject private var vm: AlarmViewModel

    @Query(sort: [SortDescriptor(\HourAndMinute.date)]) private var items: [HourAndMinute]

    var body: some View {
        
        Button(action: {
            
            //when alarm is over 16 items, alert is called and stop adding alarm. otherwise can transition to InputView.
            if(items.count > 16) {
                
                self.vm.limitAlertIsPresented = true
                
            } else {
                
                self.vm.type = .add
                self.vm.sheetIsPresented = true
                
            }
            
        }) {
            
            Label("", systemImage: "plus")
            
        }
        
    }
    
}

#Preview {
    
    return PlusButton()
        .environmentObject(AViewModel())
    
}
