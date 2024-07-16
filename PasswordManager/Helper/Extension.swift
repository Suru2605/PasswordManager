//
//  Extension.swift
//  PasswordManager
//
//  Created by GWL on 15/07/24.
//

import Foundation
import SwiftUI
// Remove Separator
struct RemoveSeparatorModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .listRowSeparator(.hidden)
        } else {
            content
        }
    }
}
