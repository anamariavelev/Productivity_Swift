import Foundation
import FirebaseFirestore

extension Date {
    var monthTitle: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: self)
        }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.day = -1
        return Calendar.current.date(byAdding: components, to: self.startOfMonth)!
    }
    
    func isSameDay(as date: Date) -> Bool {
            return Calendar.current.isDate(self, inSameDayAs: date)
        }
    
    func addingMonths(_ value: Int) -> Date {
            return Calendar.current.date(byAdding: .month, value: value, to: self)!
        }
}


class CalendarViewModel: ObservableObject {
    @Published var daysToShow: [Date] = [] // This will contain all days to show on the calendar
    @Published var busyDays: [Date] = []   // This will contain busy days
    @Published var currentMonth: Date = Date() // Track the current displayed month
    
    private var db = Firestore.firestore()
    private var userId: String
    
    init(userId: String) {
        self.userId = userId
        fetchTasks(for: currentMonth)
    }
    
    func isDayBusy(_ date: Date) -> Bool {
        // Check if the provided date is contained within the busyDays array
        return busyDays.contains { $0.isSameDay(as: date) }
    }
    
    func fetchTasks(for month: Date) {
        let calendar = Calendar.current
        
        // Calculate the first day of the month
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        
        // Determine the weekday of the first day of the month
        let weekday = calendar.component(.weekday, from: startOfMonth)
        
        // Calculate the number of days to subtract to get to the first Sunday of the month
        let daysToSubtract = (weekday - calendar.firstWeekday + 8) % 7
        
        // Calculate the date of the first Sunday of the month
        let firstSundayOfMonth = calendar.date(byAdding: .day, value: -daysToSubtract, to: startOfMonth)!
        
        // Calculate the date of the last day of the month
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        // Fetch tasks for the calculated range
        db.collection("users")
            .document(userId)
            .collection("options")
            .document(userId)
            .collection("todos")
            .whereField("dueDate", isGreaterThanOrEqualTo: firstSundayOfMonth.timeIntervalSince1970)
            .whereField("dueDate", isLessThanOrEqualTo: endOfMonth.timeIntervalSince1970)
            .getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching tasks: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // Extract unique dates from tasks
                let busyDates = documents.compactMap { document -> Date? in
                    guard let timestamp = document.get("dueDate") as? TimeInterval else {
                        return nil
                    }
                    return Date(timeIntervalSince1970: timestamp)
                }
                
                DispatchQueue.main.async {
                    self.busyDays = busyDates
                    var datesArray: [Date] = []
                    
                    var currentDate = firstSundayOfMonth
                    
                    // Add dates to the array until we reach the last day of the month
                    while currentDate <= endOfMonth {
                        datesArray.append(currentDate)
                        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
                    }
                    
                    self.daysToShow = datesArray
                }
            }
    }


    
    func showPreviousMonth() {
        currentMonth = currentMonth.addingMonths(-1)
        fetchTasks(for: currentMonth)
    }
    
    func showNextMonth() {
        currentMonth = currentMonth.addingMonths(1)
        fetchTasks(for: currentMonth)
    }
}

