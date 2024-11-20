//
//  NewCalculator.swift
//  CodebaseCalculator
//
//  Created by 유태호 on 11/19/24.
//
//  Created by 유태호 on 11/19/24.
//

import UIKit
import SnapKit

class NewCalculator: UIViewController {
    
    // MARK: - Properties
    /// 계산기에 표시되는 현재 숫자 또는 수식을 저장하는 변수
    /// 초기값은 "0"으로 설정
    private var firstNumber = "0"
    
    /// 새로운 계산 시작 여부를 판단하는 플래그
    /// true일 경우 다음 숫자 입력 시 현재 표시된 숫자를 대체함
    private var isNewCalculation = false
    
    // MARK: - UI Components
    /// 계산 결과를 표시하는 메인 레이블
    /// - 흰색 텍스트, 80pt 크기의 light 웨이트 폰트 사용
    /// - 우측 정렬, 자동 폰트 크기 조절 지원
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
    
    // 계산기 버튼 UI 컴포넌트들
    // 첫 번째 줄 버튼들
    private let resetButton = UIButton()      // 모든 입력을 초기화하는 AC 버튼
    private let plusMinusButton = UIButton()  // 양수/음수를 전환하는 +/- 버튼
    private let percentButton = UIButton()    // 퍼센트 값으로 변환하는 % 버튼
    private let dividButton = UIButton()      // 나누기 연산자 버튼
    
    // 두 번째 줄 버튼들
    private let sevenButton = UIButton()      // 숫자 7 버튼
    private let eightButton = UIButton()      // 숫자 8 버튼
    private let nineButton = UIButton()       // 숫자 9 버튼
    private let multplyButton = UIButton()    // 곱하기 연산자 버튼
    
    // 세 번째 줄 버튼들
    private let fourButton = UIButton()       // 숫자 4 버튼
    private let fiveButton = UIButton()       // 숫자 5 버튼
    private let sixButton = UIButton()        // 숫자 6 버튼
    private let minusButton = UIButton()      // 빼기 연산자 버튼
    
    // 네 번째 줄 버튼들
    private let oneButton = UIButton()        // 숫자 1 버튼
    private let twoButton = UIButton()        // 숫자 2 버튼
    private let threeButton = UIButton()      // 숫자 3 버튼
    private let plusButton = UIButton()       // 더하기 연산자 버튼
    
    // 다섯 번째 줄 버튼들
    private let zeroButton = UIButton()       // 숫자 0 버튼 (왼쪽)
    private let zeroButton2 = UIButton()      // 숫자 0 버튼 (오른쪽)
    private let dotButton = UIButton()        // 소수점 버튼
    private let equalButton = UIButton()      // 계산 결과를 표시하는 등호 버튼
    
    // 버튼들을 담을 스택뷰들
    /// 각 행의 버튼들을 담는 가로 스택뷰
    private let stackView = UIStackView()     // 첫 번째 줄 스택뷰
    private let stackView1 = UIStackView()    // 두 번째 줄 스택뷰
    private let stackView2 = UIStackView()    // 세 번째 줄 스택뷰
    private let stackView3 = UIStackView()    // 네 번째 줄 스택뷰
    private let stackView4 = UIStackView()    // 다섯 번째 줄 스택뷰
    
