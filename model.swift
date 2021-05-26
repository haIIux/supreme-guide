//
//  CalorieModel.swift
//  singledOutCaloriePage
//
//  Created by Rob Maltese on 5/24/21.
//

import SwiftUI

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

struct ViewOneData {
    // Pickers
    var chosenGender: GenderPickerSelector
    var chosenActivityLevel: ActivityLevelSelector
    var chosenGoal: GoalSelector
    
    // Alert State
    var showAlert = false
    
    // Referencing other data model.
//    var userData: UserData = UserData()
}

struct UserData {
    
    // Sliders
    var carbohydrateSlider = 50.0
    var fatsSlider = 25.0
    var proteinSlider = 25.0
    
    var defaultCarbSlider = 50.0
    var defaultFatSlider = 25.0
    var defaultProteinSlider = 25.0
    
    // Output Text
    var carbsOutputText = 0.0
    var fatsOutputText = 0.0
    var proteinOutputText = 0.0
}

struct UserInputData {
    var dailyCalories: Double = 0.0

    // TextField Inputs?
     @Binding var ageInput: Int
     @Binding var weightInput: Int
     @Binding var heightInFeet: Int
     @Binding var heightInInches: Int
    
    init(ageInput: Binding<Int>, weightInput: Binding<Int>, heightInFeet: Binding<Int>, heightInInches: Binding<Int>) {
        self._ageInput = ageInput
        self._weightInput = weightInput
        self._heightInFeet = heightInFeet
        self._heightInInches = heightInInches
    }
}

extension UserInputData {
    
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
    
    func convertHeight() -> Double {
        let convertHeight = Double() * 12
        let addInches = convertHeight + Double(heightInInches)
        
        let centimetersReturn = addInches * 2.54
        
        // Returns height in centimeters.
        return centimetersReturn
    }
    
    func convertPoundsToKg() -> Double {
        let userWeightInput = weightInput
        let performConversion = userWeightInput // 2.2046 // Number is the conversion number.
        
        return Double(performConversion)
    }
    
    func maleBMR(for chosenValue: GoalSelector) -> Double {
        let heightConversionFunction = convertHeight()
        let weightConversionFunction = convertPoundsToKg()
        
        let stepOne = 10 * weightConversionFunction
        let stepTwo = 6.25 * heightConversionFunction
        let stepThree = 5 * Double(ageInput) // Age in Years.
        let stepFour = Double(stepOne + stepTwo) - stepThree + 5
        let stepFive = stepFour - chosenValue.rawValue
        
        return Double(stepFive)
    }
    
    func femaleBMR() -> Double {
        let heightConversionFunction = convertHeight()
        let weightConversionFunction = convertPoundsToKg()
        
        let stepOne = 10 * weightConversionFunction
        let stepTwo = 6.25 * heightConversionFunction
        let stepThree = 5 * Double(ageInput) // Age in Years.
        let stepFour = stepOne + stepTwo - stepThree - 161
        
        return Double(stepFour)
    }
}


class ViewOneObject: ObservableObject {
    @Published var viewOneData: ViewOneData
    
    init(viewOneData: ViewOneData) {
        self.viewOneData = viewOneData
    }
}


