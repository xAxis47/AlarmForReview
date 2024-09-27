//
//  CancelButton.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//this button is very simple. only close the view.
struct CancelButton: View {
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        
        Button(action: {
            
            dismiss()
            
        }) {
            
            Text(Constant.cancel)
            
        }
        
    }
    
}

#Preview {
    CancelButton()
}