    /// 모든 가로 스택뷰를 담는 세로 스택뷰
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
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorUI()  // UI 초기화 및 설정
    }
    
    // MARK: - UI Setup Methods
    /// 계산기의 전체적인 UI를 설정하는 메서드
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
    private func setupButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(white: 0.23, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        
        // 버튼을 정사각형으로 만들기
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
        ])
    }
    
    
    /// 특수 버튼(연산자, AC 등)의 스타일을 설정하는 메서드
    /// - Parameters:
    ///   - button: 스타일을 적용할 UIButton 인스턴스
    ///   - title: 버튼에 표시될 텍스트
    ///   - color: 버튼의 배경색
    private func colorButton(_ button: UIButton, title: String, color: UIColor) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 34)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        
        // 버튼을 정사각형으로 만들기
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
        ])
    }
    
    /// 모든 버튼의 크기와 모서리를 설정하는 메서드
    /// 화면 크기에 따라 동적으로 버튼 크기를 계산
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
        let calculatorImage = UIImage(systemName: "calculator")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        zeroButton.setImage(calculatorImage, for: .normal)
        zeroButton.backgroundColor = UIColor(white: 0.23, alpha: 1.0)
        
        setupButton(zeroButton2, title: "0")  // 두 번째 0 버튼
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
        
        // 버튼 액션 설정
        setupButtonActions()
    }
    
    /// 스택뷰들의 초기 설정을 수행하는 메서드
    private func setupStackViews() {
        // 스택뷰들의 기본 설정
        [stackView, stackView1, stackView2, stackView3, stackView4].forEach {
            $0.axis = .horizontal
            $0.spacing = 12  // 버튼 사이의 간격
            $0.distribution = .equalSpacing  // 버튼들을 동일한 간격으로 배치
            $0.alignment = .center  // 중앙 정렬
        }
        
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
        
        // 다섯번째 줄 (0, 0, ., =)
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
    
    private func setupConstraints() {
        label.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(200)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    /// 모든 버튼의 동작을 설정하는 메서드
    private func setupButtonActions() {
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
        
        // 연산자 버튼 액션 (변경 없음)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        plusMinusButton.addTarget(self, action: #selector(plusMinusButtonTapped), for: .touchUpInside)
        percentButton.addTarget(self, action: #selector(percentButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(operatorButtonTapped(_:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(operatorButtonTapped(_:)), for: .touchUpInside)
        multplyButton.addTarget(self, action: #selector(operatorButtonTapped(_:)), for: .touchUpInside)
        dividButton.addTarget(self, action: #selector(operatorButtonTapped(_:)), for: .touchUpInside)
        equalButton.addTarget(self, action: #selector(equalButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    /// 숫자 버튼이 탭되었을 때 호출되는 메서드
    /// - Parameter sender: 탭된 숫자 버튼
    @objc private func numberButtonTapped(_ sender: UIButton) {
        // 현재 숫자가 0이거나 새로운 계산을 시작하는 경우, 입력된 숫자로 대체
        guard let number = sender.titleLabel?.text else { return }
        if firstNumber == "0" || isNewCalculation {
            firstNumber = number
            isNewCalculation = false
        // 기존 숫자에 새로운 숫자를 이어붙임
        } else {
            firstNumber += number
        }
        label.text = firstNumber
    }
    
    // 연산자 버튼이 탭되었을 때 호출되는 메서드
    /// - Parameter sender: 탭된 연산자 버튼
    @objc private func operatorButtonTapped(_ sender: UIButton) {
        guard let op = sender.titleLabel?.text else { return }
        // 마지막 문자가 이미 연산자인 경우 에러 표시
        if isLastCharacterOperator() {
            label.text = "error"
        } else {
            // 수식에 연산자 추가
            firstNumber += op
            label.text = firstNumber
            isNewCalculation = false
        }
    }
    
    /// 등호(=) 버튼이 탭되었을 때 호출되는 메서드
    /// 현재까지 입력된 수식을 계산하고 결과를 표시
    @objc private func equalButtonTapped() {
        if firstNumber == "0" {
            label.text = "error"
        } else if isLastCharacterOperator() {
            // 마지막 문자가 연산자인 경우 에러 표시
            label.text = "error"
        } else {
            // 수식 계산 시도
            if let result = calculate(expression: firstNumber) {
                label.text = "\(result)"
                firstNumber = "\(result)"
                isNewCalculation = true
            } else {
                label.text = "error"
            }
        }
    }
    
    /// AC(All Clear) 버튼이 탭되었을 때 호출되는 메서드
    /// 모든 상태를 초기화
    @objc private func resetButtonTapped() {
        firstNumber = "0"
        isNewCalculation = false
        label.text = firstNumber
    }
    
    /// +/- 버튼이 탭되었을 때 호출되는 메서드
    /// 현재 숫자의 부호를 변경
    @objc private func plusMinusButtonTapped() {
        if let number = Double(firstNumber) {
            firstNumber = "\(-number)"
            label.text = firstNumber
        }
    }
    
    /// % 버튼이 탭되었을 때 호출되는 메서드
    /// 현재 숫자를 백분율(100으로 나눈 값)로 변환
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
    
    // MARK: - Helper Methods
    /// 현재 수식의 마지막 문자가 연산자인지 확인하는 메서드
    /// - Returns: 마지막 문자가 연산자이면 true, 아니면 false
    private func isLastCharacterOperator() -> Bool {
        let operators = ["+", "−", "×", "÷"]
        guard let lastChar = firstNumber.last.map(String.init) else { return false }
        return operators.contains(lastChar)
    }
    
    /// 주어진 수식을 계산하는 메서드
    /// - Parameter expression: 계산할 수식 문자열
    /// - Returns: 계산 결과값. 계산할 수 없는 경우 nil 반환
    private func calculate(expression: String) -> Double? {
        // iOS에서 사용하는 연산자 기호를 계산 가능한 형태로 변환
        var expr = expression
        expr = expr.replacingOccurrences(of: "×", with: "*")  // 곱하기 기호 변환
        expr = expr.replacingOccurrences(of: "÷", with: "/")  // 나누기 기호 변환
        expr = expr.replacingOccurrences(of: "−", with: "-")  // 빼기 기호 변환
        
        // NSExpression을 사용하여 수식 계산
        let mathExpression = NSExpression(format: expr)
        return mathExpression.expressionValue(with: nil, context: nil) as? Double
    }
}

// MARK: - Preview Provider
#Preview {
    NewCalculator()
}
