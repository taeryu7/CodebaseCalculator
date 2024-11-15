//
//  ViewController.swift
//  CodebaseCalculator
//
//  Created by 유태호 on 11/14/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    /// 계산기에 표시되는 현재 숫자 또는 수식을 저장하는 변수
    /// 초기값은 "0"이며, 사용자 입력에 따라 숫자와 연산자가 추가됨
    /// 예: "123+456", "789*2" 등의 형태로 저장
    private var firstNumber = "0"
    
    /// 새로운 계산 시작 여부를 판단하는 플래그
    /// - true: 계산 결과가 표시된 직후 상태. 새로운 숫자 입력 시 현재 표시된 결과를 지우고 새로 시작
    /// - false: 계산 진행 중인 상태. 입력된 숫자나 연산자를 기존 수식에 추가
    private var isNewCalculation = false

    // MARK: - UI Components
    /// 계산 결과를 표시하는 레이블
    /// - 텍스트 정렬: 우측
    /// - 글자 크기: 자동 조절 (60pt에서 시작, 최소 30pt까지 자동 축소)
    /// - 표시 내용: 현재 입력 중인 수식 또는 계산 결과
    let label = UILabel()
    
    // 첫번째 줄 버튼들 (7,8,9,+)
    let plusButton = UIButton()    // 더하기 연산자 버튼 (주황색)
    let sevenButton = UIButton()   // 숫자 7 버튼 (회색)
    let eightButton = UIButton()   // 숫자 8 버튼 (회색)
    let nineButton = UIButton()    // 숫자 9 버튼 (회색)
    let stackView = UIStackView()  // 7,8,9,+ 버튼을 가로로 배치하는 스택뷰
    
    // 두번째 줄 버튼들
    let fourButton = UIButton()    // 숫자 4
    let fiveButton = UIButton()    // 숫자 5
    let sixButton = UIButton()     // 숫자 6
    let minusButton = UIButton()   // 빼기 연산자
    let stackView1 = UIStackView() // 4,5,6,- 버튼을 가로로 배치하는 스택뷰
    
    // 세번째 줄 버튼들
    let oneButton = UIButton()     // 숫자 1
    let twoButton = UIButton()     // 숫자 2
    let threeButton = UIButton()   // 숫자 3
    let multplyButton = UIButton() // 곱하기 연산자
    let stackView2 = UIStackView() // 1,2,3,* 버튼을 가로로 배치하는 스택뷰
    
    // 네번째 줄 버튼들
    let resetButton = UIButton()   // 초기화(AC) 버튼
    let zeroButton = UIButton()    // 숫자 0
    let equalButton = UIButton()   // 등호(계산) 버튼
    let dividButton = UIButton()   // 나누기 연산자
    let stackView3 = UIStackView() // AC,0,=,- 버튼을 가로로 배치하는 스택뷰
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorUI()
    }
    
    // MARK: - UI Setup Methods
    /// 계산기의 전체적인 UI를 설정하는 메서드
    private func calculatorUI() {
        // 배경색 설정
        view.backgroundColor = .black
        
        // 레이블 설정
        label.text = "\(firstNumber)"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 60)
        label.textAlignment = .right
        label.numberOfLines = 1               // 한 줄로 표시
        label.adjustsFontSizeToFitWidth = true // 글자 크기 자동 조절
        label.minimumScaleFactor = 0.5        // 최소 글자 크기는 원본의 50%까지
        
        // 버튼 설정
        colorButton(button: plusButton, title: "+")
        setupButton(button: sevenButton, title: "7")
        setupButton(button: eightButton, title: "8")
        setupButton(button: nineButton, title: "9")
        
        // 두번째 버튼 설정
        setupButton(button: fourButton, title: "4")
        setupButton(button: fiveButton, title: "5")
        setupButton(button: sixButton, title: "6")
        colorButton(button: minusButton, title: "-")
        
        //세번째 버튼 설정
        setupButton(button: oneButton, title: "1")
        setupButton(button: twoButton, title: "2")
        setupButton(button: threeButton, title: "3")
        colorButton(button: multplyButton, title: "*")
        
        //네번째 버튼 설정
        colorButton(button: resetButton, title: "AC")
        setupButton(button: zeroButton, title: "0")
        colorButton(button: equalButton, title: "=")
        colorButton(button: dividButton, title: "/")
        
        // 1.스택뷰 설정
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(sevenButton)
        stackView.addArrangedSubview(eightButton)
        stackView.addArrangedSubview(nineButton)
        stackView.addArrangedSubview(plusButton)
        
        // 2.스택뷰 설정
        stackView1.axis = .horizontal
        stackView1.spacing = 10
        stackView1.distribution = .fillEqually
        stackView1.addArrangedSubview(fourButton)
        stackView1.addArrangedSubview(fiveButton)
        stackView1.addArrangedSubview(sixButton)
        stackView1.addArrangedSubview(minusButton)
        
        // 3.스택뷰 설정
        stackView2.axis = .horizontal
        stackView2.spacing = 10
        stackView2.distribution = .fillEqually
        stackView2.addArrangedSubview(oneButton)
        stackView2.addArrangedSubview(twoButton)
        stackView2.addArrangedSubview(threeButton)
        stackView2.addArrangedSubview(multplyButton)
        
        //4. 스택뷰 설정
        stackView3.axis = .horizontal
        stackView3.spacing = 10
        stackView3.distribution = .fillEqually
        stackView3.addArrangedSubview(resetButton)
        stackView3.addArrangedSubview(zeroButton)
        stackView3.addArrangedSubview(equalButton)
        stackView3.addArrangedSubview(dividButton)
        
        // 숫자버튼 액션 설정
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchDown)
        oneButton.addTarget(self, action: #selector(oneButtonTapped), for: .touchDown)
        twoButton.addTarget(self, action: #selector(twoButtonTapped), for: .touchDown)
        threeButton.addTarget(self, action: #selector(threeButtonTapped), for: .touchDown)
        fourButton.addTarget(self, action: #selector(fourButtonTapped), for: .touchDown)
        fiveButton.addTarget(self, action: #selector(fiveButtonTapped), for: .touchDown)
        sixButton.addTarget(self, action: #selector(sixButtonTapped), for: .touchDown)
        sevenButton.addTarget(self, action: #selector(sevenButtonTapped), for: .touchDown)
        eightButton.addTarget(self, action: #selector(eightButtonTapped), for: .touchDown)
        nineButton.addTarget(self, action: #selector(nineButtonTapped), for: .touchDown)
        zeroButton.addTarget(self, action: #selector(zeroButtonTapped), for: .touchDown)
        
        // 연산자 액션 설정
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchDown)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchDown)
        multplyButton.addTarget(self, action: #selector(multplyButtonTapped), for: .touchDown)
        dividButton.addTarget(self, action: #selector(dividButtonTapped), for: .touchDown)
        equalButton.addTarget(self, action: #selector(equalButtonTapped), for: .touchDown)
        
        // 뷰 추가
        view.addSubview(label)
        view.addSubview(stackView)
        view.addSubview(stackView1)
        view.addSubview(stackView2)
        view.addSubview(stackView3)
        
        // 제약조건 설정
        label.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalToSuperview().offset(200)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(60)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(80)
        }
        
        stackView1.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(80)
        }
        
        stackView2.snp.makeConstraints {
            $0.top.equalTo(stackView1.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(80)
        }
        
        stackView3.snp.makeConstraints {
            $0.top.equalTo(stackView2.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(80)
        }
    }
    
    /// 숫자 버튼의 공통 UI를 설정하는 메서드
    private func setupButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30) //   - 폰트 크기: 30pt
        button.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0) //   - 배경색: RGB(58,58,58) - 회색
        button.setTitleColor(.white, for: .normal) //   - 글자색: 흰색
        button.layer.cornerRadius = 40 //   - 모서리: 40pt 라운드 처리
    }
    
    /// 연산자 버튼의 공통 UI를 설정하는 메서드
    private func colorButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30) //   - 폰트 크기: 30pt
        button.backgroundColor = UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1.0) //   - 배경색: RGB(255,147,0) - 주황색
        button.setTitleColor(.white, for: .normal) //   - 글자색: 흰색
        button.layer.cornerRadius = 40 //   - 모서리: 40pt 라운드 처리
    }
    
    // MARK: - Helper Methods
    /// 숫자 버튼 입력을 처리하는 공통 메서드
    /// - Parameter number: 입력된 숫자 문자열
    /// - Note:
    /// 1. 초기 상태(firstNumber가 "0")이거나
    /// 2. 새로운 계산 시작(isNewCalculation이 true)인 경우
    ///    -> 입력된 숫자로 완전히 대체
    /// 3. 그 외의 경우 -> 기존 숫자에 이어서 추가
    private func handleNumberInput(_ number: String) {
        if firstNumber == "0" || isNewCalculation {
            firstNumber = number            // 새로운 숫자로 완전히 대체
            isNewCalculation = false        // 계산 진행 중 상태로 변경
        } else {
            firstNumber += number           // 기존 숫자에 이어붙이기
        }
        label.text = "\(firstNumber)"      // 화면 업데이트
    }
    
    // MARK: - Button Actions
    // 초기화 버튼
    @objc
    private func resetButtonTapped() {
        firstNumber = "0"              // 숫자 초기화
        isNewCalculation = false       // 계산 상태 초기화
        label.text = "\(firstNumber)"  // 화면 업데이트
    }
   
    /// 숫자 버튼 액션 메서드들
    @objc
    private func oneButtonTapped() {
        handleNumberInput("1")
    }
    
    @objc
    private func twoButtonTapped() {
        handleNumberInput("2")
    }
    
    @objc
    private func threeButtonTapped() {
        handleNumberInput("3")
    }
    
    @objc
    private func fourButtonTapped() {
        handleNumberInput("4")
    }
    
    @objc
    private func fiveButtonTapped() {
        handleNumberInput("5")
    }
    
    @objc
    private func sixButtonTapped() {
        handleNumberInput("6")
    }
    
    @objc
    private func sevenButtonTapped() {
        handleNumberInput("7")
    }
    
    @objc
    private func eightButtonTapped() {
        handleNumberInput("8")
    }
    
    @objc
    private func nineButtonTapped() {
        handleNumberInput("9")
    }
    
    @objc
    private func zeroButtonTapped() {
        handleNumberInput("0")
    }
    
    // MARK: - Helper Methods
    /// 입력된 수식의 마지막 문자가 연산자인지 확인하는 메서드
    /// - Returns: 마지막 문자가 연산자이면 true, 아니면 false
    /// - 체크하는 연산자: +, -, *, /
    /// - 사용 용도:
    ///   1. 연속된 연산자 입력 방지
    ///   2. 수식 마지막이 연산자인 상태에서 계산 방지
    private func isLastCharacterOperator() -> Bool {
        let operators = ["+", "-", "*", "/"]  // 유효한 연산자 목록
        // firstNumber의 마지막 문자를 String으로 변환
        // 문자열이 비어있으면 false 반환
        guard let lastChar = firstNumber.last.map(String.init) else { return false }
        // 마지막 문자가 연산자 배열에 포함되어 있는지 확인
        return operators.contains(lastChar)
    }

    // MARK: - Operator Button Actions
    /// 더하기(+) 버튼 동작을 처리하는 메서드
    /// - Note:
    /// 1. 첫 입력이 연산자인 경우 에러
    /// 2. 연속된 연산자 입력 시 에러
    /// 3. 정상적인 경우 수식에 + 추가
    @objc
    private func plusButtonTapped() {
        if firstNumber == "0" {  // 첫 입력이 연산자인 경우
            firstNumber = "+"
            label.text = "error"
        } else if isLastCharacterOperator() {  // 이전 입력이 연산자인 경우
            label.text = "error"  // 에러 메시지 표시
        } else {  // 정상적인 입력인 경우
            firstNumber += "+"    // 수식에 더하기 연산자 추가
            label.text = "\(firstNumber)"  // 화면 업데이트
            isNewCalculation = false       // 계산 진행 중 상태로 설정
        }
    }
    
    /// 빼기(-) 버튼 동작을 처리하는 메서드
    /// - Note:
    /// 1. 첫 입력이 - 인 경우 음수 표현을 위해 허용
    /// 2. 연속된 연산자 입력 시 에러
    /// 3. 정상적인 경우 수식에 - 추가
    @objc
    private func minusButtonTapped() {
        if firstNumber == "0" {  // 첫 입력이 마이너스인 경우 (음수 표현)
            firstNumber = "-"
            label.text = "\(firstNumber)"
        } else if isLastCharacterOperator() {  // 이전 입력이 연산자인 경우
            label.text = "error"  // 에러 메시지 표시
        } else {  // 정상적인 입력인 경우
            firstNumber += "-"    // 수식에 빼기 연산자 추가
            label.text = "\(firstNumber)"  // 화면 업데이트
            isNewCalculation = false       // 계산 진행 중 상태로 설정
        }
    }
    
    /// 곱하기(*) 버튼 동작을 처리하는 메서드
    /// - Note:
    /// 1. 첫 입력이 연산자인 경우 에러
    /// 2. 연속된 연산자 입력 시 에러
    /// 3. 정상적인 경우 수식에 * 추가
    @objc
    private func multplyButtonTapped() {
        if firstNumber == "0" {  // 첫 입력이 연산자인 경우
            firstNumber = "*"
            label.text = "error"
        } else if isLastCharacterOperator() {  // 이전 입력이 연산자인 경우
            label.text = "error"  // 에러 메시지 표시
        } else {  // 정상적인 입력인 경우
            firstNumber += "*"    // 수식에 곱하기 연산자 추가
            label.text = "\(firstNumber)"  // 화면 업데이트
            isNewCalculation = false       // 계산 진행 중 상태로 설정
        }
    }
    
    /// 나누기(/) 버튼 동작을 처리하는 메서드
    /// - Note:
    /// 1. 첫 입력이 연산자인 경우 에러
    /// 2. 연속된 연산자 입력 시 에러
    /// 3. 정상적인 경우 수식에 / 추가
    @objc
    private func dividButtonTapped() {
        if firstNumber == "0" {  // 첫 입력이 연산자인 경우
            firstNumber = "/"
            label.text = "error"
        } else if isLastCharacterOperator() {  // 이전 입력이 연산자인 경우
            label.text = "error"  // 에러 메시지 표시
        } else {  // 정상적인 입력인 경우
            firstNumber += "/"    // 수식에 나누기 연산자 추가
            label.text = "\(firstNumber)"  // 화면 업데이트
            isNewCalculation = false       // 계산 진행 중 상태로 설정
        }
    }
    
    /// 등호(=) 버튼 동작을 처리하는 메서드
    /// - Note:
    /// 1. 수식이 비어있는 경우(0) 에러
    /// 2. 마지막 입력이 연산자인 경우 에러
    /// 3. 정상적인 경우 계산 수행
    /// 4. 계산 결과를 화면에 표시하고 새로운 계산 준비
    @objc
    private func equalButtonTapped() {
        if firstNumber == "0" {
            label.text = "error"
        } else if isLastCharacterOperator() {
            label.text = "error"
        } else {
            if let result = calculate(expression: firstNumber) {
                label.text = "\(result)"
                firstNumber = "\(result)"
                isNewCalculation = true  // 계산 완료 후 새로운 계산 시작을 위해 플래그를 true로 설정
            } else {
                label.text = "error"
            }
        }
    }
    
    /// 수식을 계산하는 메서드
    /// - Parameter expression: 계산할 수식 문자열 (예: "123+456")
    /// - Returns: 계산 결과값 (Int?). 계산 실패 시 0 반환
    /// - 사용: NSExpression을 통해 문자열 수식을 계산
    /// - 주의:
    ///   1. 정수 계산만 지원
    ///   2. 잘못된 수식은 0 반환
    private func calculate(expression: String) -> Int? {
        let expression = NSExpression(format: expression)
        if let result = expression.expressionValue(with: nil, context: nil) as? Int {
            return result
        } else {
            return 0
        }
    }
}

// MARK: - Preview Provider
#Preview {
    ViewController()
}
