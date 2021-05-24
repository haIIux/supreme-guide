import SwiftUI

struct CalorieCalculatorController: View {
    @State var selectedPage = 0
    @State  var chosenGender: GenderPickerSelector = .male
    @State  var chosenActivityLevel: ActivityLevelSelector = .lightlyActive
    @State  var chosenGoal:  GoalSelector = .maintainWeight
    
    var body: some View {
        TabView(selection: $selectedPage) {
            InitialView(chosenGender: $chosenGender, chosenActivityLevel: $chosenActivityLevel, chosenGoal: $chosenGoal)
                .tag(0)
            
        }
    }
}

struct CalorieCalculatorController_Previews: PreviewProvider {
    static var previews: some View {
        CalorieCalculatorController()
    }
}
