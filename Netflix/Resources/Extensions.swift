//
//  Extensions.swift
//  Netflix
//
//  Created by Javlonbek Sharipov on 09/03/23.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
