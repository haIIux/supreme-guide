import SwiftUI
import Combine

enum GenderPickerSelector: String, CaseIterable {
    case male
    case female
}

enum ActivityLevelSelector: Double, CaseIterable {
    case sedentary = 1.2
    case lightlyActive = 1.375
    case moderatelyActive = 1.55
    case veryActive = 1.725
    
    var description: String {
        switch self {
        case .sedentary:
            return "Sedentary"
        case .lightlyActive:
            return "Lightly Active"
        case .moderatelyActive:
            return "Moderately Active"
        case .veryActive:
            return "Very Active"
        }
    }
}

enum GoalSelector: Double, CaseIterable {
    
    case mildWeightLoss = 0.18 // 18% deficit.
    case moderateWeightLoss = 0.25 // 25% deficit.
    case maintainWeight = 0.0 // No weight loss or gain.
    case mildWeightGain = 0.1 // 10% gain.
    case moderateWeightGain = 0.2 // 20% gain.
    
    var description: String {
        switch self {
        case .mildWeightLoss:
            return "Mild Weight Loss"
        case .moderateWeightLoss:
            return "Moderate Weight Loss"
        case .maintainWeight:
            return "Maintain Weight"
        case .mildWeightGain:
            return "Mild Weight Gain"
        case .moderateWeightGain:
            return "Moderate Weight Gain"
        }
    }
}

struct InitialView: View {
    
    @Binding  var chosenGender: GenderPickerSelector
    @Binding  var chosenActivityLevel: ActivityLevelSelector
    @Binding  var chosenGoal:  GoalSelector
    
    // Unsure how to pass these values to SecondView.
    @State var ageInput = ""
    @State var heightInFeet = ""
    @State var heightInInches = ""
    @State var weightInput = ""
    @State var showAlert = false

    
    func ConvertHeight() -> Double {
        let convertHeight = Double(heightInFeet)! * 12
        let addInches = convertHeight + Double(heightInInches)!
        
        let centimetersReturn = addInches * 2.54
        
        // Returns height in centimeters.
        return centimetersReturn
    }
    
    func convertPoundsToKg() -> Double {
        guard let userWeightInput = Double(weightInput) else { return 0.0 }
        let performConversion = userWeightInput / 2.2046 // Number is the conversion number.
        
        return Double(performConversion)
    }
    
    func maleBMR() -> Double {
        let heightConversionFunction = ConvertHeight()
        let weightConversionFunction = convertPoundsToKg()
        
        let stepOne = 10 * weightConversionFunction
        let stepTwo = 6.25 * heightConversionFunction
        let stepThree = 5 * Double(ageInput)! // Age in Years.
        let stepFour = stepOne + stepTwo - stepThree + 5
        let stepFive = stepFour - chosenGoal.rawValue
        
        return Double(stepFive)
    }
    
    func femaleBMR() -> Double {
        let heightConversionFunction = ConvertHeight()
        let weightConversionFunction = convertPoundsToKg()
        
        let stepOne = 10 * weightConversionFunction
        let stepTwo = 6.25 * heightConversionFunction
        let stepThree = 5 * Double(ageInput)! // Age in Years.
        let stepFour = stepOne + stepTwo - stepThree - 161
        
        return Double(stepFour)
    }
    
    var body: some View {
        ScrollView {
            Spacer()
            Text("Calorie Calculator")
                .bold()
                .font(.title2)
                .padding(.bottom, 50)
                .padding(.top, 50)
            Divider()
                .frame(width: 350)
                .padding(.bottom, 50)
            Text("This calculator will provide you with a guideline for a daily calorie intake. Please be sure to consult with your primary care physician prior to starting any form of diet or physical exercise.")
                .font(.caption)
                .padding(.horizontal, 5)
                .padding(.bottom, 50)
            VStack {
                Text("Please select your gender.")
                    .font(.caption)
                Picker("Gender", selection: $chosenGender) {
                    ForEach(GenderPickerSelector.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom)
                .padding(.horizontal)
                
                Text("Please enter the following information.")
                    .font(.caption)
                HStack {
                    TextField("Age", text: $ageInput)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(ageInput)) { newAgeInput in
                            let filtered = newAgeInput.filter { "0123456789".contains($0) }
                            if filtered != newAgeInput {
                                self.ageInput = filtered
                            }
                        }
                    TextField("Weight (Lbs)", text: $weightInput)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(weightInput)) { newWeightInput in
                            let filtered = newWeightInput.filter { "0123456789".contains($0) }
                            if filtered != newWeightInput {
                                self.weightInput = filtered
                            }
                        }
                }
                .padding(.horizontal)
                HStack {
                    TextField("Feet", text: $heightInFeet)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(heightInFeet)) { newFeetInput in
                            let filtered = newFeetInput.filter { "0123456789".contains($0) }
                            if filtered != newFeetInput {
                                self.heightInFeet = filtered
                            }
                        }
                    
                    TextField("Inches", text: $heightInInches)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(heightInInches)) { newInchesInput in
                            let filtered = newInchesInput.filter { "0123456789".contains($0) }
                            if filtered != newInchesInput {
                                self.heightInInches = filtered
                            }
                        }
                }
                .padding(.bottom, 50)
                .padding(.horizontal)
                Button("Reset") {
                    ageInput = ""
                    weightInput = ""
                    heightInFeet = ""
                    heightInInches = ""
                }
//                Button(action: {
//                    if selectedPage == 0 {
//                        withAnimation { selectedPage = 1 }
//                    }
//                }, label: {
//                    HStack {
//                        Text("Next")
//                        Image(systemName: "arrow.right")
//                    }
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 50)
//                    .padding(.vertical, 15)
//                })
//                .background(Color(.systemBlue))
//                .cornerRadius(10)
//                .shadow(color: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.55)), radius: 5, x: 0.0, y: 0.0)
//                .alert(isPresented: $showAlert) {
//                    Alert(
//                        title: Text("Error!"),
//                        message: Text("You must fill in all fields in order to continue!.")
//                    )
//                }
                Spacer()
            }
        }
    }
    // MARK: - This is causing the gender picker not to work.
//    .onTapGesture(perform: {
//    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    })
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView(chosenGender: .constant(.male), chosenActivityLevel: .constant(.lightlyActive), chosenGoal: .constant(.maintainWeight))
    }
}
