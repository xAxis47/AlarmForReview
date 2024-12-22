//
//  DeleteButton.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//this button call deleteAlert. cant delete anything.
struct DeleteButton: View {
    
    @EnvironmentObject private var vm: AlarmViewModel
//    @Environment(AlarmViewModel.self) var vm
    
    var body: some View {
        
        Button(action: {

            self.vm.tapDeleteButton()

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
