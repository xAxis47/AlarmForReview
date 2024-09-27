//
//  AlarmforReviewApp.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/06/20.
//

import SwiftUI
import SwiftData


@main
@MainActor
struct AlarmforReviewApp: App {
    
    let shared: AViewModel = AViewModel.shared
    
    init() {
        
        shared.registerAllNotifications()
        
    }
    
    var body: some Scene {
        
        WindowGroup {
            
            AlarmView()
                .environmentObject(AViewModel.shared)
                .modelContainer(AViewModel.shared.sharedModelContainer)  
            
        }
        //app refresh and register notification each 3 hours.
        .backgroundTask(.appRefresh(Constant.refreshIdentifier)){
            
            await shared.scheduleAppRefresh()
            await shared.registerAllNotifications()
            
        }
        
        
    }
    
}


//onAppearとbackgroundでのregisterNotificationを行う。
