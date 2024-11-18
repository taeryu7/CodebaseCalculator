//
//  CalculatorViewController.swift
//  CodebaseCalculator
//
//  Created by 유태호 on 11/18/24.
//

import UIKit
import SnapKit

/// 계산기의 UI를 담당하는 뷰컨트롤러
class CalculatorViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 계산기의 비즈니스 로직을 처리하는 뷰모델
    private let viewModel = CalculatorViewModel()
    
    // MARK: - UI Components
    
    /// 계산기 결과를 표시하는 레이블
    /// - 텍스트 정렬: 우측
    /// - 폰트 크기: 60pt (자동 축소 가능)
    /// - 글자 색상: 흰색
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 60)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true  // 글자 크기 자동 조절
        label.minimumScaleFactor = 0.5         // 최소 글자 크기는 원본의 50%까지
        return label
    }()
    
    // 첫번째 줄 버튼들 (7,8,9,+)
    private let plusButton = UIButton()     // 더하기 연산자 버튼 (주황색)
    private let sevenButton = UIButton()    // 숫자 7 버튼 (회색)
    private let eightButton = UIButton()    // 숫자 8 버튼 (회색)
    private let nineButton = UIButton()     // 숫자 9 버튼 (회색)
    private let stackView = UIStackView()   // 7,8,9,+ 버튼을 가로로 배치하는 스택뷰
    
    // 두번째 줄 버튼들 (4,5,6,-)
    private let fourButton = UIButton()     // 숫자 4 버튼 (회색)
    private let fiveButton = UIButton()     // 숫자 5 버튼 (회색)
    private let sixButton = UIButton()      // 숫자 6 버튼 (회색)
    private let minusButton = UIButton()    // 빼기 연산자 버튼 (주황색)
    private let stackView1 = UIStackView()  // 4,5,6,- 버튼을 가로로 배치하는 스택뷰
    
    // 세번째 줄 버튼들 (1,2,3,*)
    private let oneButton = UIButton()      // 숫자 1 버튼 (회색)
    private let twoButton = UIButton()      // 숫자 2 버튼 (회색)
    private let threeButton = UIButton()    // 숫자 3 버튼 (회색)
    private let multplyButton = UIButton()  // 곱하기 연산자 버튼 (주황색)
    private let stackView2 = UIStackView()  // 1,2,3,* 버튼을 가로로 배치하는 스택뷰
    
    // 네번째 줄 버튼들 (AC,0,=,/)
    private let resetButton = UIButton()    // 초기화(AC) 버튼 (주황색)
    private let zeroButton = UIButton()     // 숫자 0 버튼 (회색)
    private let equalButton = UIButton()    // 등호 버튼 (주황색)
    private let dividButton = UIButton()    // 나누기 연산자 버튼 (주황색)
    private let stackView3 = UIStackView()  // AC,0,=,/ 버튼을 가로로 배치하는 스택뷰
    
    // MARK: - Lifecycle Methods
    
    /// 뷰 컨트롤러의 뷰가 로드된 후 호출되는 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Setup Methods
    
    /// UI 초기 설정을 담당하는 메서드
    private func setupUI() {
        setupBasicUI()
        setupButtons()
        setupStackViews()
        setupConstraints()
    }
    
    /// 기본 UI 설정을 담당하는 메서드
    /// - Note: 배경색 설정 및 서브뷰 추가
    private func setupBasicUI() {
        view.backgroundColor = .black
        view.addSubview(label)
        view.addSubview(stackView)
        view.addSubview(stackView1)
        view.addSubview(stackView2)
        view.addSubview(stackView3)
    }
    
    /// ViewModel과의 바인딩을 설정하는 메서드
    /// - Note: ViewModel의 상태 변경을 감지하여 UI 업데이트
    private func bindViewModel() {
        viewModel.displayTextChanged = { [weak self] text in
            self?.label.text = text
        }
    }
    
    /// 모든 버튼의 설정을 담당하는 메서드
    private func setupButtons() {
        // 숫자 버튼 설정 (0-9)
        setupNumberButton(zeroButton, title: "0")
        setupNumberButton(oneButton, title: "1")
        setupNumberButton(twoButton, title: "2")
        setupNumberButton(threeButton, title: "3")
        setupNumberButton(fourButton, title: "4")
        setupNumberButton(fiveButton, title: "5")
        setupNumberButton(sixButton, title: "6")
        setupNumberButton(sevenButton, title: "7")
        setupNumberButton(eightButton, title: "8")
        setupNumberButton(nineButton, title: "9")
        
        // 연산자 버튼 설정 (+,-,*,/,=,AC)
        setupOperatorButton(plusButton, title: "+")
        setupOperatorButton(minusButton, title: "-")
        setupOperatorButton(multplyButton, title: "*")
        setupOperatorButton(dividButton, title: "/")
        setupOperatorButton(equalButton, title: "=")
        setupOperatorButton(resetButton, title: "AC")
    }
    
    /// 숫자 버튼의 공통 UI를 설정하는 메서드
    /// - Parameters:
    ///   - button: 설정할 버튼
    ///   - title: 버튼에 표시될 텍스트
    private func setupNumberButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)  // 회색
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40
        button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchDown)
    }
    
    /// 연산자 버튼의 공통 UI를 설정하는 메서드
    /// - Parameters:
    ///   - button: 설정할 버튼
    ///   - title: 버튼에 표시될 텍스트
    private func setupOperatorButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.backgroundColor = UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1.0)  // 주황색
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40
        button.addTarget(self, action: #selector(operatorButtonTapped(_:)), for: .touchDown)
    }
    
    /// 스택뷰들의 설정을 담당하는 메서드
    private func setupStackViews() {
        // 공통 스택뷰 설정
        [stackView, stackView1, stackView2, stackView3].forEach {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
        // 각 스택뷰에 버튼 추가
        stackView.addArrangedSubview(sevenButton)
        stackView.addArrangedSubview(eightButton)
        stackView.addArrangedSubview(nineButton)
        stackView.addArrangedSubview(plusButton)
        
        stackView1.addArrangedSubview(fourButton)
        stackView1.addArrangedSubview(fiveButton)
        stackView1.addArrangedSubview(sixButton)
        stackView1.addArrangedSubview(minusButton)
        
        stackView2.addArrangedSubview(oneButton)
        stackView2.addArrangedSubview(twoButton)
        stackView2.addArrangedSubview(threeButton)
        stackView2.addArrangedSubview(multplyButton)
        
        stackView3.addArrangedSubview(resetButton)
        stackView3.addArrangedSubview(zeroButton)
        stackView3.addArrangedSubview(equalButton)
        stackView3.addArrangedSubview(dividButton)
    }
    
    /// Auto Layout 제약조건을 설정하는 메서드
    private func setupConstraints() {
        // 결과 레이블 제약조건
        label.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalToSuperview().offset(200)
        }
        
        // 첫번째 줄 스택뷰 제약조건
        stackView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(60)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(80)
        }
        
        // 두번째 줄 스택뷰 제약조건
        stackView1.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(80)
        }
        
        // 세번째 줄 스택뷰 제약조건
        stackView2.snp.makeConstraints {
            $0.top.equalTo(stackView1.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(80)
        }
        
        // 네번째 줄 스택뷰 제약조건
        stackView3.snp.makeConstraints {
            $0.top.equalTo(stackView2.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(80)
        }
    }
    
    // MARK: - Button Actions
    
    /// 숫자 버튼이 탭되었을 때 호출되는 메서드
    /// - Parameter sender: 탭된 숫자 버튼
    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text else { return }
        viewModel.inputNumber(number)
    }
    
    /// 연산자 버튼이 탭되었을 때 호출되는 메서드
    /// - Parameter sender: 탭된 연산자 버튼
    /// - Note: =, AC, 또는 사칙연산자에 따라 다른 동작 수행
    @objc private func operatorButtonTapped(_ sender: UIButton) {
        guard let op = sender.titleLabel?.text else { return }
        if op == "=" {
            viewModel.calculateResult()
        } else if op == "AC" {
            viewModel.resetCalculator()
        } else {
            viewModel.inputOperator(op)
        }
    }
}

// MARK: - Preview Provider
#Preview {
    CalculatorViewController()
}
