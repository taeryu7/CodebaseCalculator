//
//  CalculatorModel.swift
//  CodebaseCalculator
//
//  Created by 유태호 on 11/18/24.
//

import Foundation

/// 계산기의 상태를 나타내는 모델
struct CalculatorModel {
    /// 현재 입력된 수식 또는 결과값
    var displayText: String
    /// 새로운 계산 시작 여부
    var isNewCalculation: Bool
    
    /// 초기 상태 생성
    static func initial() -> CalculatorModel {
        return CalculatorModel(displayText: "0", isNewCalculation: false)
    }
}
