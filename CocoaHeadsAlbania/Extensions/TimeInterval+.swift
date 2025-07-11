//
//  TimeInterval+.swift
//  CocoaHeadsAlbania
//
//  Created by Bruno Frani on 11.7.25.
//

import Foundation

extension TimeInterval {
    func customFormatted() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: self) ?? self.formatted()
    }
}
