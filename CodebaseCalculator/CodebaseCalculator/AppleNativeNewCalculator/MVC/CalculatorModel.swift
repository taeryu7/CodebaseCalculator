//
//  CalculatorModel.swift
//  CodebaseCalculator
//
//  계산기의 데이터 모델과 비즈니스 로직을 담당하는 클래스
//  수식의 저장, 계산, 상태 관리 등을 처리
//
//  Created by 유태호 on 11/20/24.
//

import Foundation

/// 계산기의 데이터와 비즈니스 로직을 처리하는 모델 클래스
/// 수식의 저장, 계산, 상태 관리 등 계산기의 핵심 기능을 담당
class CalculatorModel {
    
    // MARK: - Properties
    /// 현재 계산기에 표시되는 수식 또는 숫자를 저장하는 프로퍼티
    /// 외부에서는 읽기만 가능하고 내부에서만 수정 가능
    /// 초기값은 "0"으로 설정
    private(set) var currentExpression: String = "0"
    
    /// 새로운 계산 시작 여부를 나타내는 플래그
    /// true일 경우 다음 숫자 입력 시 현재 표시된 숫자를 대체
    /// false일 경우 기존 숫자에 이어서 입력
    private(set) var isNewCalculation: Bool = false
    
    // MARK: - Public Methods
    /// 계산기의 상태를 초기화하는 메서드
    /// currentExpression을 "0"으로, isNewCalculation을 false로 리셋
    func reset() {
        currentExpression = "0"
        isNewCalculation = false
    }
    
    /// 숫자를 입력받아 처리하는 메서드
    /// - Parameter number: 입력된 숫자 문자열
    /// 현재 수식이 "0"이거나 새로운 계산 시작인 경우 숫자를 대체하고,
    /// 그렇지 않은 경우 기존 수식에 숫자를 이어붙임
    func appendNumber(_ number: String) {
        if currentExpression == "0" || isNewCalculation {
            currentExpression = number
            isNewCalculation = false
        } else {
            currentExpression += number
        }
    }
    
    /// 연산자를 입력받아 처리하는 메서드
    /// - Parameter operatorSymbol: 입력된 연산자 문자열
    /// - Returns: 연산자 추가 성공 여부 (연산자 중복 입력 방지)
    func appendOperator(_ operatorSymbol: String) -> Bool {
        // 마지막 문자가 연산자인 경우 추가 실패
        if isLastCharacterOperator() {
            return false
        }
        currentExpression += operatorSymbol
        isNewCalculation = false
        return true
    }
    
    /// 현재 수식을 계산하는 메서드
    /// - Returns: 계산 결과 문자열 또는 에러 메시지
    /// 계산이 성공하면 결과값을, 실패하면 "error" 반환
    func calculateResult() -> String {
        // 수식이 "0"이거나 연산자로 끝나는 경우 에러
        if currentExpression == "0" || isLastCharacterOperator() {
            return "error"
        }
        
        // 수식 계산 시도
        if let result = calculate(expression: currentExpression) {
            // 결과가 정수면 소수점 제거, 소수면 그대로 표시
            if result.truncatingRemainder(dividingBy: 1) == 0 {
                currentExpression = String(format: "%.0f", result)
            } else {
                currentExpression = "\(result)"
            }
            isNewCalculation = true
            return currentExpression
        }
        return "error"
    }
    
    /// 현재 숫자의 부호를 변경하는 메서드
    /// 문자열을 숫자로 변환 후 부호를 반전하여 다시 문자열로 저장
    func toggleSign() {
        if let number = Double(currentExpression) {
            currentExpression = "\(-number)"
        }
    }
    
    /// 현재 숫자를 백분율로 변환하는 메서드
    /// 입력된 숫자를 100으로 나누어 퍼센트 값으로 변환
    func convertToPercentage() {
        if let number = Double(currentExpression) {
            currentExpression = "\(number / 100)"
        }
    }
    
    /// 소수점을 추가하는 메서드
    /// 현재 수식에 소수점이 없는 경우에만 추가
    func appendDecimalPoint() {
        if !currentExpression.contains(".") {
            currentExpression += "."
        }
    }
    
    // MARK: - Private Helper Methods
    /// 현재 수식의 마지막 문자가 연산자인지 확인하는 메서드
    /// - Returns: 마지막 문자가 연산자이면 true, 아니면 false
    private func isLastCharacterOperator() -> Bool {
        let operators = ["+", "−", "×", "÷"]
        guard let lastChar = currentExpression.last.map(String.init) else { return false }
        return operators.contains(lastChar)
    }
    
    /// 문자열 형태의 수식을 계산하는 메서드
    /// - Parameter expression: 계산할 수식 문자열
    /// - Returns: 계산 결과값 (실패시 nil)
    private func calculate(expression: String) -> Double? {
        // 수식에 사용된 연산자를 실제 계산 가능한 형태로 변환
        var expr = expression
        expr = expr.replacingOccurrences(of: "×", with: "*")  // 곱하기 기호 변환
        expr = expr.replacingOccurrences(of: "÷", with: "/")  // 나누기 기호 변환
        expr = expr.replacingOccurrences(of: "−", with: "-")  // 빼기 기호 변환
        
        // NSExpression을 사용하여 수식 계산 수행
        let mathExpression = NSExpression(format: expr)
        return mathExpression.expressionValue(with: nil, context: nil) as? Double
    }
}
