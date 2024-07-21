//
//  Date+Extension.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 08.04.2024.
//

import Foundation

extension Date {
    static var capitalizedFirstLettersOfWeekDays: [String]{
        let calendar = Calendar.current
        let weekdays = calendar.shortWeekdaySymbols
        
        return weekdays.map { weekday in
            guard let firstLetter = weekday.first else {return ""}
            return String (firstLetter).capitalized
        }
    }
    
    static var fullMonthNames: [String]{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        return (1...12).compactMap { month in
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
            let date = Calendar.current.date(from: DateComponents(year: 2000, month: month, day: 1))
            return date.map{ dateFormatter.string(from: $0)}
        }
    }
}
