//
//  Extensions.swift
//  Project Hybrid
//
//  Created by Yura Yasinskyy on 08.09.18.
//  Copyright © 2018 BravoTeam. All rights reserved.
//

extension Error {
    
    func getDescription(file: String = #file, function: String = #function, line: Int = #line) -> String {
        let errorDescription = "Error: \(file), \(function), \(line): \(self)"
        return errorDescription
    }
    
}
