//
//  MarkList.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//MarkList needs "day" and "index". "day" is simply string of the day of the week, and "index" is for array "checkMarks" of Model.
struct MarkList: View {
    
    var body: some View {
       
        List {
            
            ForEach(Array(Constant.dayArray.enumerated()), id: \.element) { index, day in
                
                MarkCell(day: day, index: index)
                
            }
            
        }
        
    }
        
}

#Preview {
    
    MarkList()
        .environmentObject(AlarmViewModel())
    
}
