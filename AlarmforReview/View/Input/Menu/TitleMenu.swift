//
//  TitleMenu.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftData
import SwiftUI

//when tap the button of title menu, TextField is filled that title.
struct TitleMenu: View {
    
    @Query(sort: [SortDescriptor(\HourAndMinute.date)]) private var items: [HourAndMinute]
    
    var body: some View {
        
        Menu(content: {
            
            //After extracting the titles of the items, sort them in ascending order. exclude goodMorning and blank title.
            let titles = Array(Set(items.map({ $0.title })))
                .sorted(by: { $0 < $1 })
                .filter { $0 != Constant.goodMorning }
                .filter { $0 != Constant.blank }
            
            HStack {
                
                //the reason why exclude goodMorning by filter is because want to put goodMorning at the top on menu.
                MenuButton(title: Constant.goodMorning)
                
                ForEach(titles, id: \.self) { title in
                
                    MenuButton(title: title)
                    
                }
                
            }
            
        }) {
            
            Text(Constant.title)
            
            Spacer()
            
        }
        .foregroundStyle(.foreground)
        
    }
}

#Preview {
    
    TitleMenu()

}
