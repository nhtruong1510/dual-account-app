//
//  String.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit
import MobileCoreServices

extension String {
    var isEmail: Bool{
        let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@" + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    var isOnlyLetters: Bool {
        let regexString = "[a-zA-Z_]+"
        return validate(withRegex: regexString)
    }
    
    var isAlphanumeric: Bool {
        let regexString = "[a-zA-Z0-9_]+"
        return validate(withRegex: regexString)
    }
    
    var isNumeric: Bool {
        let regexString = "^(?:[0-9])+$"
        return validate(withRegex: regexString)
    }
    
    var isWhiteSpaceOrEmpty: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func trimming() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func lengthFrom(min: Int, max: Int) -> Bool {
        return count >= min && count <= max
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return ceil(boundingBox.width)
    }
    
    /// Validate string with a regext
    ///
    /// - Parameter regexString: Some string with regex format. Something just like this: ^(?:[0-9]){6}$
    /// - Returns: true or false (it matched or unmatched with given regex)
    func validate(withRegex regexString: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regexString)
            let result = regex.firstMatch(in: self,
                                          options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                          range: NSRange(location: 0, length: count)) != nil
            return result
        } catch {
            return false
        }
    }
    
    /// Validate string with a pattern
    ///
    /// - Parameter patternString: Some string with regex format. Something just like this: ^(?:[0-9]){6}$
    /// - Returns: true or false (it matched or unmatched with original string)
    func validate(withPattern patternString: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: patternString,
                                                options: NSRegularExpression.Options.caseInsensitive)
            let range = NSRange(location: 0, length: self.count)
            let stringValid = regex.stringByReplacingMatches(in: self,
                                                             options: [],
                                                             range: range, withTemplate: "")
            return stringValid == self
        } catch {
            return false
        }
    }
    
    func isValidNumber(maxDecimalValue: Int, maxDecimalPlaces: Int) -> Bool {
        // Use NumberFormatter to check if we can turn the string into a number
        // and to get the locale specific decimal separator.
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true, be explicit anyways
        // Gets the locale specific decimal separator. If for some reason there is none we assume "." is used as separator.
        let decimalSeparator = formatter.decimalSeparator ?? "."
        
        // Check if we can create a valid number. (The formatter creates a NSNumber, but
        // every NSNumber is a valid double, so we're good!)
        if formatter.number(from: self) != nil {
            // Split our string at the decimal separator
            let split = components(separatedBy: decimalSeparator)
            
            // Depending on whether there was a decimalSeparator we may have one
            // or two parts now. If it is two then the second part is the one after
            // the separator, aka the digits we care about.
            // If there was no separator then the user hasn't entered a decimal
            // number yet and we treat the string as empty, succeeding the check
            if split.count == 1 {
                let value = split.first ?? ""
                return value.count <= maxDecimalValue
            } else if split.count == 2 {
                let value = split.first ?? ""
                let places = split.last ?? ""
                // Finally check if we're <= the allowed digits
                return  value.count <= maxDecimalValue && places.count <= maxDecimalPlaces
            }
        }
        
        return false // couldn't turn string into a valid number
    }
    
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex..<endIndex])
    }
}
