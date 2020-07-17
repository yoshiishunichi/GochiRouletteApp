//
//  UIColor-Extension.swift
//  GochiRouletApp
//
//  Created by 犬 on 2020/07/11.
//  Copyright © 2020 吉井 駿一. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
 