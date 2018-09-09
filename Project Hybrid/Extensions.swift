//
//  Extensions.swift
//  Project Hybrid
//
//  Created by Yura Yasinskyy on 08.09.18.
//  Copyright © 2018 BravoTeam. All rights reserved.
//

import Foundation

extension Error {
    
    func getDescription(file: String = #file, function: String = #function, line: Int = #line) -> String {
        let errorDescription = "Error: \(file), \(function), \(line): \(self)"
        return errorDescription
    }
    
}

extension String {
    static func randomAlphaNumericString(length: Int) -> String {
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersArray : [Character] = Array(charactersString)
        
        var randomString = ""
        for _ in 0..<length {
            randomString.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        
        return randomString
    }
}
