//
//  MarkCell.swift
//  Alarm
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//this cell is used to set whether or not a sound will be played on that day of the week.
struct MarkCell: View {
    
    @EnvironmentObject private var vm: AViewModel

    private let day: String
    private let index: Int
    
    init(day: String, index: Int) {
        
        self.day = day
        self.index = index
        
    }
    
    var body: some View {
        
        Button(action: {
            
            //decide ringing sound or not here.
            self.vm.checkMarks[index].toggle()
            
            let trueCount = self.vm.checkMarks.filter {$0}
                .count
            
            //this alert is called when there are no icons.
            if (trueCount == 0) {
                
                self.vm.zeroTrueAlertIsPresented = true
                
                //the number of icons cant remain at 0, so display the icons again here.
                self.vm.checkMarks[index].toggle()
                
            }
            
        }) {
            
            HStack {
                
                Text("\(day)")
                
                Spacer()
                
                if(self.vm.checkMarks[index] == true) {
                    
                    Image(systemName: "alarm")
                        .foregroundStyle(.orange)
                    
                }
                
            }
            .padding()
            
        }
        .foregroundStyle(.foreground)
        .listRowInsets(.init())

    }
    
}

#Preview {
    
    MarkCell(day: "月曜日", index: 1)
        .environmentObject(AViewModel())
    
}
