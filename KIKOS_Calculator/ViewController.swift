//
//  ViewController.swift
//  KIKOS_Calculator
//
//  Created by Kirill Drozdov on 08.01.2022.
//


import UIKit
import SnapKit
class ViewController: UIViewController {

    var calculatorManager = CalculatorManager()
    var isValidPress = false
    var clearDisplay = false
    
    var verticalStack = UIStackView()
    var resultLabel = UILabel()
    var zeroButton = UIButton()
    var periodButton = UIButton()
    var equalsButton = UIButton()
    
    var listOfButtonsToResize = [UIButton]()
    
    var textForFirstColumnButtons =  ["AC"  , "7"   ,  "4"  ,   "1" ,   "0" ]
    var textForSecondColumnButtons = ["⁺∕₋" , "8"   ,  "5"  ,   "2" ,   ""  ]
    var textForThirdColumnButtons =  ["%"   , "9"   ,  "6"  ,   "3" ,   "." ]
    var textForFourthColumnButtons = ["÷"   , "*"   ,  "-"  ,   "+" ,   "=" ]

    override func viewDidLoad() {
        view.backgroundColor = .black
        setUpMainStackView()
        setUpChildrensOFMainStackView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        for button in listOfButtonsToResize {
            if button.currentTitle! != "0" {
                button.bounds.size.height = button.bounds.size.width
                button.layer.cornerRadius = 0.5 * button.bounds.size.width
            }
            else {
                button.clipsToBounds = true
                button.bounds.size.height = periodButton.bounds.size.height - 12
                button.layer.cornerRadius = 0.25 * button.bounds.size.width
            }
        }
    }
    
