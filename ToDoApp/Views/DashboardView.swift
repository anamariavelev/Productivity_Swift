import SwiftUI
import FirebaseFirestoreSwift

struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel
    @StateObject var viewNewItem = NewDashItemViewModel()
    @FirestoreQuery var items: [DashboardItem]
    @State private var color: Color = .blue
    @StateObject var viewModel1: ClassifyForMeViewModel

    @Environment(\.colorScheme) var colorScheme  // Environment property to detect theme mode
    var themeColor: Color {
        colorScheme == .light ? .black : .white
    }

    var ribbonthemeColor: Color {
        colorScheme == .light ? .green : .secondary
    }

    let userId: String

    init(userId: String) {
        self.userId = userId
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/options"
        )
        self._viewModel = StateObject(
            wrappedValue: DashboardViewModel(userId: userId)
        )
        self._viewModel1 = StateObject(
            wrappedValue: ClassifyForMeViewModel(userId: userId)
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(ribbonthemeColor)
                        .rotationEffect(Angle(degrees: 15))

                    Rectangle()
                        .foregroundColor(themeColor)
                        .frame(height: 2)
                        .offset(y: -75)
                        .rotationEffect(Angle(degrees: 0))

                    Rectangle()
                        .foregroundColor(themeColor)
                        .frame(height: 2)
                        .offset(y: 75)
                        .rotationEffect(Angle(degrees: 0))

                    VStack {
                        Text("Dashboard")
                            .font(.system(size: 30))
                            .foregroundColor(themeColor)
                            .bold()
                            .offset(x: 5, y: -5)
                        Text("What are your plans for today?")
                            .font(.system(size: 18))
                            .foregroundColor(themeColor)
                            .offset(x: 5, y: -5)
                    }
                    .padding(.top, 10)
                }
                .frame(width: UIScreen.main.bounds.width * 3, height: 150)
                .offset(y: -60)

                HStack(spacing: 20) {
                    NavigationLink(destination: ToDoListView(userId: userId)) {
                        DashboardButton(title: "Tasks")
                            .buttonStyle(BorderlessButtonStyle())
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(themeColor, lineWidth: 2)
                            )
                    }
                    NavigationLink(destination: LearningView()) {
                        DashboardButton(title: "Find Answers")
                            .buttonStyle(BorderlessButtonStyle())
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(themeColor, lineWidth: 2)
                            )
                    }
                }
                .offset(y: 10)

                HStack(spacing: 20) {
                    NavigationLink(destination: CalendarView(viewModel: CalendarViewModel(userId: userId))) {
                        DashboardButton(title: "Calendar")
                            .buttonStyle(BorderlessButtonStyle())
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(themeColor, lineWidth: 2)
                            )
                    }
                    NavigationLink(destination: ClassifyForMeView(viewModel: viewModel1)) {
                        DashboardButton(title: "Schedule for me")
                            .buttonStyle(BorderlessButtonStyle())
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(themeColor, lineWidth: 2)
                            )
                            .onAppear {
                                viewModel1.fetchAndCategorizeTasksIfNeeded()
                            }
                    }
                }
                .offset(y: 15)

                Image("imagine_bun")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 1300, height: 175)
                    .offset(y: 50)
            }
        }
    }
}

struct DashboardButton: View {
    let title: String
    @Environment(\.colorScheme) var colorScheme  // Environment property to detect theme mode
    var themeColor: Color {
        colorScheme == .light ? .black : .white
    }
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.clear)
            .overlay(
                Text(title)
                    .foregroundColor(themeColor)
                    .font(.title2)
            )
            .frame(width: 150, height: 60)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(userId: "f6S6M0HllnUufAiqMvvkrxri7X93")
    }
}
