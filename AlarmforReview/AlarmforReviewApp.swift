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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let shared: AlarmViewModel = AlarmViewModel.shared
    
    init() {
        
        print("alarm for review")
        
    }
    
    var body: some Scene {
        
        WindowGroup {
            
            AlarmView()
                .environmentObject(self.shared)
                .modelContainer(AlarmViewModel.shared.sharedModelContainer)
            
        }
        //app refresh and register notification each 3 hours.
        .backgroundTask(.appRefresh(Constant.refreshIdentifier)){
            
            print("background")
            
            await shared.scheduleAppRefresh()
            await shared.registerAllNotifications()
            
        }
        
        
    }
    
}


//onAppearとbackgroundでのregisterNotificationを行う。
