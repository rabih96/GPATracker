//
//  Theme.swift
//  GPA Diary
//
//  Created by Rabih Mteyrek on 4/23/17.
//  Copyright © 2017 Rabih Mteyrek. All rights reserved.
//

import UIKit

enum Theme: Int {
    case `default`, gray, blue, black, brown, orange, yellow, cyan, green, white
    
    var color: UIColor {
        switch self {
        case .default:
            return UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        case .gray:
            return UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        case .blue:
            return .blue
        case .black:
            return .black
        case .brown:
            return .brown
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .cyan:
            return .cyan
        case .green:
            return .green
        case .white:
            return UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        }
    }
}

let storedColor = "StoredColor"

struct ThemeManager {
    
    static func currentTheme() -> Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: storedColor)
        if storedTheme != 0 {
            return Theme(rawValue: storedTheme)!
        } else {
            return .default
        }
    }
    
    static func applyTheme(_ theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: storedColor)
        UserDefaults.standard.synchronize()
    }
}
