//
//  UIColorExtension.swift
//  CodebaseCalculator
//
//  Created by 유태호 on 11/20/24.
//

import UIKit

extension UIColor {
    /// 색상의 밝기를 조절하는 메서드
    /// - Parameter amount: 밝기 조절 값 (0보다 크면 밝아지고, 작으면 어두워짐)
    /// - Returns: 조절된 새로운 UIColor
    func adjustBrightness(by amount: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue,
                         saturation: saturation,
                         brightness: min(brightness + amount, 1.0),
                         alpha: alpha)
        }
        return self
    }
}
