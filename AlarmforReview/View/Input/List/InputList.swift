//
//  InputList.swift
//  Alarm
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//there is 3 section in the list. dont showing delete section, but there is delete section bottom of the InputView.
struct InputList: View {
    
    var body: some View {
        
        List {
             
            DatePickerSection()
            
            SettingSection()
            
            DeleteSection()
            
        }
        
    }
    
}

#Preview {
    
    InputList()
        .environmentObject(AViewModel())
    
}
