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
    // 두번째 줄
    let fourButton = UIButton()
    let fiveButton = UIButton()
    let sixButton = UIButton()
    let minusButton = UIButton()
    let stackView1 = UIStackView()
    // 세번째 줄
    let oneButton = UIButton()
    let twoButton = UIButton()
    let threeButton = UIButton()
    let multplyButton = UIButton()
    let stackView2 = UIStackView()
    
    // 네번째 줄
    let resetButton = UIButton()
    let zeroButton = UIButton()
    let equalButton = UIButton()
    let dividButton = UIButton()
    let stackView3 = UIStackView()

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
        
        // 두번째 버튼 설정
        setupButton(button: fourButton, title: "4")
        setupButton(button: fiveButton, title: "5")
        setupButton(button: sixButton, title: "6")
        setupButton(button: minusButton, title: "-")
        
        //세번째 버튼 설정
        setupButton(button: oneButton, title: "1")
        setupButton(button: twoButton, title: "2")
        setupButton(button: threeButton, title: "3")
        setupButton(button: multplyButton, title: "*")
        
        //네번째 버튼 설정
        setupButton(button: resetButton, title: "AC")
        setupButton(button: zeroButton, title: "0")
        setupButton(button: equalButton, title: "=")
        setupButton(button: dividButton, title: "/")

        // 1.스택뷰 설정
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(sevenButton)
        stackView.addArrangedSubview(eightButton)
        stackView.addArrangedSubview(nineButton)
        stackView.addArrangedSubview(plusButton)
        
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
        
        // 뷰 추가 필수로 해야함.
        view.addSubview(label)
        view.addSubview(stackView)
        view.addSubview(stackView1)
        view.addSubview(stackView2)
        view.addSubview(stackView3)
        
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
