//
//  EnterViewController.swift
//  GochiRouletApp
//
//  Created by 犬 on 2020/07/08.
//  Copyright © 2020 吉井 駿一. All rights reserved.
//

import Foundation
import UIKit

class EnterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var names = [String]()
    var rates = [String]()
    
    var cellIds = [String]()
    
    
    var numbers = 1
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        for i in 0..<numbers{
            cellIds.append("cellId" + String(i+1))
        }
        let cell = enterTableView.dequeueReusableCell(withIdentifier: cellIds[indexPath.row], for: indexPath) as! EnterTableViewCell
        
        cell.label.text = String(indexPath.row + 1) + "人目"
        
        return cell
    }
    
    @IBOutlet weak var enterTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        names = Array<String>(repeating: "", count: numbers)
        rates = Array<String>(repeating: "", count: numbers)
        enterTableView.delegate = self
        enterTableView.dataSource = self
        
        enterTableView.keyboardDismissMode = .onDrag
    }
 
    @IBAction func tappedMakeButton(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        for i in 0..<numbers{
            
            viewController.names.append(self.names[i])
            if rates[i] == "0"{
                rates[i] = "1"
            }
            viewController.rates.append(Int(rates[i]) ?? 1)
        }
        viewController.number = self.numbers
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    //キーボードの出現を感知
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillBeHidden),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    // キーボードが隠れないようにする
    @objc func keyboardWillBeShown(notification: NSNotification) {
        print("開いた")
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size.height
        enterTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 5, right: 0)
        
        //更新された値を保持していく
        let firstCell = enterTableView.visibleCells[0] as! EnterTableViewCell
        let firstRow = enterTableView.indexPath(for: firstCell)?.row
        for i in 0..<enterTableView.visibleCells.count{
            let thisCell = enterTableView.visibleCells[i] as! EnterTableViewCell
            names[(firstRow ?? 0) + i] = thisCell.nametextField.text ?? ""
            if Int(thisCell.rateTextField.text ?? "") == nil{
                thisCell.rateTextField.text = ""
            }
            rates[(firstRow ?? 0) + i] = thisCell.rateTextField.text ?? "1"
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification) {
        print("閉じた")
        enterTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //更新された値を保持していく
        let firstCell = enterTableView.visibleCells[0] as! EnterTableViewCell
        let firstRow = enterTableView.indexPath(for: firstCell)?.row
        for i in 0..<enterTableView.visibleCells.count{
            let thisCell = enterTableView.visibleCells[i] as! EnterTableViewCell
            names[(firstRow ?? 0) + i] = thisCell.nametextField.text ?? ""
            if Int(thisCell.rateTextField.text ?? "") == nil{
                thisCell.rateTextField.text = ""
            }
            rates[(firstRow ?? 0) + i] = thisCell.rateTextField.text ?? "1"
        }
    }
    
    //これで、キーボードをキーボードの外タップして消せる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}

class EnterTableViewCell: UITableViewCell{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nametextField: UITextField!
    @IBOutlet weak var rateTextField: CustomUITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        rateTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    @objc func textFieldDidChange(){
        // 1桁にする
        guard let text = rateTextField.text else {return}
        rateTextField.text = String(text.prefix(1))
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //これで、キーボードをキーボードの外タップして消せる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        endEditing(true)
    }
    
}

class EnterTableView: UITableView{
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.endEditing(true)
    }
    
    //returnでキーボードを閉じる
    @IBAction func returnTextField(_ sender: Any) {
    }
    @IBAction func returnRateTextField(_ sender: Any) {
    }
    
}
