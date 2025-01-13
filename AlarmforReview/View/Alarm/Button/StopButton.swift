//
//  StopButton.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//StopButton for stopping sound of notification.
struct StopButton: View {
    
    @EnvironmentObject private var vm: AlarmViewModel
//    @Environment(AlarmViewModel.self) var vm

    var body: some View {
        
        Button(action: {
            
            //when registering notifications, delete all notification once. therefore stop sound of notification
            self.vm.registerAllNotifications()
            
        }) {
            
            HStack {
                
                Text("Stop")
                
                Image(systemName: "stop.fill")
                
            }
            
        }
        .font(.largeTitle)
         
    }
}

#Preview {
    
    return StopButton()
        .environmentObject(AlarmViewModel())
    
}
