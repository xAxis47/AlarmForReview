//
//  SaveButton.swift
//  Alarm
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//at first decide save data or show alert. data is InputView's time, repitition and title. alert is called when time of items same datepicker's time.
struct SaveButton: View {
    
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var vm: AViewModel

    var body: some View {
        
        Button(action: {
            
            //decide save item or show alert on this timing. there are many condition at save.
            self.vm.saveItemOrCallAlert(dismiss: dismiss)
            //after saving item, register notifications. because there is the case of refreshed items, need to register once again.
            self.vm.registerAllNotifications()
            
        }) {
            
            Text(Constant.save)
            
        }
        
    }
    
}

#Preview {
    
    return SaveButton()
        .environmentObject(AViewModel())
    
}

