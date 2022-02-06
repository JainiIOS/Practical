//
//  String.swift
//  Practical
//
//  Created by a on 06/02/22.
//

import Foundation
extension String {
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    var isNumeric: Bool {
        return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
    }
    
    func isValidWeight() -> Bool {
        if isNumeric && Int(self) ?? 0 >= 5 && Int(self) ?? 0 <= 100 {
            return true
        }
        return false
    }
    
    func isValidHeight() -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacterForHeight)
        let typedCharacterSet = CharacterSet(charactersIn: self)
        let isHeight = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        
        if isHeight && Double(self) ?? 0.0 >= 100.0 && Double(self) ?? 0.0 <= 190 {
            return true
        }
        
        return false
    }
}