    func setUpMainStackView() {
        view.addSubview(verticalStack)
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = 1
        verticalStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().inset(0)
            make.leading.equalToSuperview().inset(0)
            make.trailing.equalToSuperview().inset(0)
        }
    }
    
    func setUpChildrensOFMainStackView() {
        for i in 0...6 {
            let horizontalStackView = UIStackView()
            horizontalStackView.spacing = 10
            horizontalStackView.axis = .horizontal
            
            if i == 1{
                horizontalStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
                horizontalStackView.isLayoutMarginsRelativeArrangement =  true
                addDisplayLabel(view: horizontalStackView)
            
            }
            else if i >= 2 {
                addButtonsToStackView(view: horizontalStackView, forRowAt: i)
            }
            if i < 6 {
                verticalStack.addArrangedSubview(horizontalStackView)
                horizontalStackView.distribution = .fillEqually
            }
            else {
                resizeZeroButton(view: horizontalStackView)
                verticalStack.addArrangedSubview(horizontalStackView)
                verticalStack.distribution = .fillEqually
            }
            
        }
    }
    
    func resizeZeroButton(view: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addArrangedSubview(zeroButton)
        view.addArrangedSubview(periodButton)
        view.addArrangedSubview(equalsButton)
        
        zeroButton.widthAnchor.constraint(equalTo: self.periodButton.widthAnchor, multiplier: 2.0).isActive = true
        zeroButton.widthAnchor.constraint(equalTo: self.equalsButton.widthAnchor, multiplier: 2.0).isActive = true

    }
    
    func addDisplayLabel(view: UIStackView) {
        resultLabel.font = resultLabel.font.withSize(56)
        resultLabel.textAlignment = .right
        resultLabel.textColor = .white
        resultLabel.text = ""
        view.addArrangedSubview(resultLabel)
    }
    
    func addButtonsToStackView(view: UIStackView, forRowAt: Int) {
        let horizontalStackRow = forRowAt-2
        for i in 0...3 {
            let button = UIButton(type: .system)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .medium)
            button.setTitleColor(.white, for: .normal)
            
            if forRowAt == 2 {
                button.backgroundColor = .systemGray
            } else {
                button.backgroundColor = .systemGray2
            }
            
            switch i {
            case 0:
                button.setTitle(textForFirstColumnButtons[horizontalStackRow], for: .normal)
                if horizontalStackRow == 0 {
                    button.addTarget(self, action: #selector(clearClick), for: .touchUpInside)
                    button.setTitleColor(.black, for: .normal)
                    button.backgroundColor = .red
                    view.addArrangedSubview(button)
                }
                else if horizontalStackRow == 4{
                    button.addTarget(self, action: #selector(numberButtonClick), for: .touchUpInside)
                    button.backgroundColor = .purple
                    zeroButton = button
                }
                else {
                    button.addTarget(self, action: #selector(numberButtonClick), for: .touchUpInside)
                    button.backgroundColor = .orange
                    view.addArrangedSubview(button)
                }
            case 1:
                button.setTitle(textForSecondColumnButtons[horizontalStackRow], for: .normal)
                if horizontalStackRow == 0 {
                    button.addTarget(self, action: #selector(plusMinusClick), for: .touchUpInside)
                    button.setTitleColor(.black, for: .normal)
                    button.backgroundColor = .blue
                    view.addArrangedSubview(button)
                }
                else if horizontalStackRow != 4{
                    button.addTarget(self, action: #selector(numberButtonClick), for: .touchUpInside)
                    button.backgroundColor = .orange
                    view.addArrangedSubview(button)
                }
            case 2:
                button.setTitle(textForThirdColumnButtons[horizontalStackRow], for: .normal)
                if horizontalStackRow == 0 {
                    button.addTarget(self, action: #selector(procentClick), for: .touchUpInside)
                    button.setTitleColor(.black, for: .normal)
                    button.backgroundColor = .green
                    view.addArrangedSubview(button)
                }
                else if horizontalStackRow == 4 {
                    button.addTarget(self, action: #selector(periodButtonClick), for: .touchUpInside)
                    button.backgroundColor = .red
                    periodButton = button
                }
                else {
                    button.addTarget(self, action: #selector(numberButtonClick), for: .touchUpInside)
                    button.backgroundColor = .orange
                    view.addArrangedSubview(button)
                }
            case 3:
                button.setTitle(textForFourthColumnButtons[horizontalStackRow], for: .normal)
                button.backgroundColor = .orange
                button.titleLabel?.font = UIFont.systemFont(ofSize: 46, weight: .regular)
                if horizontalStackRow == 4 {
                    button.addTarget(self, action: #selector(equalsButtonClick), for: .touchUpInside)
                    equalsButton = button
                }
                else {
                    button.addTarget(self, action: #selector(operatorClick), for: .touchUpInside)
                    button.tag = 3 - horizontalStackRow
                    view.addArrangedSubview(button)
                }
            default:
                print("")
            }
            listOfButtonsToResize.append(button)
        }
    }
    
    @objc func equalsButtonClick(sender: UIButton) {
        isValidPress = true
        calculatorManager.lastNumber = calculatorManager.currentNumber
        if let result = calculatorManager.calaculateValue(operation: "equals") {
            resultLabel.text = getResultAsString(result: result)
            print(result)
        }
    }
    
    @objc func operatorClick(sender: UIButton) {
        
        clearDisplay = true
        if isValidPress {
            if calculatorManager.calculationArray.count == 1 {
                calculatorManager.calculationArray.append(Double(sender.tag))
            }
            else {
                calculatorManager.calculationArray.append(calculatorManager.currentNumber)
                calculatorManager.calculationArray.append(Double(sender.tag))
            }
        }
        calculatorManager.lastOperation = Double(sender.tag)
        if let result = calculatorManager.calaculateValue(operation: "operation") {
            resultLabel.text = getResultAsString(result: result)
            print(result)
        }
        isValidPress = false
    }
    
    @objc func clearClick(sender: UIButton) {
        clearDisplay = false
        isValidPress = false
        calculatorManager.clear()
        resultLabel.text = ""
    }
    
    @objc func plusMinusClick(sender: UIButton) {
        calculatorManager.currentNumber = calculatorManager.currentNumber * (-1)
        resultLabel.text = String(calculatorManager.currentNumber)
    }
    
    @objc func procentClick(sender: UIButton) {
        calculatorManager.currentNumber = calculatorManager.currentNumber * (0.01)
        resultLabel.text = String(calculatorManager.currentNumber)
    }
    
    @objc func numberButtonClick(sender: UIButton) {
        isValidPress = true
        if clearDisplay == true {
            resultLabel.text = ""
            clearDisplay = false
        }
        resultLabel.text! += sender.titleLabel!.text!
        calculatorManager.currentNumber = Double(resultLabel.text!)!
    }
    
   
    @objc func periodButtonClick(sender: UIButton) {
        if !((resultLabel.text)?.contains("."))! {
            resultLabel.text! += "."
        }
    }
 
    func getResultAsString(result: Double?) -> String{
        if let result = result {
            if result.rounded(.up) == result.rounded(.down){
                return String(Int(result))
            }else{
                return String(result)
            }
        } else {
            return String()
        }
    }
}


