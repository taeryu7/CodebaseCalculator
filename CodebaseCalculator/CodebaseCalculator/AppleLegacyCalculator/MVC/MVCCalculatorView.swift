//
//  CalculatorView.swift
//  CodebaseCalculator
//
//  Created by 유태호 on 11/18/24.
//

import UIKit
import SnapKit

/// 계산기의 시각적 요소를 담당하는 커스텀 뷰
class MVCCalculatorView: UIView {
    // MARK: - UI Components
    
    /// 계산 결과를 표시하는 레이블
    let resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 60)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    // 스택뷰들
    private let stackView = UIStackView()   // 7,8,9,+
    private let stackView1 = UIStackView()  // 4,5,6,-
    private let stackView2 = UIStackView()  // 1,2,3,*
    private let stackView3 = UIStackView()  // AC,0,=,/
    
    // 버튼들
    let numberButtons: [UIButton] = (0...9).map { _ in UIButton() }
    let operatorButtons: [UIButton] = (0...5).map { _ in UIButton() } // +,-,*,/,=,AC
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .black
        setupButtons()
        setupStackViews()
        setupConstraints()
    }
    
    private func setupButtons() {
        // 숫자 버튼 설정
        for (index, button) in numberButtons.enumerated() {
            setupNumberButton(button, title: "\(index)")
        }
        
        // 연산자 버튼 설정
        let operators = ["+", "-", "*", "/", "=", "AC"]
        for (index, button) in operatorButtons.enumerated() {
            setupOperatorButton(button, title: operators[index])
        }
    }
    
    private func setupNumberButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40
    }
    
    private func setupOperatorButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.backgroundColor = UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40
    }
    
    private func setupStackViews() {
        [stackView, stackView1, stackView2, stackView3].forEach {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
        // 첫 번째 줄: 7,8,9,+
        stackView.addArrangedSubview(numberButtons[7])
        stackView.addArrangedSubview(numberButtons[8])
        stackView.addArrangedSubview(numberButtons[9])
        stackView.addArrangedSubview(operatorButtons[0])
        
        // 두 번째 줄: 4,5,6,-
        stackView1.addArrangedSubview(numberButtons[4])
        stackView1.addArrangedSubview(numberButtons[5])
        stackView1.addArrangedSubview(numberButtons[6])
        stackView1.addArrangedSubview(operatorButtons[1])
        
        // 세 번째 줄: 1,2,3,*
        stackView2.addArrangedSubview(numberButtons[1])
        stackView2.addArrangedSubview(numberButtons[2])
        stackView2.addArrangedSubview(numberButtons[3])
        stackView2.addArrangedSubview(operatorButtons[2])
        
        // 네 번째 줄: AC,0,=,/
        stackView3.addArrangedSubview(operatorButtons[5])
        stackView3.addArrangedSubview(numberButtons[0])
        stackView3.addArrangedSubview(operatorButtons[4])
        stackView3.addArrangedSubview(operatorButtons[3])
    }
    
    private func setupConstraints() {
        addSubview(resultLabel)
        addSubview(stackView)
        addSubview(stackView1)
        addSubview(stackView2)
        addSubview(stackView3)
        
        resultLabel.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalToSuperview().offset(200)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(resultLabel.snp.bottom).offset(60)
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
}
