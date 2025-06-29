//
//  Extensions.swift
//  Stroll
//
//  Created by William Kindlien Gunawan on 29/06/25.
//

import Foundation
import SwiftUI

extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(action: action))
    }
}

private struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content.onAppear {
            if !didLoad {
                didLoad = true
                action?()
            }
        }
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
