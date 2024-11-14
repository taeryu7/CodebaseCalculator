//
//  ViewController.swift
//  CodebaseCalculator
//
//  Created by 유태호 on 11/14/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    //임의로 지정한 숫자값
    private var firstNumber = "12345"
    
    // 상단 숫자 라벨
    let label = UILabel()
    
    // 첫번째 줄
    let plusButton = UIButton()
    let sevenButton = UIButton()
    let eightButton = UIButton()
    let nineButton = UIButton()
    let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorUI()
        // Do any additional setup after loading the view.
    }
    
    private func calculatorUI() {
        view.backgroundColor = .black
        
        // 레이블 설정
        label.text = "\(firstNumber)"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 60)    // 폰트 : 볼드, 60pt
        label.textAlignment = .right
        
        // 버튼 설정
        setupButton(button: plusButton, title: "+")
        setupButton(button: sevenButton, title: "7")
        setupButton(button: eightButton, title: "8")
        setupButton(button: nineButton, title: "9")

        // 1.스택뷰 설정
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(sevenButton)
        stackView.addArrangedSubview(eightButton)
        stackView.addArrangedSubview(nineButton)
        stackView.addArrangedSubview(plusButton)
        
        // 뷰 추가 필수로 해야함.
        view.addSubview(label)
        view.addSubview(stackView)
        
        // 제약 조건 설정
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
        
        
        
    }
    //숫자 버튼 설정
    private func setupButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
    }

}
#Preview {
  ViewController()
}

