//
//  NumberViewController.swift
//  GochiRouletApp
//
//  Created by 犬 on 2020/07/08.
//  Copyright © 2020 吉井 駿一. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class NumberViewController: UIViewController{
    @IBOutlet weak var numberTextField: UITextField!
    @IBAction func tappedNextButton(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Enter", bundle: nil)
        let enterViewController = storyboard.instantiateViewController(withIdentifier: "EnterViewController") as! EnterViewController
        if Int(self.numberTextField.text ?? "") ?? 1 < 1{
            self.numberTextField.text = "1"
        }
        enterViewController.numbers = Int(self.numberTextField.text ?? "1") ?? 1
        navigationController?.pushViewController(enterViewController, animated: true)
    }
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 15
        nextButton.layer.borderColor = UIColor.gray.cgColor
        nextButton.layer.borderWidth = 1
        numberTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        //admob
        let gadBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        gadBannerView.center = self.view.center
        gadBannerView.adUnitID = "ca-app-pub-1923099754481403/5596242427"
        gadBannerView.rootViewController = self;
        let request = GADRequest();
        gadBannerView.load(request)
        
        gadBannerView.frame = CGRect(x: 0, y: view.frame.height - gadBannerView.frame.height, width: view.frame.width, height: gadBannerView.frame.height)
        
        self.view.addSubview(gadBannerView)
    }
    @objc func textFieldDidChange(){
        // 2桁にする
        guard let text = numberTextField.text else {return}
        numberTextField.text = String(text.prefix(2))
    }
    
    //これで、キーボードをキーボードの外タップして消せる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //returnでキーボードを閉じる
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func returnEndTextField(_ sender: Any) {
        
    }
    
}

