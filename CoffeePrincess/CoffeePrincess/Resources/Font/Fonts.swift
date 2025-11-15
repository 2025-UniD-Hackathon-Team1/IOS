//
//  Fonts.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/15/25.
//

import Foundation
import SwiftUI

extension Font {
    enum Pretendard: String {
        case black = "Pretendard-Black"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        case semiBold = "Pretendard-SemiBold"
        case thin = "Pretendard-Thin"
        
        func font(size: CGFloat) -> Font {
            return .custom(self.rawValue, size: size)
        }
    }
    
    
    ///
    /// 사용 예시:
    ///
    /// Text("안녕하세요")
    ///     .font(.pretendard(.bold, size: 18))
    ///
    static func pretendard(_ weight: Pretendard, size: CGFloat) -> Font {
        return weight.font(size: size)
    }
}
