//
//  DatePickerSection.swift
//  Alarm
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//simply there is DatePicker.
struct DatePickerSection: View {
    
    var body: some View {
        
        Section {
            
            DatePickerCell()
            
        }
        
    }
    
}

#Preview {
    
    DatePickerSection()
        .environmentObject(AViewModel())
    
}
