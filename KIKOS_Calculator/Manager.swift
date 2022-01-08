//
//  Manager.swift
//  KIKOS_Calculator
//
//  Created by Kirill Drozdov on 08.01.2022.
//

import Foundation

class CalculatorManager {
    
    enum Operations: Int {
        case add = 0
        case subtract = 1
        case multiplay = 2
        case divide = 3
    }
    
    var calculationArray = [Double]()
    var lastNumber = 0.0
    var lastOperation = 0.0
    var currentNumber = 0.0
    
    func clear() {
        calculationArray = []
        lastNumber = 0.0
        lastOperation = 0.0
        currentNumber = 0.0
    }
    
    func calaculateValue(operation: String) -> Double? {
        if operation == "operation" {
            if calculationArray.count > 3 {
                
                let newValue = calculate(firstNumber: calculationArray[0], secondNumber: calculationArray[2], operation: Int(calculationArray[1]))
                calculationArray.removeAll()
                calculationArray.append(newValue)
                calculationArray.append(lastOperation)
                return calculationArray[0]
            }
        } else if operation == "equals" {
            if calculationArray.count >= 1 {
                let newValue = calculate(firstNumber: calculationArray[0], secondNumber: lastNumber, operation: Int(lastOperation))
                calculationArray.removeAll()
                calculationArray.append(newValue)
                return calculationArray[0]
            }
        }
        return nil
    }
    
    private func calculate( firstNumber: Double, secondNumber: Double, operation: Int) -> Double{
        var total = 0.0
        if let operations = Operations(rawValue: operation) {
        switch operations {
            case .add:
                total =  firstNumber + secondNumber
            case .subtract:
                total =  firstNumber - secondNumber
            case .multiplay:
                total =  firstNumber * secondNumber
            case .divide:
                total =  firstNumber / secondNumber
            }
        }
        return Double(floor(1000*total)/1000)
    }
}
