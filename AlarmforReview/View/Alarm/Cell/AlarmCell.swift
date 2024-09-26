//
//  AlarmCell.swift
//  Alarm
//
//  Created by Kawagoe Wataru on 2024/06/20.
//

import SwiftData
import SwiftUI

//put cell of setted time on AlarmView. right toggle express to ring or not to ring.
struct AlarmCell: View {
    
    @EnvironmentObject private var vm: AViewModel
    
    @Query(sort: [SortDescriptor(\HourAndMinute.date)]) private var items: [HourAndMinute]

    @State private var isOn: Bool = true
    
    private let item: HourAndMinute
    
    init(item: HourAndMinute) {
        
        self._isOn = State(initialValue: item.isOn)
        
        self.item = item
        
    }
    
    var body: some View {
        
        //when tap this button, transition to InputView on ".edit".
        Button(action: {
            
            //itemIndex is for setting InputView.
            self.vm.itemIndex = items.firstIndex(of: item) ?? 9999
            
            self.vm.type = .edit
            self.vm.sheetIsPresented = true

        }) {

            Toggle(isOn: $isOn) {
               
                //"time" indicate when alarm will ring on the day.
               let time = self.vm.pickUpHourAndMinuteString(date: self.item.date)
                //"dayOfTheWeek" express when during the week will ring.
               let dayOfTheWeek = self.vm.pickUpDaysString(checkMarks: self.item.checkMarks)
               
               VStack {
                      
                   Text(time)
                       .font(.largeTitle)
                       .frame(maxWidth: .infinity, alignment: .leading)
                   
                   HStack {
                       
                       Text(dayOfTheWeek)
                       .frame(maxWidth: .infinity, alignment: .leading)
                       
                   }
                   
               }
               .if(isOn == false) { view in
                   
                   view.foregroundStyle(.gray)
                   
               }
               
            }
            .padding(6)
            .onChange(of: self.isOn) {
               
                //when toggle is changed, register notification again.
                self.vm.changeToggle(isOn: self.isOn)
               
            }
               
        }
        .foregroundStyle(.foreground)

    }

}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: HourAndMinute.self, configurations: config)

    return AlarmCell(item: HourAndMinute())
        .environmentObject(AViewModel())
        .modelContainer(container)
    
}
