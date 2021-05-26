struct ViewOne: View {
    
    @ObservedObject var viewOneStore: ViewOneObject = ViewOneObject (
        viewOneData: ViewOneData(
            chosenGender: .male,
            chosenActivityLevel: .moderatelyActive,
            chosenGoal: .maintainWeight
        )
    )
    
    var userData: UserData = UserData()
    @State var ageInput = 0
    @State var weightInput = 0
    @State var heightInFeet = 0
    @State var heightInInches = 0
    
    var body: some View {
        VStack {
            
            Text("Please select your gender.")
                .font(.caption)
            Picker("Gender", selection: $viewOneStore.viewOneData.chosenGender) {
                ForEach(GenderPickerSelector.allCases, id: \.self) {
                    Text($0.rawValue.capitalized)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            Text("Please enter the following information.")
                .font(.caption)
            HStack {
                TextField("Age", value: $ageInput, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                TextField("Weight", value: $weightInput, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }
            HStack {
                TextField("Feet", value: $heightInFeet, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                TextField("Inches", value: $heightInInches, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }

            
            Button("Press Me!") {
                print(ageInput)
                print(heightInFeet)
                print(heightInInches)
                print(weightInput)
            }
        }
    }
}
