//
//  MarkCell.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//this cell is used to set whether or not a sound will be played on that day of the week.
struct MarkCell: View {
    
    @EnvironmentObject private var vm: AlarmViewModel

    private let day: String
    private let index: Int
    
    init(day: String, index: Int) {
        
        self.day = day
        self.index = index
        
    }
    
    var body: some View {
        
        Button(action: {
            
            self.vm.tapMarkCell(index: self.index)
            
        }) {
            
            HStack {
                
                Text("\(day)")
                
                Spacer()
                
                if(self.vm.checkMarks[index].bool == true) {
                    
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
