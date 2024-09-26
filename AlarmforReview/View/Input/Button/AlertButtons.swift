//
//  AlertButtons.swift
//  Alarm
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//AlertButtons are group of delete and cancel. this group is called when .alert modifier.
struct AlertButtons: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var vm: AViewModel

    var body: some View {
        
        //removes the currently displayed item simply. after that InputView is closed.
        Button(Constant.delete, role: .destructive) {
            
            self.vm.deleteItem()
            
            self.vm.registerAllNotifications()
            
            dismiss()
            
        }
        
        //assign false to deleteAlertIsPresented. then deleteAlert sheet is closed.
        Button(Constant.cancel, role: .cancel) {
            
            self.vm.deleteAlertIsPresented = false
            
        }
        
    }
    
}

#Preview {
    
    AlertButtons()
        .environmentObject(AViewModel())
    
}
