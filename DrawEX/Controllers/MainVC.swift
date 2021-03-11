//
//  MainVC.swift
//  DrawEX
//
//  Created by Tien on 2017/11/10.
//  Copyright © 2017年 Tien. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet var mainView: MainView!
    var originPoint:CGPoint!
    var verticalSlider:UISlider!
    var viewWidth:CGFloat!
    var viewHeight:CGFloat!
    var rootLayer:CAShapeLayer!
    var containLayer:CAShapeLayer!
    var data = [0,0,0,0,0]
    var yEndPoint:CGPoint!
    var xEndPoint:CGPoint!
    var axisLabelAry = [UILabel]()
    var barStartPointAry = [CGPoint]()
    let fontSize:Float = 16.0
    var dataSliders = [UISlider]()
    var xLong:CGFloat!
    var yLong:CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSliders.append(self.mainView.Slider1)
        dataSliders.append(self.mainView.Slider2)
        dataSliders.append(self.mainView.Slider3)
        dataSliders.append(self.mainView.Slider4)
        dataSliders.append(self.mainView.Slider5)
        self.verticalSlider = self.mainView.verticalSlider
        verticalSlider.transform = .init(rotationAngle: CGFloat(270*Double.pi/180)) //slider rotate 270
        viewWidth = self.mainView.bounds.width
        viewHeight = self.mainView.bounds.height
        originPoint = CGPoint(x: viewWidth*0.1, y: viewHeight*0.9)
        yEndPoint = CGPoint(x: originPoint.x, y: originPoint.y-viewHeight*CGFloat(0.6*verticalSlider.value))         //計算y最遠的點
        xEndPoint = CGPoint(x: originPoint.x+viewWidth*CGFloat(0.8*verticalSlider.value), y: originPoint.y)                                        //計算x最遠的點
        
        for _ in 1...12{
            let label = UILabel()
            axisLabelAry.append(label)
            self.mainView.addSubview(label)
        }
        for _ in 1...data.count{
            let point = CGPoint()
            barStartPointAry.append(point)
        }
        drawAxis()
        drawBar()
        // Do any additional setup after loading the view.
    }
    @IBAction func axisSliderValueChanged(_ sender: UISlider) {
        rootLayer.removeFromSuperlayer()
        containLayer.removeFromSuperlayer()
        //重新計算x.y終點
        yEndPoint = CGPoint(x: originPoint.x, y: originPoint.y-viewHeight*CGFloat(0.6*verticalSlider.value))
        xEndPoint = CGPoint(x: originPoint.x+viewWidth*CGFloat(0.8*verticalSlider.value), y: originPoint.y)
        //重新繪製底圖
        drawAxis()
        drawBar()
    }
    @IBAction func dataSliderValueChanged(_ sender: UISlider) {
        containLayer.removeFromSuperlayer()
        drawBar()
    }
    
    func drawAxis(){
        let path = UIBezierPath()
        xLong = xEndPoint.x - originPoint.x
        yLong = -(yEndPoint.y - originPoint.y)
    
        rootLayer = CAShapeLayer()
        path.move(to: originPoint) // X
        path.addLine(to: yEndPoint)
        path.move(to: originPoint) // Y
        path.addLine(to: xEndPoint)
        //刻度-----------------------------------------
        for i in 0...data.count{
            //因為要有資料筆數的刻度 所以長度要分成筆數＋1等分
            //----------------------Axis X-------------------------------
            path.move(to: CGPoint(x: originPoint.x+xLong*CGFloat(i+1)/CGFloat(data.count+1), y: originPoint.y))
            path.addLine(to: CGPoint(x: originPoint.x+xLong*CGFloat(i+1)/CGFloat(data.count+1), y: originPoint.y+5))
            axisLabelAry[i].frame = CGRect(x: originPoint.x+xLong*CGFloat(i+1)/CGFloat(data.count+1), y: originPoint.y+5, width: CGFloat(fontSize*verticalSlider.value), height: CGFloat(fontSize*verticalSlider.value))
            axisLabelAry[i].text = "\(i+1)"
            axisLabelAry[i].font = axisLabelAry[i].font.withSize(CGFloat(fontSize*verticalSlider.value))
            //----------------------Axis X-------------------------------
            if i != 5 { //append Point
                barStartPointAry[i] = CGPoint(x: originPoint.x+xLong*CGFloat(i+1)/CGFloat(data.count+1), y: originPoint.y)
            }
            //----------------------Axis Y-------------------------------
            path.move(to: CGPoint(x: originPoint.x, y: originPoint.y-yLong*CGFloat(i+1)/CGFloat(data.count+1)))
            path.addLine(to: CGPoint(x: originPoint.x-5, y: originPoint.y-yLong*CGFloat(i+1)/CGFloat(data.count+1)))
            axisLabelAry[i+data.count+1].frame = CGRect(x: originPoint.x-0.05*yLong, y: originPoint.y-yLong*CGFloat(i+1)/CGFloat(data.count+1)-0.015*yLong, width: CGFloat(fontSize*verticalSlider.value), height: CGFloat(fontSize*verticalSlider.value))
            axisLabelAry[i+data.count+1].text = "\(i+1)"
            axisLabelAry[i+data.count+1].font = axisLabelAry[i].font.withSize(CGFloat(fontSize*verticalSlider.value))
            //-----------------------AxisY----------------------------------
        }
        rootLayer.path = path.cgPath
        rootLayer.strokeColor = UIColor.black.cgColor
        self.mainView.layer.addSublayer(rootLayer)
    }
    func drawBar(){
        let path = UIBezierPath()
        containLayer = CAShapeLayer()
        for i in 0..<barStartPointAry.count{
            path.move(to: barStartPointAry[i])
            path.addLine(to: CGPoint(x: barStartPointAry[i].x, y: barStartPointAry[i].y-yLong*CGFloat(dataSliders[i].value)))
        }
        containLayer.path = path.cgPath
        containLayer.lineWidth = 0.10 * xLong
        containLayer.strokeColor = UIColor.blue.cgColor
        self.mainView.layer.addSublayer(containLayer)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
