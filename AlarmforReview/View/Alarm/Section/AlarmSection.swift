//
//  AlarmSection.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftData
import SwiftUI

//this section is complex a little.
struct AlarmSection: View {
    
    @EnvironmentObject private var vm: AlarmViewModel

    @Query(sort: [SortDescriptor(\HourAndMinute.date)]) private var items: [HourAndMinute]

    var body: some View {
        
        //prepare header for section. header need to be sorted because the order is important.
        let list = self.vm.prepareList(items: items)
        
        //element is item of header array.
        ForEach(list, id: \.self) { element in
            
            //Section be created for each header.
            Section(content: {
                
                //make cells in the section.
                ForEach(items) { item in
                
                    //item is HourAndMinute. when header and item's title are equeal, cells be exported 
                    if(element == item.title) {
                        
                        AlarmCell(item: item)
                        
                    }
                    
                }
                .onDelete(perform: self.vm.deleteItems)
                
                
            }, header: {
                
                Text(element)
                    .font(.title)
                
            })
            
        }
        
    }
    
}

#Preview {
    
    return AlarmSection()
        .environmentObject(AViewModel())
    
}
