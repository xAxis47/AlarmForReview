//
//  SettingSection.swift
//  Alarm
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//SettingSection is in the middle. RepititionCell decide the days of the week, and TitleCell decide title.
struct SettingSection: View {
    
    var body: some View {
        
        Section {
            
            RepititionCell()
           
            TitleCell()
            
        }
        
    }
    
}

#Preview {
    
    SettingSection()
        .environmentObject(AViewModel())
    
}
