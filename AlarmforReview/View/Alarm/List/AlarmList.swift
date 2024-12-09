//
//  AlarmList.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftData
import SwiftUI

//this list has 2 section and position header top of the section.
struct AlarmList: View {
    
    @EnvironmentObject private var vm: AlarmViewModel
//    @Environment(AlarmViewModel.self) var vm

    @Query(sort: [SortDescriptor(\HourAndMinute.date)]) private var items: [HourAndMinute]
    
    var body: some View {
        
        List {
            
            //count ammount of header and when there is no header, put on BlankSection.
            let header = self.vm.prepareList(items: items)
            
            if(header.count != 0) {
                
                AlarmSection()
                
            } else {
                
                //when item line up in section, background color is light gray. but when there is no section, background color become white. so need to put on blank section.
                BlankSection()
                
            }
            
        }
        
    }
    
}

#Preview {
    
    return AlarmList()
        .environmentObject(AViewModel())
    
}
