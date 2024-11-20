//
//  NewCalculator.swift
//  CodebaseCalculator
//
//  iOS 계산기 앱을 구현한 뷰 컨트롤러
//  기본적인 사칙연산과 함께 퍼센트, 부호 변경 등의 추가 기능을 제공
//  Created by 유태호 on 11/19/24.
//

import UIKit
import SnapKit

class NewCalculator: UIViewController {
    
    // MARK: - Properties (속성)
    /// 계산기에 표시되는 현재 숫자 또는 수식을 저장하는 변수
    /// 사용자가 입력한 숫자나 계산식이 문자열 형태로 저장됨
    /// 초기값은 "0"으로 설정
    private var firstNumber = "0"
    
    /// 새로운 계산 시작 여부를 판단하는 플래그
    /// true일 경우 다음 숫자 입력 시 현재 표시된 숫자를 대체함
    /// false일 경우 기존 숫자에 이어서 입력
    /// 예: 계산 결과가 표시된 후 새로운 숫자를 입력할 때 사용
    private var isNewCalculation = false
    
    // MARK: - UI Components (UI 구성요소)
    /// 계산 결과를 표시하는 메인 레이블
    /// 주요 특징:
    /// - 흰색 텍스트 사용
    /// - 80pt 크기의 light 웨이트 폰트
    /// - 우측 정렬로 숫자 표시
    /// - 긴 숫자도 표시할 수 있도록 자동 크기 조절
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 80, weight: .light)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true  // 텍스트가 길어질 경우 자동으로 폰트 크기 조절
        label.minimumScaleFactor = 0.5          // 폰트 크기는 최소 원본의 50%까지 축소 가능
        return label
    }()
    
    // MARK: - Buttons (버튼)
    // 첫 번째 줄 버튼들 - 기능 버튼
    private let resetButton = UIButton()      // AC: 모든 입력을 초기화
    private let plusMinusButton = UIButton()  // +/-: 양수/음수 전환
    private let percentButton = UIButton()    // %: 퍼센트 값으로 변환
    private let dividButton = UIButton()      // ÷: 나누기 연산
    
    // 두 번째 줄 버튼들 - 숫자 7,8,9와 곱하기
    private let sevenButton = UIButton()      // 숫자 7
    private let eightButton = UIButton()      // 숫자 8
    private let nineButton = UIButton()       // 숫자 9
    private let multplyButton = UIButton()    // ×: 곱하기 연산
    
    // 세 번째 줄 버튼들 - 숫자 4,5,6과 빼기
    private let fourButton = UIButton()       // 숫자 4
    private let fiveButton = UIButton()       // 숫자 5
    private let sixButton = UIButton()        // 숫자 6
    private let minusButton = UIButton()      // −: 빼기 연산
    
    // 네 번째 줄 버튼들 - 숫자 1,2,3과 더하기
    private let oneButton = UIButton()        // 숫자 1
    private let twoButton = UIButton()        // 숫자 2
    private let threeButton = UIButton()      // 숫자 3
    private let plusButton = UIButton()       // +: 더하기 연산
    
    // 다섯 번째 줄 버튼들 - 0, 소수점, 등호
    private let zeroButton = UIButton()       // 계산기 아이콘 (왼쪽)
    private let zeroButton2 = UIButton()      // 숫자 0 (가운데)
    private let dotButton = UIButton()        // .: 소수점
    private let equalButton = UIButton()      // =: 계산 실행
    
    // MARK: - Stack Views (스택뷰)
    /// 각 행의 버튼들을 담는 가로 스택뷰들
    /// 버튼들을 수평으로 정렬하고 일정한 간격을 유지
    private let stackView = UIStackView()     // 첫 번째 줄: AC, +/-, %, ÷
    private let stackView1 = UIStackView()    // 두 번째 줄: 7, 8, 9, ×
    private let stackView2 = UIStackView()    // 세 번째 줄: 4, 5, 6, −
    private let stackView3 = UIStackView()    // 네 번째 줄: 1, 2, 3, +
    private let stackView4 = UIStackView()    // 다섯 번째 줄: 아이콘, 0, ., =
    
    /// 모든 가로 스택뷰를 담는 세로 스택뷰
    /// 특징:
    /// - 세로 방향으로 버튼들을 배치
    /// - 각 행 사이에 10pt 간격 유지
    /// - 모든 행이 동일한 높이를 가지도록 설정
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Lifecycle Methods (생명주기 메서드)
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorUI()  // UI 초기화 및 설정
    }
    
    // MARK: - UI Setup Methods (UI 설정 메서드)
    /// 계산기의 전체적인 UI를 설정하는 메서드
    /// 실행 순서:
    /// 1. 배경색 설정
    /// 2. 버튼 설정
    /// 3. 스택뷰 설정
    /// 4. 제약조건 설정
    /// 5. 버튼 레이아웃 설정
    private func calculatorUI() {
        view.backgroundColor = .black
        setupButtons()      // 버튼 설정
        setupStackViews()   // 스택뷰 설정
        setupConstraints()  // 제약조건 설정
        layoutButtons()     // 버튼 레이아웃 설정
    }
    
    /// 일반 숫자 버튼의 기본 스타일을 설정하는 메서드
    /// - Parameters:
    ///   - button: 스타일을 적용할 UIButton 인스턴스
    ///   - title: 버튼에 표시될 텍스트
    /// Configuration을 사용하여 현대적인 버튼 스타일 적용
    private func setupButton(_ button: UIButton, title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = UIColor(white: 0.23, alpha: 1.0)  // 어두운 회색
        configuration.baseForegroundColor = .white  // 흰색 텍스트
        configuration.title = title
        
        // 폰트 설정
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 30)
            return outgoing
        }
        
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 특수 버튼(연산자, AC 등)의 스타일을 설정하는 메서드
    /// - Parameters:
    ///   - button: 스타일을 적용할 UIButton 인스턴스
    ///   - title: 버튼에 표시될 텍스트
    ///   - color: 버튼의 배경색 (주황색 또는 회색)
    private func colorButton(_ button: UIButton, title: String, color: UIColor) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = color
        configuration.baseForegroundColor = .white
        configuration.title = title
        
        // 폰트 설정 (숫자 버튼보다 크게)
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 34)
            return outgoing
        }
        
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 계산기 아이콘 버튼을 설정하는 메서드
    /// zeroButton에 계산기 아이콘을 표시
    private func setupCalculatorIconButton(_ button: UIButton) {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(white: 0.23, alpha: 1.0)
        config.baseForegroundColor = .white
        
        // 시스템 키보드 아이콘 설정
        let calConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular)
        let calImage = UIImage(systemName: "keyboard", withConfiguration: calConfig)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        
        config.image = calImage
        
        // 여백 및 크기 설정
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        
        button.configuration = config
    }
    
    /// 모든 버튼의 크기와 모서리를 설정하는 메서드
    /// 화면 크기에 따라 동적으로 버튼 크기를 계산하여 적용
    private func layoutButtons() {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 20
        let numberOfButtonsPerRow: CGFloat = 4
        let spacing: CGFloat = 12
        
        // 사용 가능한 너비에서 버튼 크기 계산
        let availableWidth = screenWidth - (padding * 2) - (spacing * (numberOfButtonsPerRow - 1))
        let buttonSize = floor(availableWidth / numberOfButtonsPerRow)  // 정수로 반올림
        
        let allButtons = [
            resetButton, plusMinusButton, percentButton, dividButton,
            sevenButton, eightButton, nineButton, multplyButton,
            fourButton, fiveButton, sixButton, minusButton,
            oneButton, twoButton, threeButton, plusButton,
            zeroButton, zeroButton2, dotButton, equalButton
        ]
        
        allButtons.forEach { button in
            // 크기 제약조건 설정
            button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            
            // 완벽한 원형으로 만들기
            button.layer.cornerRadius = buttonSize / 2
            button.clipsToBounds = true
        }
    }
    
    /// 모든 버튼의 초기 설정을 수행하는 메서드
    private func setupButtons() {
        // 계산기 아이콘 버튼 설정
        setupCalculatorIconButton(zeroButton)
        
        // 숫자 버튼 설정
        setupButton(zeroButton2, title: "0")
        setupButton(oneButton, title: "1")
        setupButton(twoButton, title: "2")
        setupButton(threeButton, title: "3")
        setupButton(fourButton, title: "4")
        setupButton(fiveButton, title: "5")
        setupButton(sixButton, title: "6")
        setupButton(sevenButton, title: "7")
        setupButton(eightButton, title: "8")
        setupButton(nineButton, title: "9")
        setupButton(dotButton, title: ".")
        
        // 연산자 버튼 설정
        colorButton(resetButton, title: "AC", color: .lightGray)
        colorButton(plusMinusButton, title: "+/-", color: .lightGray)
        colorButton(percentButton, title: "%", color: .lightGray)
        colorButton(dividButton, title: "÷", color: .systemOrange)
        colorButton(multplyButton, title: "×", color: .systemOrange)
        colorButton(minusButton, title: "−", color: .systemOrange)
        colorButton(plusButton, title: "+", color: .systemOrange)
        colorButton(equalButton, title: "=", color: .systemOrange)
        
        setupButtonActions()  // 버튼 동작 설정
    }
    
    /// 스택뷰들의 초기 설정을 수행하는 메서드
    private func setupStackViews() {
        // 스택뷰들의 기본 설정
        [stackView, stackView1, stackView2, stackView3, stackView4].forEach {
            $0.axis = .horizontal            // 가로 방향 정렬
            $0.spacing = 12                  // 버튼 사이 간격
            $0.distribution = .equalSpacing  // 균등 간격
            $0.alignment = .center          // 중앙 정렬
        }
        
        // 세로 스택뷰 설정
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 12  // 행 사이의 간격
        verticalStackView.distribution = .equalSpacing
        verticalStackView.alignment = .fill
        
        // 첫번째 줄 (AC, +/-, %, ÷)
        stackView.addArrangedSubview(resetButton)
        stackView.addArrangedSubview(plusMinusButton)
        stackView.addArrangedSubview(percentButton)
        stackView.addArrangedSubview(dividButton)
        
        // 두번째 줄 (7, 8, 9, ×)
        stackView1.addArrangedSubview(sevenButton)
        stackView1.addArrangedSubview(eightButton)
        stackView1.addArrangedSubview(nineButton)
        stackView1.addArrangedSubview(multplyButton)
        
        // 세번째 줄 (4, 5, 6, -)
        stackView2.addArrangedSubview(fourButton)
        stackView2.addArrangedSubview(fiveButton)
        stackView2.addArrangedSubview(sixButton)
        stackView2.addArrangedSubview(minusButton)
        
        // 네번째 줄 (1, 2, 3, +)
        stackView3.addArrangedSubview(oneButton)
        stackView3.addArrangedSubview(twoButton)
        stackView3.addArrangedSubview(threeButton)
        stackView3.addArrangedSubview(plusButton)
        
        // 다섯번째 줄 (아이콘, 0, ., =)
        stackView4.addArrangedSubview(zeroButton)
        stackView4.addArrangedSubview(zeroButton2)
        stackView4.addArrangedSubview(dotButton)
        stackView4.addArrangedSubview(equalButton)
        
        // 수직 스택뷰에 모든 행 추가
        verticalStackView.addArrangedSubview(stackView)
        verticalStackView.addArrangedSubview(stackView1)
        verticalStackView.addArrangedSubview(stackView2)
        verticalStackView.addArrangedSubview(stackView3)
        verticalStackView.addArrangedSubview(stackView4)
        
        // 메인 뷰에 추가
        view.addSubview(label)
        view.addSubview(verticalStackView)
    }
    
    /// Auto Layout 제약조건을 설정하는 메서드
    /// SnapKit을 사용하여 UI 요소들의 위치와 크기를 정의
    private func setupConstraints() {
        // 결과 레이블의 제약조건
        label.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)    // 상단 여백
            $0.leading.equalToSuperview().offset(20)               // 좌측 여백
            $0.trailing.equalToSuperview().offset(-20)             // 우측 여백
            $0.height.equalTo(200)                                 // 높이 고정
        }
        
        // 버튼 그리드(세로 스택뷰)의 제약조건
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20)           // 레이블과의 간격
            $0.leading.equalToSuperview().offset(20)              // 좌측 여백
            $0.trailing.equalToSuperview().offset(-20)            // 우측 여백
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30) // 하단 여백
        }
    }
    
    /// 모든 버튼의 동작을 설정하는 메서드
    /// 각 버튼에 대한 터치 이벤트 핸들러를 연결
    private func setupButtonActions() {
        // 숫자 버튼들에 대한 액션 설정
        zeroButton2.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        oneButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        twoButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        threeButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        fourButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        fiveButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        sixButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        sevenButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        eightButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        nineButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        dotButton.addTarget(self, action: #selector(dotButtonTapped), for: .touchUpInside)
        
        // 연산자 및 기능 버튼들에 대한 액션 설정
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        plusMinusButton.addTarget(self, action: #selector(plusMinusButtonTapped), for: .touchUpInside)
        percentButton.addTarget(self, action: #selector(percentButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(operatorButtonTapped(_:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(operatorButtonTapped(_:)), for: .touchUpInside)
        multplyButton.addTarget(self, action: #selector(operatorButtonTapped(_:)), for: .touchUpInside)
        dividButton.addTarget(self, action: #selector(operatorButtonTapped(_:)), for: .touchUpInside)
        equalButton.addTarget(self, action: #selector(equalButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Action Methods (버튼 동작 메서드)
    /// 숫자 버튼이 탭되었을 때 호출되는 메서드
    /// - Parameter sender: 탭된 숫자 버튼
    /// 숫자를 입력하거나 기존 숫자에 이어붙임
    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text else { return }
        
        // 새로운 숫자 입력 시작 또는 0 대체
        if firstNumber == "0" || isNewCalculation {
            firstNumber = number
            isNewCalculation = false
        } else {
            // 기존 숫자에 새로운 숫자 이어붙이기
            firstNumber += number
        }
        label.text = firstNumber
    }
    
    /// 연산자 버튼이 탭되었을 때 호출되는 메서드
    /// - Parameter sender: 탭된 연산자 버튼
    /// 수식에 연산자를 추가하거나 에러를 표시
    @objc private func operatorButtonTapped(_ sender: UIButton) {
        guard let op = sender.titleLabel?.text else { return }
        
        // 연산자 중복 입력 방지
        if isLastCharacterOperator() {
            label.text = "error"
        } else {
            firstNumber += op
            label.text = firstNumber
            isNewCalculation = false
        }
    }
    
    /// 등호(=) 버튼이 탭되었을 때 호출되는 메서드
    /// 입력된 수식을 계산하고 결과를 표시
    @objc private func equalButtonTapped() {
        if firstNumber == "0" {
            label.text = "error"
        } else if isLastCharacterOperator() {
            // 연산자로 끝나는 수식은 계산 불가
            label.text = "error"
        } else {
            // 수식 계산 시도
            if let result = calculate(expression: firstNumber) {
                // 결과 포맷팅: 정수는 소수점 제거, 소수는 그대로 표시
                if result.truncatingRemainder(dividingBy: 1) == 0 {
                    firstNumber = String(format: "%.0f", result)
                } else {
                    firstNumber = "\(result)"
                }
                label.text = firstNumber
                isNewCalculation = true
            } else {
                label.text = "error"
            }
        }
    }
    
    /// AC(All Clear) 버튼이 탭되었을 때 호출되는 메서드
    /// 모든 계산 상태를 초기화
    @objc private func resetButtonTapped() {
        firstNumber = "0"
        isNewCalculation = false
        label.text = firstNumber
    }
    
    /// +/- 버튼이 탭되었을 때 호출되는 메서드
    /// 현재 숫자의 부호를 반전
    @objc private func plusMinusButtonTapped() {
        if let number = Double(firstNumber) {
            firstNumber = "\(-number)"
            label.text = firstNumber
        }
    }
    
    /// % 버튼이 탭되었을 때 호출되는 메서드
    /// 현재 숫자를 백분율로 변환 (100으로 나눔)
    @objc private func percentButtonTapped() {
        if let number = Double(firstNumber) {
            firstNumber = "\(number / 100)"
            label.text = firstNumber
        }
    }
    
    /// 소수점(.) 버튼이 탭되었을 때 호출되는 메서드
    /// 현재 숫자에 소수점이 없는 경우에만 추가
    @objc private func dotButtonTapped() {
        if !firstNumber.contains(".") {
            firstNumber += "."
            label.text = firstNumber
        }
    }
    
    // MARK: - Helper Methods (보조 메서드)
    
    /// 현재 수식의 마지막 문자가 연산자인지 확인하는 메서드
    /// - Returns: 마지막 문자가 연산자이면 true, 아니면 false
    private func isLastCharacterOperator() -> Bool {
        let operators = ["+", "−", "×", "÷"]
        guard let lastChar = firstNumber.last.map(String.init) else { return false }
        return operators.contains(lastChar)
    }
    
    /// 주어진 수식을 계산하는 메서드
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

// MARK: - Preview Provider
/// SwiftUI 프리뷰를 위한 설정
#Preview {
    NewCalculator()
}
