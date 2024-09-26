//
//  RepititionCell.swift
//  Alarm
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//show which day of the week the alarm will ring.
struct RepititionCell: View {
    
    @EnvironmentObject private var vm: AViewModel
    
    var body: some View {
        
        NavigationLink(destination: {
            
            //set the days of the week on which the alarm will ring here.
            MarkView()
            
        }) {
            
            HStack {
                
                Text(Constant.repetition)
                
                Spacer()
                
                //show the days of the week. can show specific days of the week too.
                Text(self.vm.pickUpDaysString(checkMarks: self.vm.checkMarks))
                    .foregroundStyle(.secondary)
            }
            
        }
        
    }
    
}

#Preview {
    
    return RepititionCell()
        .environmentObject(AViewModel())
    
}
