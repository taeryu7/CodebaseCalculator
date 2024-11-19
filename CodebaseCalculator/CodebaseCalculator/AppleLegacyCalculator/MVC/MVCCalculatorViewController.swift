//
//  MVCCalculatorViewController.swift
//  CodebaseCalculator
//
//  Created by 유태호 on 11/18/24.
//

import UIKit

class MVCCalculatorViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 계산기 모델
    private let calculator = MVCCalculator()
    
    /// 계산기 뷰
    private let calculatorView = MVCCalculatorView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = calculatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        updateDisplay("0")
    }
    
    // MARK: - Setup
    private func setupActions() {
        // 숫자 버튼 액션 설정
        calculatorView.numberButtons.forEach { button in
            button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchDown)
        }
        
        // 연산자 버튼 액션 설정
        calculatorView.operatorButtons.forEach { button in
            button.addTarget(self, action: #selector(operatorButtonTapped(_:)), for: .touchDown)
        }
    }
    
    // MARK: - Display Updates
    private func updateDisplay(_ text: String) {
        calculatorView.resultLabel.text = text
    }
    
    // MARK: - Button Actions
    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text else { return }
        let result = calculator.inputNumber(number)
        updateDisplay(result)
    }
    
    @objc private func operatorButtonTapped(_ sender: UIButton) {
        guard let op = sender.titleLabel?.text else { return }
        
        let result: String
        switch op {
        case "=":
            result = calculator.calculateResult()
        case "AC":
            result = calculator.reset()
        default:
            result = calculator.inputOperator(op)
        }
        
        updateDisplay(result)
    }
}

// MARK: - Preview Provider
#Preview {
    MVCCalculatorViewController()
}
