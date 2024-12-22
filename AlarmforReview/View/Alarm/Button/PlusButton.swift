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
//    @Environment(AlarmViewModel.self) var vm

    @Query(sort: [SortDescriptor(\HourAndMinute.date)]) private var items: [HourAndMinute]

    var body: some View {
        
        Button(action: {
            
            self.vm.tapPlusButton(items: items)
            
        }) {
            
            Label("", systemImage: "plus")
            
        }
        
    }
    
}

#Preview {
    
    return PlusButton()
        .environmentObject(AViewModel())
    
}
