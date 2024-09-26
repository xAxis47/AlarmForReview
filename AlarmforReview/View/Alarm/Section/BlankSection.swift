//
//  BlankSection.swift
//  Alarm
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

struct BlankSection: View {
    
    var body: some View {
        
        Section {
            
        } header: {
            //this Text is needed to make background gray. don't delete. when delete this Text, background become white.
            Text("")
            
        }
        
    }
    
}

#Preview {
    BlankSection()
}
