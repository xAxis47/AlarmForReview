//
//  DeleteSection.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//when EditorialType is ".edit" this DeleteSection is shown.
struct DeleteSection: View {
    
    @EnvironmentObject private var vm: AViewModel

    var body: some View {
        
        Section {
            
            if(self.vm.type == .edit) {
                
                DeleteCell()
                
            }
            
        }
        
    }
    
}

#Preview {
    
    DeleteSection()
        .environmentObject(AViewModel())
    
}
