//
//  CalculatorViewModel.swift
//  CodebaseCalculator
//
//  Created by 유태호 on 11/18/24.
//

import Foundation

/// 계산기의 비즈니스 로직을 처리하는 ViewModel
class CalculatorViewModel {
    // MARK: - Properties
    
    /// 화면에 표시될 텍스트가 변경될 때 호출되는 클로저
    /// - Parameter: 변경된 화면 표시 텍스트
    /// - Note: ViewController에서 이 클로저를 통해 화면을 업데이트
    var displayTextChanged: ((String) -> Void)?
    
    /// 현재 계산기의 상태를 저장하는 모델
    /// - Note: 모델이 변경될 때마다 displayTextChanged 클로저를 통해 View에 알림
    private var model: CalculatorModel = .initial() {
        didSet {
            displayTextChanged?(model.displayText)
        }
    }
    
    // MARK: - Public Methods
    
    /// 숫자 버튼 입력을 처리하는 메서드
    /// - Parameter number: 입력된 숫자 문자열 ("0"~"9")
    /// - Note:
    ///   1. 초기 상태("0") 또는 새로운 계산 시작 시 -> 입력된 숫자로 대체
    ///   2. 계산 진행 중 -> 기존 수식에 숫자 추가
    func inputNumber(_ number: String) {
        if model.displayText == "0" || model.isNewCalculation {
            model.displayText = number
            model.isNewCalculation = false
        } else {
            model.displayText += number
        }
    }
    
    /// 연산자 버튼 입력을 처리하는 메서드
    /// - Parameter op: 입력된 연산자 ("+", "-", "*", "/")
    /// - Note:
    ///   1. 첫 입력이 연산자인 경우:
    ///      - "-"는 음수 표현을 위해 허용
    ///      - 다른 연산자는 에러 표시
    ///   2. 연속된 연산자 입력 시 에러 표시
    ///   3. 정상적인 경우 수식에 연산자 추가
    func inputOperator(_ op: String) {
        if model.displayText == "0" {
            if op == "-" {
                model.displayText = op
            } else {
                model.displayText = "error"
            }
        } else if isLastCharacterOperator() {
            model.displayText = "error"
        } else {
            model.displayText += op
            model.isNewCalculation = false
        }
    }
    
    /// 계산기 초기화 메서드
    /// - Note: 모든 상태를 초기값으로 리셋
    ///   - displayText = "0"
    ///   - isNewCalculation = false
    func resetCalculator() {
        model = .initial()
    }
    
    /// 계산 결과를 처리하는 메서드
    /// - Note:
    ///   1. 수식이 비어있는 경우(0) 에러 표시
    ///   2. 마지막 입력이 연산자인 경우 에러 표시
    ///   3. 정상적인 경우:
    ///   - 수식 계산 수행
    ///   - 결과 표시
    ///   - 새로운 계산 시작 상태로 설정
    func calculateResult() {
        if model.displayText == "0" {
            model.displayText = "error"
        } else if isLastCharacterOperator() {
            model.displayText = "error"
        } else {
            if let result = calculate(expression: model.displayText) {
                model.displayText = "\(result)"
                model.isNewCalculation = true
            } else {
                model.displayText = "error"
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// 마지막 문자가 연산자인지 확인하는 메서드
    /// - Returns: 마지막 문자가 연산자이면 true, 아니면 false
    /// - Note:
    /// - 검사하는 연산자: ["+", "-", "*", "/"]
    /// - 문자열이 비어있는 경우 false 반환
    private func isLastCharacterOperator() -> Bool {
        let operators = ["+", "-", "*", "/"]
        guard let lastChar = model.displayText.last.map(String.init) else { return false }
        return operators.contains(lastChar)
    }
    
    /// 수식을 계산하는 메서드
    /// - Parameter expression: 계산할 수식 문자열 (예: "123+456")
    /// - Returns: 계산 결과값 (Int?). 계산 실패 시 nil 반환
    /// - Note:
    /// - NSExpression을 사용하여 문자열 수식을 계산
    /// - 정수 계산만 지원
    /// - 잘못된 수식이나 계산 실패 시 nil 반환
    private func calculate(expression: String) -> Int? {
        let expression = NSExpression(format: expression)
        return expression.expressionValue(with: nil, context: nil) as? Int
    }
}
