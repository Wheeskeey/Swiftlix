//
//  Extensions.swift
//  Swiftlix
//
//  Created by Michał Sadurski on 29/10/2021.
//

import Foundation
import SwiftUI

// MARK: -
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static var primary: Color {
        get {
            return UserDefaults.standard.bool(forKey: "darkMode") ? Color.white : Color.black
        }
    }
    
    static var systemBG: Color {
        get {
            return UserDefaults.standard.bool(forKey: "darkMode") ? Color.systemGray6 : Color.white
        }
    }
    
    static var systemGray6: Color {
        get {
            return UserDefaults.standard.bool(forKey: "darkMode") ? Color(hex: "#1c1c1e") : Color(hex: "#f2f2f7")
        }
    }
    
    static var systemGray5: Color {
        get {
            return UserDefaults.standard.bool(forKey: "darkMode") ? Color(hex: "#2c2c2e") : Color(hex: "#e5e5ea")
        }
    }
    
    static var systemGray4: Color {
        get {
            return UserDefaults.standard.bool(forKey: "darkMode") ? Color(hex: "#3a3a3c") : Color(hex: "#d1d1d6")
        }
    }
    
    static var systemGray3: Color {
        get {
            return UserDefaults.standard.bool(forKey: "darkMode") ? Color(hex: "#48484a") : Color(hex: "#c7c7cc")
        }
    }
    
    static var systemGray2: Color {
        get {
            return UserDefaults.standard.bool(forKey: "darkMode") ? Color(hex: "#636366") : Color(hex: "#aeaeb2")
        }
    }
    
    static var systemGray: Color {
        get {
            return UserDefaults.standard.bool(forKey: "darkMode") ? Color(hex: "#8e8e93") : Color(hex: "#8e8e93")
        }
    }
}

// MARK: -
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: -
extension Date {
    static func minutesToHoursAndMinutes(_ minutes: Int) -> String {
        let tuple: (hours: Int, minutesLeft: Int) = (minutes / 60, (minutes % 60))
        
        if (tuple.minutesLeft == 0) {
            return "\(tuple.hours)h"
        } else {
            return "\(tuple.hours)h \(tuple.minutesLeft)m"
        }
    }
}

// MARK: -
extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}

// MARK: -
extension LocalizedStringKey {
    var stringKey: String {
        let description = "\(self)"

        let components = description.components(separatedBy: "key: \"")
            .map { $0.components(separatedBy: "\",") }

        return components[1][0]
    }
}

// MARK: -
extension String {
    static func localizedString(for key: String,
                                locale: Locale = .current) -> String {
        
        let language = locale.languageCode
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        
        return localizedString
    }
}


extension LocalizedStringKey {
    func stringValue(locale: Locale = .current) -> String {
        return .localizedString(for: self.stringKey, locale: locale)
    }
}
