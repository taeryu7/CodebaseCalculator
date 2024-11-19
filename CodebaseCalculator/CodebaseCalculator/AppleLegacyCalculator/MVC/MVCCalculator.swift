//
//  Calculator.swift
//  CodebaseCalculator
//
//  Created by 유태호 on 11/18/24.
//

import Foundation

/// 계산기의 상태와 계산 로직을 담당하는 모델
class MVCCalculator {
    /// 현재 계산기에 표시된 텍스트
    private(set) var displayText: String = "0"
    
    /// 새로운 계산 시작 여부
    private var isNewCalculation: Bool = false
    
    /// 숫자 입력 처리
    func inputNumber(_ number: String) -> String {
        if displayText == "0" || isNewCalculation {
            displayText = number
            isNewCalculation = false
        } else {
            displayText += number
        }
        return displayText
    }
    
    /// 연산자 입력 처리
    func inputOperator(_ op: String) -> String {
        if displayText == "0" {
            if op == "-" {
                displayText = op
            } else {
                return "error"
            }
        } else if isLastCharacterOperator() {
            return "error"
        } else {
            displayText += op
            isNewCalculation = false
        }
        return displayText
    }
    
    /// 계산 실행
    func calculateResult() -> String {
        if displayText == "0" {
            return "error"
        } else if isLastCharacterOperator() {
            return "error"
        } else {
            if let result = calculate(expression: displayText) {
                displayText = "\(result)"
                isNewCalculation = true
                return displayText
            } else {
                return "error"
            }
        }
    }
    
    /// 초기화
    func reset() -> String {
        displayText = "0"
        isNewCalculation = false
        return displayText
    }
    
    /// 마지막 문자가 연산자인지 확인
    private func isLastCharacterOperator() -> Bool {
        let operators = ["+", "-", "*", "/"]
        guard let lastChar = displayText.last.map(String.init) else { return false }
        return operators.contains(lastChar)
    }
    
    /// 수식 계산
    private func calculate(expression: String) -> Int? {
        let expression = NSExpression(format: expression)
        return expression.expressionValue(with: nil, context: nil) as? Int
    }
}
