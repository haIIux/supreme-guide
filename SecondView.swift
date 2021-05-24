//
//  SecondView.swift
//  HealthCalc
//
//  Created by Rob Maltese on 5/24/21.
//

import SwiftUI

struct SecondView: View {
    @State  var chosenGender: GenderPickerSelector
    @State  var chosenActivityLevel: ActivityLevelSelector
    @State  var chosenGoal:  GoalSelector
    @State var showAlert = false
    
    @State var dailyCalories: Double = 0.0
    @State var carbohydrateSlider = 50.0
    @State var fatsSlider = 25.0
    @State var proteinSlider = 25.0
    
    @State var defaultCarbohydrateValue: Double = 0.50
    @State var defaultFatValue: Double = 0.25
    @State var defaultProteinValue: Double = 0.25
    
    @State var carbsOutputText = 0.0
    @State var fatsOutputText = 0.0
    @State var proteinOutputText = 0.0
    
    // Need to figure out how to get said information from Initial View.
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
    
    func carbohydrateMath() -> Double {
        let defaultCarbohydratesValue: Double = 0.50
        let getCarbCalories = dailyCalories * defaultCarbohydratesValue
        let getCarbMacros = getCarbCalories / 4
        
        return getCarbMacros
    }
    
    func fatMath() -> Double {
        let defaultFatValue: Double = 0.25
        let getFatCalories = dailyCalories * defaultFatValue
        let getFatMacros = getFatCalories / 9
        
        return getFatMacros
    }
    
    func proteinMath() -> Double {
        let defaultProteinValue: Double = 0.25
        let getProteinCalories = dailyCalories * defaultProteinValue
        let getProteinMacros = getProteinCalories / 4
        
        return getProteinMacros
    }
    
