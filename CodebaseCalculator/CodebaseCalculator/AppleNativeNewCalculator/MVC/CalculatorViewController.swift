//
//  CalculatorViewController.swift
//  CodebaseCalculator
//
//  계산기의 View와 Model을 연결하고 사용자 상호작용을 처리하는 컨트롤러
//  사용자 입력을 받아 Model에 전달하고, 그 결과를 View에 업데이트
//
//  Created by 유태호 on 11/20/24.
//

import UIKit

/// 계산기의 비즈니스 로직과 UI를 연결하는 컨트롤러 클래스
/// View와 Model 사이의 중재자 역할을 수행하며 사용자 입력을 처리
class CalculatorViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 계산기 UI를 담당하는 커스텀 뷰 인스턴스
    /// 모든 시각적 요소들과 레이아웃을 관리
    private let calculatorView = CalculatorView()
    
    /// 계산기의 데이터와 비즈니스 로직을 담당하는 모델 인스턴스
    /// 실제 계산과 데이터 처리를 수행
    private let calculatorModel = CalculatorModel()
    
    // MARK: - Lifecycle Methods
    
    /// 뷰 컨트롤러의 뷰가 로드된 후 호출되는 메서드
    /// 초기 UI 설정과 이벤트 핸들러를 연결
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupActions()
        updateDisplay()
    }
    
    // MARK: - Setup Methods
    
    /// 메인 뷰 설정 메서드
    /// 계산기 뷰를 메인 뷰에 추가하고 제약조건 설정
    private func setupView() {
        view.addSubview(calculatorView)
        calculatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()  // 전체 화면을 채우도록 설정
        }
    }
    
    /// 버튼 액션 설정 메서드
    /// 모든 버튼에 대한 터치 이벤트 핸들러를 연결
    private func setupActions() {
        // 숫자 버튼들에 대한 액션 설정
        calculatorView.numberButtons.forEach { button in
            button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        }
        
        // 연산자 버튼들에 대한 액션 설정
        calculatorView.operatorButtons.forEach { button in
            button.addTarget(self, action: #selector(operatorButtonTapped(_:)), for: .touchUpInside)
        }
        
        // 기능 버튼들에 대한 액션 설정
        setupFunctionButtonActions()
    }
    
    /// 기능 버튼들의 액션을 설정하는 메서드
    private func setupFunctionButtonActions() {
        // AC(리셋) 버튼
        calculatorView.functionButtons[0].addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        // +/- (부호 변경) 버튼
        calculatorView.functionButtons[1].addTarget(self, action: #selector(plusMinusButtonTapped), for: .touchUpInside)
        
        // % (퍼센트) 버튼
        calculatorView.functionButtons[2].addTarget(self, action: #selector(percentButtonTapped), for: .touchUpInside)
        
        // . (소수점) 버튼
        calculatorView.dotButton.addTarget(self, action: #selector(dotButtonTapped), for: .touchUpInside)
        
        // = (등호) 버튼
        calculatorView.equalButton.addTarget(self, action: #selector(equalButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action Methods
    
    /// 숫자 버튼이 탭되었을 때 호출되는 메서드
    /// - Parameter sender: 탭된 숫자 버튼
    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text else { return }
        calculatorModel.appendNumber(number)
        updateDisplay()
    }
    
    /// 연산자 버튼이 탭되었을 때 호출되는 메서드
    /// - Parameter sender: 탭된 연산자 버튼
    @objc private func operatorButtonTapped(_ sender: UIButton) {
        guard let operatorSymbol = sender.titleLabel?.text else { return }
        if calculatorModel.appendOperator(operatorSymbol) {
            updateDisplay()
        } else {
            calculatorView.displayLabel.text = "error"
        }
    }
    
    /// 리셋(AC) 버튼이 탭되었을 때 호출되는 메서드
    @objc private func resetButtonTapped() {
        calculatorModel.reset()
        updateDisplay()
    }
    
    /// 부호 변경(+/-) 버튼이 탭되었을 때 호출되는 메서드
    @objc private func plusMinusButtonTapped() {
        calculatorModel.toggleSign()
        updateDisplay()
    }
    
    /// 퍼센트(%) 버튼이 탭되었을 때 호출되는 메서드
    @objc private func percentButtonTapped() {
        calculatorModel.convertToPercentage()
        updateDisplay()
    }
    
    /// 소수점(.) 버튼이 탭되었을 때 호출되는 메서드
    @objc private func dotButtonTapped() {
        calculatorModel.appendDecimalPoint()
        updateDisplay()
    }
    
    /// 등호(=) 버튼이 탭되었을 때 호출되는 메서드
    @objc private func equalButtonTapped() {
        let result = calculatorModel.calculateResult()
        calculatorView.displayLabel.text = result
    }
    
    // MARK: - Helper Methods
    
    /// 화면 표시를 업데이트하는 메서드
    /// 모델의 현재 상태를 뷰에 반영
    private func updateDisplay() {
        calculatorView.displayLabel.text = calculatorModel.currentExpression
    }
}

// MARK: - Preview Provider
/// SwiftUI 프리뷰를 위한 설정
#Preview {
    CalculatorViewController()
}
