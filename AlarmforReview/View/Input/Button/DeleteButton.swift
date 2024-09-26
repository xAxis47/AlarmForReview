//
//  DeleteButton.swift
//  Alarm
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//this button call deleteAlert. cant delete anything.
struct DeleteButton: View {
    
    @EnvironmentObject private var vm: AViewModel
    
    var body: some View {
        
        Button(action: {
            
            self.vm.deleteAlertIsPresented = true
            
        }) {
            
            HStack {
                
                Spacer()
                
                Text(Constant.deleteEnglish)
                    .foregroundStyle(.red)
                
                Spacer()
                
            }
            
        }
        
    }
}

#Preview {
    
    return DeleteButton()
        .environmentObject(AViewModel())
    
}