    func synchronizedSlider(from bindings: [Binding<Double>], index: Int) -> some View {
        return Slider(value: synchronizedBinding(from: bindings, index: index), in: 0...100)
    }
    
    
    func synchronizedBinding(from bindings: [Binding<Double>], index: Int) -> Binding<Double> {
        
        return Binding(get: {
            return bindings[index].wrappedValue
        }, set: { newValue in
            
            let sum = bindings.indices
                .lazy
                .filter{ $0 != index }
                .map{ bindings[$0]
                    .wrappedValue }
                .reduce(0.0, +)
            
            
            let remaining = 100.0 - newValue
            
            if sum != 0.0 {
                for i in bindings.indices {
                    if i != index {
                        bindings[i].wrappedValue = bindings[i].wrappedValue * remaining / sum
                    }
                }
            } else {
                let newOtherValue = remaining / Double(bindings.count - 1)
                for i in bindings.indices {
                    if i != index {
                        bindings[i].wrappedValue = newOtherValue
                    }
                }
            }
            bindings[index].wrappedValue = newValue
            carbsOutputText = carbohydrateMath() / 100
            fatsOutputText = fatMath() / 100
            proteinOutputText = proteinMath() / 100
            
        })
    }
    var body: some View {
        Spacer()
        VStack {
            Text("Please select your activity level.")
                .font(.caption)
            Picker("Activity Level", selection: $chosenActivityLevel) {
                ForEach(ActivityLevelSelector.allCases, id: \.self) {
                    Text($0.description.capitalized)
                }
            }
            Text("Please select your goal.")
                .font(.caption)
            Picker("Goal", selection: $chosenGoal) {
                ForEach(GoalSelector.allCases, id: \.self) {
                    Text($0.description)
                }
            }
            Button(action: {
                
                switch chosenGender {
                case .male:
                    if chosenGoal.description.contains("Mild Weight Gain") {
                        
                        func mildGainChosenActivityLevelMath() -> Double {
                            let bmr = maleBMR()
                            let activityLevel = chosenActivityLevel.rawValue
                            let newBMR = bmr * activityLevel
                            return newBMR
                        }
                        
                        func mildGainChosenGoalLevelMath() -> Double {
                            let newBMR = mildGainChosenActivityLevelMath()
                            let goalSelection = chosenGoal.rawValue
                            let postGoalMathBMR = newBMR * goalSelection
                            return postGoalMathBMR
                        }
                        
                        func addBMRtoChosenGoalMathLevel() -> Double {
                            let bmr = mildGainChosenActivityLevelMath()
                            let goalAdditionAmount = mildGainChosenGoalLevelMath()
                            let dailyCaloriesOutput = bmr + goalAdditionAmount
                            return dailyCaloriesOutput
                        }
                        
                        let newCalorieOutput = addBMRtoChosenGoalMathLevel()
                        
                        dailyCalories = newCalorieOutput
                        dailyCalories = addBMRtoChosenGoalMathLevel()
                        
                    } else if chosenGoal.description.contains("Moderate Weight Gain") {
                        
                        func mildGainChosenActivityLevelMath() -> Double {
                            let bmr = maleBMR()
                            let activityLevel = chosenActivityLevel.rawValue
                            let newBMR = bmr * activityLevel
                            return newBMR
                        }
                        
                        func mildGainChosenGoalLevelMath() -> Double {
                            let newBMR = mildGainChosenActivityLevelMath()
                            let goalSelection = chosenGoal.rawValue
                            let postGoalMathBMR = newBMR * goalSelection
                            return postGoalMathBMR
                        }
                        
                        func addBMRtoChosenGoalMathLevel() -> Double {
                            let bmr = mildGainChosenActivityLevelMath()
                            let goalAdditionAmount = mildGainChosenGoalLevelMath()
                            let dailyCaloriesOutput = bmr + goalAdditionAmount
                            return dailyCaloriesOutput
                        }
                        
                        let newCalorieOutput = addBMRtoChosenGoalMathLevel()
                        
                        dailyCalories = newCalorieOutput
                        
                    } else {
                        let chosenGoalMath = maleBMR() * chosenGoal.rawValue
                        let completedGoalMathNowSubtractCaloriesForWeightLoss = maleBMR() - chosenGoalMath
                        dailyCalories = completedGoalMathNowSubtractCaloriesForWeightLoss * chosenActivityLevel.rawValue
                    }
                case .female:
                    if chosenGoal.description.contains("Mild Weight Gain") {
                        
                        func mildGainChosenActivityLevelMath() -> Double {
                            let bmr = femaleBMR()
                            let activityLevel = chosenActivityLevel.rawValue
                            let newBMR = bmr * activityLevel
                            return newBMR
                        }
                        
                        func mildGainChosenGoalLevelMath() -> Double {
                            let newBMR = mildGainChosenActivityLevelMath()
                            let goalSelection = chosenGoal.rawValue
                            let postGoalMathBMR = newBMR * goalSelection
                            return postGoalMathBMR
                        }
                        
                        func addBMRtoChosenGoalMathLevel() -> Double {
                            let bmr = mildGainChosenActivityLevelMath()
                            let goalAdditionAmount = mildGainChosenGoalLevelMath()
                            let dailyCaloriesOutput = bmr + goalAdditionAmount
                            return dailyCaloriesOutput
                        }
                        
                        let newCalorieOutput = addBMRtoChosenGoalMathLevel()
                        
                        dailyCalories = newCalorieOutput
                        
                    } else if chosenGoal.description.contains("Moderate Weight Gain") {
                        
                        func mildGainChosenActivityLevelMath() -> Double {
                            let bmr = femaleBMR()
                            let activityLevel = chosenActivityLevel.rawValue
                            let newBMR = bmr * activityLevel
                            return newBMR
                        }
                        
                        func mildGainChosenGoalLevelMath() -> Double {
                            let newBMR = mildGainChosenActivityLevelMath()
                            let goalSelection = chosenGoal.rawValue
                            let postGoalMathBMR = newBMR * goalSelection
                            return postGoalMathBMR
                        }
                        
                        func addBMRtoChosenGoalMathLevel() -> Double {
                            let bmr = mildGainChosenActivityLevelMath()
                            let goalAdditionAmount = mildGainChosenGoalLevelMath()
                            let dailyCaloriesOutput = bmr + goalAdditionAmount
                            return dailyCaloriesOutput
                        }
                        
                        let newCalorieOutput = addBMRtoChosenGoalMathLevel()
                        
                        dailyCalories = newCalorieOutput
                    } else {
                        let chosenGoalMath = femaleBMR() * chosenGoal.rawValue
                        let completedGoalMathNowSubtractCaloriesForWeightLoss = femaleBMR() - chosenGoalMath
                        dailyCalories = completedGoalMathNowSubtractCaloriesForWeightLoss * chosenActivityLevel.rawValue
                        print("Calories times Goal = \(chosenGoalMath)")
                        print("New Calories after subtracting goal = \(completedGoalMathNowSubtractCaloriesForWeightLoss)")
                    }
                }
                
                
                
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                // MARK: - Do something here to trigger the sliders?
                carbsOutputText = carbohydrateMath()
                proteinOutputText = proteinMath()
                fatsOutputText = fatMath()
            }, label: {
                Text("Calculate")
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 15)
            })
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .shadow(color: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.55)), radius: 5, x: 0.0, y: 0.0)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error!"),
                    message: Text("You must fill in all fields in order to be able to submit.")
                )
            }
            
        }
        Spacer()
    }
}


struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView(chosenGender: .male, chosenActivityLevel: .lightlyActive, chosenGoal: .maintainWeight)
    }
}
