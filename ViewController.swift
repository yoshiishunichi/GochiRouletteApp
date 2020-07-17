//
//  ViewController.swift
//  GochiRouletApp
//
//  Created by 犬 on 2020/07/05.
//  Copyright © 2020 吉井 駿一. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ViewController: UIViewController {
    
    let path = Bundle.main.bundleURL.appendingPathComponent("sound.mp3")
    var audioPlayer = AVAudioPlayer()
    // EnterViewControllerから値を受け取る
    var names = [String]()
    var rates = [Int]()
    var number = 1
    
    var stop = true
    
    @IBOutlet weak var uiSwitch: UISwitch!
    
    var SoundOn = true
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var rouletImageView: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var rouletteImage = UIImage(named: "ルーレット")
    
    
    @IBAction func tappedStartButton(_ sender: Any) {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        if stop{
            
            self.resultLabel.text = "???"
            startButton.setTitle("ストップ", for: .normal)
            rouletImageView.layer.speed = 2
            // duration秒に何度動くか
            animation.toValue = .pi / 2.0
            // duration秒かけて
            animation.duration = 0.1
            // 無限に繰り返す
            animation.repeatCount = MAXFLOAT
            //二回目以降を続きからにするか
            animation.isCumulative = true
            
            rouletImageView.layer.add(animation, forKey: "ImageViewRotation")
            stop = false
            
            //ボタンを有効化
            startButton.isEnabled = true
            startButton.backgroundColor = .orange
            
        }
        else{
            
            let rand = Double.random(in: 2..<5)
            print("乱数",rand)
            
            rouletImageView.layer.speed = 2
            // duration秒に何度動くか
            animation.toValue = Float.pi
            // duration秒かけて
            animation.duration = 1
            // 無限に繰り返す
            animation.repeatCount = MAXFLOAT
            //二回目以降を続きからにするか
            animation.isCumulative = true
            
            rouletImageView.layer.add(animation, forKey: "ImageViewRotation")
            
            //ボタンを無効化
            startButton.backgroundColor = .gray
            startButton.isEnabled = false
            startButton.setTitle("抽選中...", for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + rand) {
                // rand秒後に実行したい処理
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    //ボタンを有効化
                    self.startButton.isEnabled = true
                    self.startButton.setTitle("やりなおす", for: .normal)
                    self.startButton.backgroundColor = .orange
                }
                self.startButton.setTitle("確定！", for: .normal)
                let pausedTime = self.rouletImageView.layer.convertTime(CACurrentMediaTime(), from: nil)
                self.rouletImageView.layer.speed = 0.0
                self.rouletImageView.layer.timeOffset = pausedTime
                
                self.stop = true
                
                let layer = self.rouletImageView.layer
                
                // 角度を取得する
                let transform: CATransform3D = layer.presentation()!.transform
                let angle: CGFloat = atan2(transform.m12, transform.m11)
                var testAngle = self.radiansToDegress(radians: angle)
                if testAngle < 0 {
                    testAngle = 360 + testAngle
                }
                var radian = CGFloat.pi / 180.0 * testAngle + .pi / 2.0
                if (radian >= 2 * .pi){
                    radian = radian - 2 * .pi
                }
                radian =  .pi * 2 - radian
                for i in 0..<self.number{
                    if (radian > self.SE[i][0]) && (radian < self.SE[i][1]){
                        self.resultLabel.text = self.names[i] + "さん、ゴチです！"
                        break
                    }
                }
                
                
                //音を鳴らす
                if self.SoundOn{
                    
                    
                    do {
                        // 効果音を鳴らす
                        self.audioPlayer = try AVAudioPlayer(contentsOf: self.path)
                        self.audioPlayer.play()
                    } catch {
                        print("エラー")
                    }
                }
            }
        }
    }
    
    // 円の描画
    //開始と終了角
    var SE = [[CGFloat]]()
    //幅
    var widths = [CGFloat]()
    //中心角
    var centers = [CGFloat]()
    //レイヤー
    var layers = [CAShapeLayer]()
    //パス
    var paths = [UIBezierPath]()
    //ラベル
    var nameLabels = [UILabel]()
    //色
    let colors = [UIColor.rgb(red: 252, green: 157, blue: 184), UIColor.cyan, UIColor.yellow, UIColor.red, UIColor.lightGray, UIColor.orange, UIColor.green, UIColor.brown, UIColor.blue, UIColor.purple]
    
    @IBOutlet weak var soundModeLabel: UILabel!
    @objc func clickSwitch(sender: UISwitch){
        
        if sender.isOn{
            print("on")
            soundModeLabel.text = "音on"
            SoundOn = true
        }
        else {
            print("off")
            soundModeLabel.text = "音off"
            SoundOn = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSwitch.addTarget(self, action: #selector(clickSwitch), for: UIControl.Event.valueChanged)
        
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.gray.cgColor
        startButton.layer.cornerRadius = 15
        
        let round = self.rouletImageView.frame.width / 2
        
        resultLabel.text = " "
        let rateSum = CGFloat(rates.reduce(0, +))
        //値受け取り
        for i in 0..<number{
            nameLabels.append(UILabel())
            nameLabels[i].text = names[i]
            widths.append(.pi * 2.0 * CGFloat(rates[i]) / rateSum)
            if i == 0{
                SE.append([0.0 , widths[i]])
            }
            else{
                SE.append([SE[i-1][1], SE[i-1][1] + widths[i]])
            }
            centers.append((SE[i][0] + SE[i][1]) / 2.0)
            paths.append(UIBezierPath())
            layers.append(CAShapeLayer())
        }
        
        for j in 0..<number{
            paths[j].move(to: CGPoint(x: self.rouletImageView.frame.width/2, y: self.rouletImageView.frame.height/2))
            paths[j].addArc(withCenter: CGPoint(x: self.rouletImageView.frame.width/2, y: self.rouletImageView.frame.height/2), radius: self.rouletImageView.frame.width/2, startAngle: SE[j][0], endAngle: SE[j][1], clockwise: true)
            if (j == number - 1) && (j != 0){
                var h = j
                var thisColor = colors[h % colors.count].cgColor
                repeat{
                    thisColor = colors[h % colors.count].cgColor
                    layers[j].fillColor = thisColor
                    h += 3
                }while (layers[j - 1].fillColor == thisColor) || (layers[0].fillColor == thisColor)
            }
            else{
                layers[j].fillColor = colors[j % colors.count].cgColor
            }
            layers[j].path = paths[j].cgPath
            
            self.rouletImageView.layer.addSublayer(layers[j])
            
            self.rouletImageView.addSubview(nameLabels[j])
            nameLabels[j].font = .systemFont(ofSize: 10)
            nameLabels[j].textColor = .black
            var cosin = 0.0
            var sine = 0.0
            if (centers[j] == CGFloat.pi / 2.0) || (centers[j] == CGFloat.pi * 3 / 2){
                cosin = 0.0
            }
            else {
                cosin = Double(cos(centers[j]))
            }
            if (centers[j] == CGFloat.pi){
                sine = 0.0
            }
            else {
                sine = Double(sin(centers[j]))
            }
            
            //名前を配置
            var length = 0.0
            if names[j].count > 12{
                length = 12 * 20
            }
            else{
                length = Double(names[j].count) * 20.0
            }
            nameLabels[j].frame = CGRect(x: round + ((round - 40) * CGFloat(cosin)), y: round + ((round - 40) * CGFloat(sine)), width: CGFloat(length), height: CGFloat(length))
            nameLabels[j].center = CGPoint(x: round + ((round - 20) * CGFloat(cosin)), y: round + ((round - 20) * CGFloat(sine)))
            
            nameLabels[j].transform = CGAffineTransform(rotationAngle: centers[j]);
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("メモリーワーニング")
    }
    
    func radiansToDegress(radians: CGFloat) -> CGFloat {
        return radians * 180 / CGFloat(Double.pi)
    }
}

