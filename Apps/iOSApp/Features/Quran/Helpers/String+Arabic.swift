//
//  String+Arabic.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import Foundation

extension String {
    func convertedToArabic() -> String {
        let numbers = [
            "0": "٠", "1": "١", "2": "٢", "3": "٣", "4": "٤",
            "5": "٥", "6": "٦", "7": "٧", "8": "٨", "9": "٩"
        ]
        var result = ""
        for char in self {
            if let arabicDigit = numbers[String(char)] {
                result += arabicDigit
            } else {
                result += String(char)
            }
        }
        return result
    }
}
