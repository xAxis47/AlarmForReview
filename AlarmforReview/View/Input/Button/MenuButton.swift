//
//  MenuButton.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftData
import SwiftUI

//this button is for menu cell. if tap this button, TitleCell's TextField is filled this button's String.
struct MenuButton: View {
    
    @EnvironmentObject private var vm: AViewModel
    
    private let title: String
    
    init(title: String) {
        
        self.title = title
        
    }
    
    var body: some View {
        
        Button(action: {
            
            self.vm.title = title
            
        }) {
            
            Text(title)
            
        }
        
    }
}

#Preview {
    
    return MenuButton(title: Constant.title)
        .environmentObject(AViewModel())
    
}
