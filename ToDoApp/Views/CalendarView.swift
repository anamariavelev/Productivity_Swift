import SwiftUI
import FSCalendar

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel

    let daysOfWeek = Date.capitalizedFirstLettersOfWeekDays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)

    @Environment(\.colorScheme) var colorScheme  // Environment property to detect theme mode

    var themeColor: Color {
        colorScheme == .light ? .green : .orange
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.showPreviousMonth()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
                .padding()
                
                Spacer()
                
                Text(viewModel.currentMonth.monthTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    viewModel.showNextMonth()
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.primary)
                }
                .padding()
            }
            .padding(.all)
            .offset(y: 120)
            
            CalendarHeader(themeColor: themeColor)
            DaysOfWeekHeader(daysOfWeek: daysOfWeek, themeColor: themeColor)
            CalendarDaysGrid(columns: columns, viewModel: viewModel, themeColor: themeColor)
        }
        .padding()
        .onAppear {
            // Fetch busy days when the view appears
            viewModel.fetchTasks(for: viewModel.currentMonth)
        }
    }
}

struct CalendarHeader: View {
    var themeColor: Color
    
    var body: some View {
        HeaderV2(title: "Calendar", subtitle: "Let's check the free days")
    }
}

struct DaysOfWeekHeader: View {
    var daysOfWeek: [String]
    var themeColor: Color
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                }
            }
            RoundedRectangle(cornerRadius: 20)
                .fill(themeColor.opacity(0.3))
                .frame(width: 380, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(themeColor, lineWidth: 2)
                )
        }
        .offset(y: -20)
    }
}

struct CalendarDaysGrid: View {
    var columns: [GridItem]
    @ObservedObject var viewModel: CalendarViewModel
    var themeColor: Color

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(viewModel.daysToShow, id: \.self) { day in
                Text("\(Calendar.current.component(.day, from: day))")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.primary)
                    .background(
                        Circle()
                            .fill(viewModel.isDayBusy(day) ? themeColor : Color.clear)
                            .opacity(viewModel.isDayBusy(day) ? 0.5 : 0)
                    )
            }
        }
        .offset(y: -10)
    }
}


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(viewModel: CalendarViewModel(userId: "f6S6M0HllnUufAiqMvvkrxri7X93"))
    }
}
