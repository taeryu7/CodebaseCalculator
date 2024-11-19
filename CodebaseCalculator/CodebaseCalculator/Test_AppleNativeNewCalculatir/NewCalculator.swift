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
    private var firstNumber = "0"
    
    /// 새로운 계산 시작 여부를 판단하는 플래그
    private var isNewCalculation = false
    
    // MARK: - UI Components
    /// 계산 결과를 표시하는 레이블
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 80, weight: .light)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    // 각 줄의 버튼들
    private let resetButton = UIButton()      // AC 버튼
    private let plusMinusButton = UIButton()  // +/- 버튼
    private let percentButton = UIButton()    // % 버튼
    private let dividButton = UIButton()      // ÷ 버튼
    
    private let sevenButton = UIButton()      // 7 버튼
    private let eightButton = UIButton()      // 8 버튼
    private let nineButton = UIButton()       // 9 버튼
    private let multplyButton = UIButton()    // × 버튼
    
    private let fourButton = UIButton()       // 4 버튼
    private let fiveButton = UIButton()       // 5 버튼
    private let sixButton = UIButton()        // 6 버튼
    private let minusButton = UIButton()      // − 버튼
    
    private let oneButton = UIButton()        // 1 버튼
    private let twoButton = UIButton()        // 2 버튼
    private let threeButton = UIButton()      // 3 버튼
    private let plusButton = UIButton()       // + 버튼
    
    private let zeroButton = UIButton()       // 첫 번째 0 버튼
    private let zeroButton2 = UIButton()      // 두 번째 0 버튼
    private let dotButton = UIButton()        // . 버튼
    private let equalButton = UIButton()      // = 버튼
    
    // 스택뷰
    private let stackView = UIStackView()     // AC, +/-, %, ÷
    private let stackView1 = UIStackView()    // 7, 8, 9, ×
    private let stackView2 = UIStackView()    // 4, 5, 6, −
    private let stackView3 = UIStackView()    // 1, 2, 3, +
    private let stackView4 = UIStackView()    // 0, 0, ., =
    
    // 수직 스택뷰
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
        calculatorUI()
    }
    
    // MARK: - UI Setup Methods
    private func calculatorUI() {
        view.backgroundColor = .black
        setupButtons()
        setupStackViews()
        setupConstraints()
        layoutButtons()
    }
    
    private func setupButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(white: 0.23, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 30) //   - 폰트 크기: 30pt
        button.layer.cornerRadius = 40 //   - 모서리: 40pt 라운드 처리
    }
    
    private func colorButton(_ button: UIButton, title: String, color: UIColor) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 34)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
    }
    
    private func layoutButtons() {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 20
        let spacing: CGFloat = 12
        let availableWidth = screenWidth - (padding * 2) - (spacing * 3)
        let buttonDiameter = availableWidth / 4  // 버튼의 지름
        
        [resetButton, plusMinusButton, percentButton, dividButton,
         sevenButton, eightButton, nineButton, multplyButton,
         fourButton, fiveButton, sixButton, minusButton,
         oneButton, twoButton, threeButton, plusButton,
         zeroButton, zeroButton2, dotButton, equalButton].forEach { button in
            // 가로 세로가 같은 정사각형으로 만들고 지름의 절반으로 cornerRadius 설정
            button.widthAnchor.constraint(equalToConstant: buttonDiameter).isActive = true
            button.heightAnchor.constraint(equalToConstant: buttonDiameter).isActive = true
            button.layer.cornerRadius = buttonDiameter / 2
            button.clipsToBounds = true
        }
    }
    
    private func setupButtons() {
        // 숫자 버튼 설정
        setupButton(zeroButton, title: "0")
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
        
        // 버튼 액션 설정
        setupButtonActions()
    }
    
    private func setupStackViews() {
        // 각 가로 스택뷰 설정
        [stackView, stackView1, stackView2, stackView3, stackView4].forEach {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
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
        
        // 수직 스택뷰에 추가
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(120)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func setupButtonActions() {
        // 숫자 버튼 액션
        oneButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        twoButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        threeButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        fourButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        fiveButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        sixButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        sevenButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        eightButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        nineButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        zeroButton.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        zeroButton2.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        dotButton.addTarget(self, action: #selector(dotButtonTapped), for: .touchUpInside)
        
        // 연산자 버튼 액션
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
    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text else { return }
        if firstNumber == "0" || isNewCalculation {
            firstNumber = number
            isNewCalculation = false
        } else {
            firstNumber += number
        }
        label.text = firstNumber
    }
    
    @objc private func operatorButtonTapped(_ sender: UIButton) {
        guard let op = sender.titleLabel?.text else { return }
        if isLastCharacterOperator() {
            label.text = "error"
        } else {
            firstNumber += op
            label.text = firstNumber
            isNewCalculation = false
        }
    }
    
    @objc private func equalButtonTapped() {
        if firstNumber == "0" {
            label.text = "error"
        } else if isLastCharacterOperator() {
            label.text = "error"
        } else {
            if let result = calculate(expression: firstNumber) {
                label.text = "\(result)"
                firstNumber = "\(result)"
                isNewCalculation = true
            } else {
                label.text = "error"
            }
        }
    }
    
    @objc private func resetButtonTapped() {
        firstNumber = "0"
        isNewCalculation = false
        label.text = firstNumber
    }
    
    @objc private func plusMinusButtonTapped() {
        if let number = Double(firstNumber) {
            firstNumber = "\(-number)"
            label.text = firstNumber
        }
    }
    
    @objc private func percentButtonTapped() {
        if let number = Double(firstNumber) {
            firstNumber = "\(number / 100)"
            label.text = firstNumber
        }
    }
    
    @objc private func dotButtonTapped() {
        if !firstNumber.contains(".") {
            firstNumber += "."
            label.text = firstNumber
        }
    }
    
    // MARK: - Helper Methods
    private func isLastCharacterOperator() -> Bool {
        let operators = ["+", "−", "×", "÷"]
        guard let lastChar = firstNumber.last.map(String.init) else { return false }
        return operators.contains(lastChar)
    }
    
    private func calculate(expression: String) -> Double? {
        // 연산자 변환 (iOS 스타일 → 계산 가능한 형태)
        var expr = expression
        expr = expr.replacingOccurrences(of: "×", with: "*")
        expr = expr.replacingOccurrences(of: "÷", with: "/")
        expr = expr.replacingOccurrences(of: "−", with: "-")
        
        let mathExpression = NSExpression(format: expr)
        return mathExpression.expressionValue(with: nil, context: nil) as? Double
    }
}

// MARK: - Preview Provider
#Preview {
    NewCalculator()
}
