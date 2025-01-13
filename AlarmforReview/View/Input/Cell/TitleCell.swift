//
//  TitleCell.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/08/24.
//

import SwiftUI

//Enter a title in this field and group by that title in AlarmView.
struct TitleCell: View {
    
    @EnvironmentObject private var vm: AlarmViewModel
    
    var body: some View {
        
         HStack {
             
             //when tap title string, show title menu. once enter the title at InputView, it will appear in the menu. there is goodmorning on top of the menu always.
             TitleMenu()
             
             Spacer()
             
             //here register the title on the TextField.
             TextField(Constant.title, text: self.$vm.title)
                 .multilineTextAlignment(.trailing)
             
         }
         
    }
    
}

#Preview {
    
    return TitleCell()
        .environmentObject(AlarmViewModel())
    
}
