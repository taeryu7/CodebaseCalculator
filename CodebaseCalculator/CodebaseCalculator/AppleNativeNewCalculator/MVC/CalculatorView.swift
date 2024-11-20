//
//  CalculatorView.swift
//  CodebaseCalculator
//
//  계산기의 사용자 인터페이스를 구성하는 커스텀 뷰
//  버튼, 레이블 등의 UI 요소들과 레이아웃을 관리
//
//  Created by 유태호 on 11/20/24.
//

import UIKit
import SnapKit

/// 계산기의 UI 컴포넌트들을 관리하는 커스텀 뷰 클래스
/// 모든 시각적 요소들의 생성, 배치, 스타일링을 담당
class CalculatorView: UIView {
    
    // MARK: - UI Properties
    
    /// 계산 결과를 표시하는 레이블
    /// 특징:
    /// - 흰색 텍스트
    /// - 80pt 크기의 light 웨이트 폰트
    /// - 우측 정렬
    /// - 자동 폰트 크기 조절 지원
    let displayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 80, weight: .light)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    /// 계산기 아이콘 버튼 (좌측 하단)
    let calculatorIconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// 숫자 버튼 배열 (0-9)
    /// 각 숫자에 대한 버튼을 담고 있는 배열
    let numberButtons: [UIButton] = (0...9).map { _ in UIButton() }
    
    /// 연산자 버튼 배열 (+, -, ×, ÷)
    /// 기본 사칙연산 버튼들을 담고 있는 배열
    let operatorButtons: [UIButton] = (0...3).map { _ in UIButton() }
    
    /// 기능 버튼 배열 (AC, +/-, %, .)
    /// 특수 기능을 수행하는 버튼들을 담고 있는 배열
    /// // 수정 전
    // let functionButtons: [UIButton] = (0...3).map { _ in UIButton() }
    /**
     * 수정 전 - 후간에 차이
     * 기존코드는 (0...3)으로 4개의 버튼을 생성하지만 실제 기능의 버튼은 3개의 기능만 필요로한다.
     * 그래서 (0...2)로 수정해서 적용
     */
    // 수정 후
    let functionButtons: [UIButton] = (0...2).map { _ in UIButton() }
    
    /// 소수점 버튼
    let dotButton = UIButton()
    
    /// 등호 버튼
    let equalButton = UIButton()
    
    // MARK: - Stack Views
    
    /// 가로 방향 스택뷰 배열
    /// 각 행의 버튼들을 담는 컨테이너
    private let horizontalStacks: [UIStackView] = (0...4).map { _ in
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }
    
    /// 세로 방향 스택뷰
    /// 모든 가로 스택뷰를 담는 메인 컨테이너
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: - Initialization
    
    /// 프레임을 기준으로 한 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    /// 스토리보드/XIB를 통한 초기화 메서드
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup Methods
    
    /// UI 초기 설정을 수행하는 메서드
    /// 배경색 설정 및 각종 UI 컴포넌트 초기화
    private func setupUI() {
        backgroundColor = .black
        setupButtons()
        setupStackViews()
        setupConstraints()
        layoutButtons()
    }
    
    /// 버튼들의 기본 설정을 수행하는 메서드
    private func setupButtons() {
        setupCalculatorIconButton()
        setupNumberButtons()
        setupOperatorButtons()
        setupFunctionButtons()
        setupSpecialButtons()
    }
    
    // 계산기 아이콘 버튼 설정 메서드
    private func setupCalculatorIconButton() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(white: 0.23, alpha: 1.0)
        config.baseForegroundColor = .white
        
        // 시스템 키보드 아이콘 설정
        let calConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular)
        let calImage = UIImage(systemName: "keyboard", withConfiguration: calConfig)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        
        config.image = calImage
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        
        calculatorIconButton.configuration = config
    }
    
    /// 숫자 버튼 설정
    private func setupNumberButtons() {
        numberButtons.enumerated().forEach { index, button in
            configureButton(button,
                          title: "\(index)",
                          color: UIColor(white: 0.23, alpha: 1.0))
        }
    }
    
    /// 연산자 버튼 설정
    private func setupOperatorButtons() {
        let operators = ["+", "-", "×", "÷"]
        operatorButtons.enumerated().forEach { index, button in
            configureButton(button,
                          title: operators[index],
                          color: .systemOrange)
        }
    }
    
    /// 기능 버튼 설정
    private func setupFunctionButtons() {
        let functions = ["AC", "+/-", "%"]
        functionButtons.enumerated().forEach { index, button in
            configureButton(button,
                          title: functions[index],
                          color: .lightGray)
        }
    }
    
    /// 특수 버튼 (소수점, 등호) 설정
    private func setupSpecialButtons() {
        configureButton(dotButton,
                       title: ".",
                       color: UIColor(white: 0.23, alpha: 1.0))
        configureButton(equalButton,
                       title: "=",
                       color: .systemOrange)
    }
    
    /// 버튼 기본 설정을 수행하는 메서드
    /// - Parameters:
    ///   - button: 설정할 버튼
    ///   - title: 버튼에 표시될 텍스트
    ///   - color: 버튼의 배경색
    private func configureButton(_ button: UIButton, title: String, color: UIColor) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = color
        configuration.baseForegroundColor = .white
        configuration.title = title
        
        // 연산자 버튼은 더 큰 폰트 사용
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: color == .systemOrange ? 34 : 30)
            return outgoing
        }
        
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 스택뷰 설정 및 버튼 배치를 수행하는 메서드
    private func setupStackViews() {
        // 첫 번째 줄: AC, +/-, %, ÷
        horizontalStacks[0].addArrangedSubview(functionButtons[0])  // AC
        horizontalStacks[0].addArrangedSubview(functionButtons[1])  // +/-
        horizontalStacks[0].addArrangedSubview(functionButtons[2])  // %
        horizontalStacks[0].addArrangedSubview(operatorButtons[3])  // ÷
        
        // 두 번째 줄: 7, 8, 9, ×
        horizontalStacks[1].addArrangedSubview(numberButtons[7])
        horizontalStacks[1].addArrangedSubview(numberButtons[8])
        horizontalStacks[1].addArrangedSubview(numberButtons[9])
        horizontalStacks[1].addArrangedSubview(operatorButtons[2])  // ×
        
        // 세 번째 줄: 4, 5, 6, -
        horizontalStacks[2].addArrangedSubview(numberButtons[4])
        horizontalStacks[2].addArrangedSubview(numberButtons[5])
        horizontalStacks[2].addArrangedSubview(numberButtons[6])
        horizontalStacks[2].addArrangedSubview(operatorButtons[1])  // -
        
        // 네 번째 줄: 1, 2, 3, +
        horizontalStacks[3].addArrangedSubview(numberButtons[1])
        horizontalStacks[3].addArrangedSubview(numberButtons[2])
        horizontalStacks[3].addArrangedSubview(numberButtons[3])
        horizontalStacks[3].addArrangedSubview(operatorButtons[0])  // +
        
        // 다섯 번째 줄: 아이콘, 0, ., =
        horizontalStacks[4].addArrangedSubview(calculatorIconButton)
        horizontalStacks[4].addArrangedSubview(numberButtons[0])
        horizontalStacks[4].addArrangedSubview(dotButton)
        horizontalStacks[4].addArrangedSubview(equalButton)
        
        // 가로 스택뷰들을 세로 스택뷰에 추가
        horizontalStacks.forEach { verticalStack.addArrangedSubview($0) }
        
        // 세로 스택뷰를 메인 뷰에 추가
        addSubview(displayLabel)
        addSubview(verticalStack)
    }
    
    /// Auto Layout 제약조건을 설정하는 메서드
    private func setupConstraints() {
        // 결과 레이블 제약조건
        displayLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(200)
        }
        
        // 버튼 그리드 제약조건
        verticalStack.snp.makeConstraints {
            $0.top.equalTo(displayLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-30)
        }
    }
    
    /// 버튼 크기와 모양을 설정하는 메서드
    private func layoutButtons() {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 20
        let numberOfButtonsPerRow: CGFloat = 4
        let spacing: CGFloat = 12
        
        // 버튼 크기 계산
        let availableWidth = screenWidth - (padding * 2) - (spacing * (numberOfButtonsPerRow - 1))
        let buttonSize = floor(availableWidth / numberOfButtonsPerRow)
        
        // 모든 버튼에 크기와 모양 설정 적용
        let allButtons = [calculatorIconButton] + numberButtons + operatorButtons + functionButtons + [dotButton, equalButton]
        
        allButtons.forEach { button in
            // 크기 설정
            button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            
            // 원형 모양 설정
            button.layer.cornerRadius = buttonSize / 2
            button.clipsToBounds = true
        }
    }
}
