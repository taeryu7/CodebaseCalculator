//
//  ViewController.swift
//  CodebaseCalculator
//
//  Created by 유태호 on 11/14/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var firstNumber = "12345"

    let label = UILabel()

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
        label.font = .boldSystemFont(ofSize: 60)
        label.textAlignment = .right

        // 뷰 추가 필수로 해야함.
        view.addSubview(label)
        
        // 제약 조건 설정
        label.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalToSuperview().offset(200)
        }
        
    }

}
#Preview {
  ViewController()
}

