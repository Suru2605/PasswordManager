//
//  PasswordStrengthMeterView.swift
//  PasswordManager
//
//  Created by GWL on 16/07/24.
//

import Foundation
import SwiftUI

enum PasswordStrength {
    case weak, moderate, strong
}

struct PasswordStrengthEvaluator {
    static func evaluate(password: String) -> PasswordStrength {
        let lengthCriteria = password.count >= 8
        let uppercaseCriteria = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password)
        let lowercaseCriteria = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)
        let digitCriteria = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)
        let specialCharacterCriteria = NSPredicate(format: "SELF MATCHES %@", ".*[!@#$%^&*(),.?\":{}|<>]+.*").evaluate(with: password)

        let criteriaMet = [lengthCriteria, uppercaseCriteria, lowercaseCriteria, digitCriteria, specialCharacterCriteria].filter { $0 }.count

        switch criteriaMet {
        case 0...2:
            return .weak
        case 3...4:
            return .moderate
        case 5:
            return .strong
        default:
            return .weak
        }
    }
}
