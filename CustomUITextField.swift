//
//  CustomUITextField.swift
//  GochiRouletApp
//
//  Created by 犬 on 2020/07/11.
//  Copyright © 2020 吉井 駿一. All rights reserved.
//

import UIKit

class CustomUITextField: UITextField {

 // コピーとペーストを禁止にする
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        return true
    }

}
