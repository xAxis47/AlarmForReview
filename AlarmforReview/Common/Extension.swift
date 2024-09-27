//
//  Extension.swift
//  AlarmforReview
//
//  Created by Kawagoe Wataru on 2024/06/29.
//

import AVFoundation
import Foundation
import SwiftUI

extension Array {
    
    func add(_ object: Element) -> Array {
        var mutable = self
        mutable.insert(object, at: 0)
        return mutable
    }
    
}

extension View {
    
    @ViewBuilder
    func `if`<Content: View> (
        _ condition: Bool,
        @ViewBuilder transform: (Self) -> Content
    ) -> some View {
        if(condition) {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View> (
        _ condition: Bool,
        @ViewBuilder _ then: (Self) -> TrueContent,
        @ViewBuilder `else`: (Self) -> FalseContent
    ) -> some View {
        if(condition) {
            then(self)
        } else {
            `else`(self)
        }
    }
    
}
