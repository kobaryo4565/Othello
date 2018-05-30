//
//  ViewController.swift
//  オセロ
//
//  Created by Kobayashi Ryo on 2018/05/02.
//  Copyright © 2018年 Kobayashi Ryo. All rights reserved.
//

import UIKit


extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(false)
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let png = UIImagePNGRepresentation(image)!
        let pngImage = UIImage.init(data: png)!
        return pngImage
    }
}

var Finallocation1: CGFloat? //グローバル変数を定義するときは?か!が必要
var Finallocation2: CGFloat?

class ViewController: UIViewController {

    var label:UILabel! //labelの型が無を含んだUILabelクラスであることを示す（オプショナル型）なんで無がいるの？//型を明示的に指定するvar＜変数名＞：＜型＞ //型はクラスにもなる、？
    var myLabel: UILabel!
    var myLabel2: UILabel!
    var mylabel = [UILabel(), UILabel(), UILabel(),UILabel(), UILabel(), UILabel(),UILabel(), UILabel(), UILabel(),UILabel()]
    
    var turn = 1 //初期値1の変数turn
    
    enum actionTag: Int {
        case action1 = 0
        case action2 = 1
    }

    
    /*var stage:[[Int]] = [ //配列の中の型を明示的に指定するvar＜変数名＞：[[＜型＞]] //なんでカギカッコ二個いるの？
        [0,0,0,0,0,0,0,0], //コマのデータを格納するための変数
        [0,0,0,0,0,0,0,0], //白が１、黒が−１、コマがないところは０とする
        [0,0,0,0,0,0,0,0], //盤面が8×８で、一番上はラベル配置のための段
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
    ]*/
    
    @IBOutlet weak var mainView: UIView!
    
    @IBAction func ShowActivityView(_ sender: UIBarButtonItem) {
        let controller = UIActivityViewController(activityItems: [/*mainView*/viewDidLoad()], applicationActivities: nil) //UIActivityViewControllerはメールやツイッター、アイクラウド共有などの機能一覧画面を表示するクラス
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func save(_ sender: UIBarButtonItem) {
         UIImageWriteToSavedPhotosAlbum(view.snapshot(), self, #selector(saved(_: didFinishSavingWithError: contextInfo:)), nil)
    }
    
    @objc private func saved(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        if error != nil {
            print("error")
        } else {
            print("success")
        }
    }
    
    @IBAction func trash(_ sender: UIBarButtonItem) {
        self.view.subviews.forEach { //ラベルを消すための関数
            for n in 1 ... 10{
            if $0.tag == n{
                $0.removeFromSuperview()
            }
            }
        }
         print("駒1が消されました")
    }
    @IBAction func Add(_ sender: UIBarButtonItem) {
        for n in 0 ... 9 {
        self.view.addSubview(mylabel[n]/*myLabel2*/)
        }
        print("駒2がViewに追加されました")
    }
    override func viewDidLoad() {//親クラスを編集することなく、子クラスの中で親クラスのメソッドを上書きできる
        super.viewDidLoad()
        
        // ->背景色を白色に変更する
        self.view.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view, typically from a nib.
        let (screenWidth, screenHeight) = (self.view.bounds.width, self.view.bounds.height)
        let (width, height) = (screenWidth/16, screenHeight/7) //１マスあたりの幅と高さを指定
        
        for i in 0 ..< 16{
            for j in 0 ..< 5{ //jが縦、iが横（ただし、デバイスを立てで見たとき）
                let label1 = UILabel(frame: CGRectMake(width*CGFloat(i),height*CGFloat(j+1),width,height)) //jだけにすると、最上段の空白がなくなる（番号をつけたいので空白で良い）
                //button.setTitle(" ", for: .normal) //コメントアウトしても実行結果は変わらない、、
                //button.setTitleColor(UIColor.blue/*black*/, for: .normal) //盤上の駒の色を指定するプロパティ
                //button.setTitleColor(UIColor.yellow/*lightGray*/, for: .highlighted) //いつ発動するの？
                label1/*button*/.layer.borderColor = UIColor.gray/*black*/.cgColor //線の色を指定するプロパティ
                label1/*button*/.layer.borderWidth = 1.0 //線幅を指定するプロパティ
                //button.tag = i * 10 + j //よくわからんけどコマが消えた
                //button.addTarget(self, action: Selector(("button:")), for: .touchUpInside)
                self.view.addSubview(label1/*button*/)//コメントアウトするとマス目がなくなったから必要っぽい
            }
        }
        //self.label = UILabel(frame: CGRectMake(0,0,screenWidth,height)) //コメントアウトしたら画面に何も表示されなくなったから重要っぽい
        //self.view.addSubview(self.label!) //コメントアウトしたら画面に何も表示されなくなったから重要っぽい
       print("マス目がViewに追加されました")
        
        //self.update() //よくわかんないけどコメント外すとエラーになる
        
        // Labelを生成.
        /*mylabel[0] = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        mylabel[0].text = "1"
        mylabel[0].textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        mylabel[0].backgroundColor = UIColor.red
        mylabel[0].layer.masksToBounds = true
        mylabel[0].center = self.view.center //画面の短い方の中心に来るように設定
        mylabel[0].layer.cornerRadius = 20.0
        mylabel[0].tag = 1 //消したいラベルをタグで指定するために必要*/
        
        
        
        // Label2を生成.
        /*mylabel[1]/*myLabel2*/ = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        mylabel[1]/*myLabel2*/.text = "2"
        mylabel[1]/*myLabel2*/.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        mylabel[1]/*myLabel2*/.backgroundColor = UIColor.blue
        mylabel[1]/*myLabel2*/.layer.masksToBounds = true
        mylabel[1]/*myLabel2*/.center = self.view.center //画面の短い方の中心に来るように設定
        mylabel[1]/*myLabel2*/.layer.cornerRadius = 20.0*/
        
        for n in 0...9 {
            mylabel[n] = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            //mylabel[n].text = "1"
            mylabel[n].textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
            mylabel[n].layer.masksToBounds = true
            mylabel[n].center = self.view.center //画面の短い方の中心に来るように設定
            mylabel[n].layer.cornerRadius = 20.0
            //mylabel[n].tag = 1 //消したいラベルをタグで指定するために必要
            
            switch n {
            case 0 :
                mylabel[0].backgroundColor = UIColor.red
                mylabel[0].text = "1"
                //mylabel[0].center = self.view.center
                mylabel[0].tag = 10 //消したいラベルをタグで指定するために必要*/
            case 1 :
                mylabel[1].backgroundColor = UIColor.blue
                mylabel[1].text = "2"
                 mylabel[1].tag = 1 //消したいラベルをタグで指定するために必要*/
            case 2 :
                mylabel[2].backgroundColor = UIColor.yellow
                mylabel[2].text = "3"
                mylabel[2].tag = 2 //消したいラベルをタグで指定するために必要*/
            case 3 :
                mylabel[3].backgroundColor = UIColor.green
                mylabel[3].text = "4"
                 mylabel[3].tag = 3 //消したいラベルをタグで指定するために必要*/
            case 4 :
                mylabel[4].backgroundColor = UIColor.black
                mylabel[4].textColor = UIColor.white
                mylabel[4].text = "5"
                mylabel[4].tag = 4 //消したいラベルをタグで指定するために必要*/
            case 5 :
                mylabel[5].backgroundColor = UIColor.gray
                mylabel[5].text = "6"
                mylabel[5].tag = 5 //消したいラベルをタグで指定するために必要*/
            case 6 :
                mylabel[6].backgroundColor = UIColor.magenta
                mylabel[6].text = "7"
                mylabel[6].tag = 6 //消したいラベルをタグで指定するために必要*/
            case 7 :
                mylabel[7].backgroundColor = UIColor.cyan
                mylabel[7].text = "8"
                 mylabel[7].tag = 7 //消したいラベルをタグで指定するために必要*/
            case 8 :
                mylabel[8].backgroundColor = UIColor.orange
                mylabel[8].text = "9"
                 mylabel[8].tag = 8 //消したいラベルをタグで指定するために必要*/
            case 9 :
                mylabel[9].backgroundColor = UIColor.purple
                mylabel[9].text = "10"
                 mylabel[9].tag = 9 //消したいラベルをタグで指定するために必要*/
                
            default:
                break
            }
            self.view.addSubview(mylabel[n])
        }
        
        // Labe1をviewに追加.
        //self.view.addSubview(mylabel[0])
        //print("駒1がViewに追加されました")
        
        // Labe2をviewに追加.
        //self.view.addSubview(myLabel2)
        //print("駒2がViewに追加されました")
        
        //場ミリ表示
        // UIButton用のフォントサイズの文字列をラベルに表示する.
        let myButtonLabel: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)/2), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel.text = "0"
        self.view.addSubview(myButtonLabel)
        
        let myButtonLabel1: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*9/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel1.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel1.text = "1"
        self.view.addSubview(myButtonLabel1)
        
        let myButtonLabel1l: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*7/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel1l.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel1l.text = "1"
        self.view.addSubview(myButtonLabel1l)
        
        let myButtonLabel2: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*10/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel2.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel2.text = "2"
        self.view.addSubview(myButtonLabel2)
        
        let myButtonLabel2l: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*6/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel2l.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel2l.text = "2"
        self.view.addSubview(myButtonLabel2l)
        
        let myButtonLabel3: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*11/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel3.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel3.text = "3"
        self.view.addSubview(myButtonLabel3)
        
        let myButtonLabel3l: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*5/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel3l.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel3l.text = "3"
        self.view.addSubview(myButtonLabel3l)
        
        let myButtonLabel4: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*12/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel4.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel4.text = "4"
        self.view.addSubview(myButtonLabel4)
        
        let myButtonLabel4l: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*4/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel4l.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel4l.text = "4"
        self.view.addSubview(myButtonLabel4l)
        
        let myButtonLabel5: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*13/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel5.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel5.text = "5"
        self.view.addSubview(myButtonLabel5)
        
        let myButtonLabel5l: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*3/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel5l.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel5l.text = "5"
        self.view.addSubview(myButtonLabel5l)
        
        let myButtonLabel6: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*14/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel6.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel6.text = "6"
        self.view.addSubview(myButtonLabel6)
        
        let myButtonLabel6l: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*2/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel6l.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel6l.text = "6"
        self.view.addSubview(myButtonLabel6l)
        
        let myButtonLabel7: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*15/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel7.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel7.text = "7"
        self.view.addSubview(myButtonLabel7)
        
        let myButtonLabel7l: UILabel = UILabel(frame: CGRect(x: ((self.view.bounds.width-10)*1/16), y: 0, width: 320, height: 75))
        //myButtonLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        //myButtonLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myButtonLabel7l.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        myButtonLabel7l.text = "7"
        self.view.addSubview(myButtonLabel7l)

    }

    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect{
        return CGRect(x:x,y:y,width:width,height:height)
    }
    
    
    
    /*
     タッチを感知した際に呼ばれるメソッド.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("touchesBegan")
        for n in 0...9 {
         mylabel[n].isUserInteractionEnabled = true
        }
        print("touchesBeganが呼ばれました")
        // Labelアニメーション.
        UIView.animate(withDuration: 0.06,
                       // アニメーション中の処理.
            animations: { () -> Void in
                if let labelT = touches.first?.view as? UILabel {
                    labelT.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    //labelに対してあんなことや、こんなことを‥
                }
                /*func UITouch(sender: UILabel){
                    switch sender.tag{
                    case 0: self.mylabel[0].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    case 1: self.mylabel[1].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    case 2: self.mylabel[2].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    case 3: self.mylabel[3].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    case 4: self.mylabel[4].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    case 5: self.mylabel[5].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    case 6: self.mylabel[6].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    case 7: self.mylabel[7].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    case 8: self.mylabel[8].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    case 9: self.mylabel[9].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    default:
                        break
                    }
                }*/
                //for n in 0...9 {
                // 縮小用アフィン行列を作成する.
                //self.mylabel[n].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                //}
        })
        { (Bool) -> Void in
        }
        
        
    }
    
    /*
     ドラッグを感知した際に呼ばれるメソッド.
     (ドラッグ中何度も呼ばれる)
     */
    
        
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for n in 0...9 {
            mylabel[n].isUserInteractionEnabled = true
        }
        print("touchesMovedが呼ばれました")
        //label.isUserInteractionEnabled = true
        // タッチイベントを取得.
        let aTouch: UITouch = touches.first!
        
        // 移動した先の座標を取得.
        if let labelT = touches.first?.view as? UILabel {
            labelT.isUserInteractionEnabled = true
            let location = aTouch.location(in: labelT/*self.view*/)
            let prevLocation = aTouch.previousLocation(in: labelT/*self.view*/)
            var myFrame: CGRect = labelT/*self.view*/.frame
            let deltaX: CGFloat = location.x - prevLocation.x
            let deltaY: CGFloat = location.y - prevLocation.y
            myFrame.origin.x += deltaX
            myFrame.origin.y += deltaY
            Finallocation1 = myFrame.origin.x
            Finallocation2 = myFrame.origin.y
            labelT/*self.view*/.frame = myFrame
            //labelに対してあんなことや、こんなことを‥
        }
        /*func aTouch(sender: UILabel){
            switch sender.tag{
            case 0:
                let location_0 = aTouch.location(in: mylabel[0]/*self.view*/)
                let prevLocation_0 = aTouch.previousLocation(in: mylabel[0]/*self.view*/)
                var myFrame_0: CGRect = mylabel[0]/*self.view*/.frame
                let deltaX_0: CGFloat = location_0.x - prevLocation_0.x
                let deltaY_0: CGFloat = location_0.y - prevLocation_0.y
                myFrame_0.origin.x += deltaX_0
                myFrame_0.origin.y += deltaY_0
                Finallocation1 = myFrame_0.origin.x
                Finallocation2 = myFrame_0.origin.y
                mylabel[0]/*self.view*/.frame = myFrame_0
            case 1:
                let location_1 = aTouch.location(in: mylabel[1]/*self.view*/)
                let prevLocation_1 = aTouch.previousLocation(in: mylabel[1]/*self.view*/)
                var myFrame_1: CGRect = mylabel[1]/*self.view*/.frame
                let deltaX_1: CGFloat = location_1.x - prevLocation_1.x
                let deltaY_1: CGFloat = location_1.y - prevLocation_1.y
                myFrame_1.origin.x += deltaX_1
                myFrame_1.origin.y += deltaY_1
                Finallocation1 = myFrame_1.origin.x
                Finallocation2 = myFrame_1.origin.y
                mylabel[1]/*self.view*/.frame = myFrame_1
            case 2:
                let location_2 = aTouch.location(in: mylabel[2]/*self.view*/)
                let prevLocation_2 = aTouch.previousLocation(in: mylabel[2]/*self.view*/)
                var myFrame_2: CGRect = mylabel[2]/*self.view*/.frame
                let deltaX_2: CGFloat = location_2.x - prevLocation_2.x
                let deltaY_2: CGFloat = location_2.y - prevLocation_2.y
                myFrame_2.origin.x += deltaX_2
                myFrame_2.origin.y += deltaY_2
                Finallocation1 = myFrame_2.origin.x
                Finallocation2 = myFrame_2.origin.y
                mylabel[2]/*self.view*/.frame = myFrame_2
                
            case 3:
                let location_3 = aTouch.location(in: mylabel[3]/*self.view*/)
                let prevLocation_3 = aTouch.previousLocation(in: mylabel[3]/*self.view*/)
                var myFrame_3: CGRect = mylabel[3]/*self.view*/.frame
                let deltaX_3: CGFloat = location_3.x - prevLocation_3.x
                let deltaY_3: CGFloat = location_3.y - prevLocation_3.y
                myFrame_3.origin.x += deltaX_3
                myFrame_3.origin.y += deltaY_3
                Finallocation1 = myFrame_3.origin.x
                Finallocation2 = myFrame_3.origin.y
                mylabel[3]/*self.view*/.frame = myFrame_3
                
            case 4:
                let location_4 = aTouch.location(in: mylabel[4]/*self.view*/)
                let prevLocation_4 = aTouch.previousLocation(in: mylabel[4]/*self.view*/)
                var myFrame_4: CGRect = mylabel[4]/*self.view*/.frame
                let deltaX_4: CGFloat = location_4.x - prevLocation_4.x
                let deltaY_4: CGFloat = location_4.y - prevLocation_4.y
                myFrame_4.origin.x += deltaX_4
                myFrame_4.origin.y += deltaY_4
                Finallocation1 = myFrame_4.origin.x
                Finallocation2 = myFrame_4.origin.y
                mylabel[4]/*self.view*/.frame = myFrame_4
                
            case 5:
                let location_5 = aTouch.location(in: mylabel[5]/*self.view*/)
                let prevLocation_5 = aTouch.previousLocation(in: mylabel[5]/*self.view*/)
                var myFrame_5: CGRect = mylabel[5]/*self.view*/.frame
                let deltaX_5: CGFloat = location_5.x - prevLocation_5.x
                let deltaY_5: CGFloat = location_5.y - prevLocation_5.y
                myFrame_5.origin.x += deltaX_5
                myFrame_5.origin.y += deltaY_5
                Finallocation1 = myFrame_5.origin.x
                Finallocation2 = myFrame_5.origin.y
                mylabel[5]/*self.view*/.frame = myFrame_5
                
            case 6:
                let location_6 = aTouch.location(in: mylabel[6]/*self.view*/)
                let prevLocation_6 = aTouch.previousLocation(in: mylabel[6]/*self.view*/)
                var myFrame_6: CGRect = mylabel[6]/*self.view*/.frame
                let deltaX_6: CGFloat = location_6.x - prevLocation_6.x
                let deltaY_6: CGFloat = location_6.y - prevLocation_6.y
                myFrame_6.origin.x += deltaX_6
                myFrame_6.origin.y += deltaY_6
                Finallocation1 = myFrame_6.origin.x
                Finallocation2 = myFrame_6.origin.y
                mylabel[6]/*self.view*/.frame = myFrame_6
                
            case 7:
                let location_7 = aTouch.location(in: mylabel[7]/*self.view*/)
                let prevLocation_7 = aTouch.previousLocation(in: mylabel[7]/*self.view*/)
                var myFrame_7: CGRect = mylabel[7]/*self.view*/.frame
                let deltaX_7: CGFloat = location_7.x - prevLocation_7.x
                let deltaY_7: CGFloat = location_7.y - prevLocation_7.y
                myFrame_7.origin.x += deltaX_7
                myFrame_7.origin.y += deltaY_7
                Finallocation1 = myFrame_7.origin.x
                Finallocation2 = myFrame_7.origin.y
                mylabel[7]/*self.view*/.frame = myFrame_7
                
            case 8:
                let location_8 = aTouch.location(in: mylabel[8]/*self.view*/)
                let prevLocation_8 = aTouch.previousLocation(in: mylabel[8]/*self.view*/)
                var myFrame_8: CGRect = mylabel[8]/*self.view*/.frame
                let deltaX_8: CGFloat = location_8.x - prevLocation_8.x
                let deltaY_8: CGFloat = location_8.y - prevLocation_8.y
                myFrame_8.origin.x += deltaX_8
                myFrame_8.origin.y += deltaY_8
                Finallocation1 = myFrame_8.origin.x
                Finallocation2 = myFrame_8.origin.y
                mylabel[8]/*self.view*/.frame = myFrame_8
                
            case 9:
                let location_9 = aTouch.location(in: mylabel[9]/*self.view*/)
                let prevLocation_9 = aTouch.previousLocation(in: mylabel[9]/*self.view*/)
                var myFrame_9: CGRect = mylabel[9]/*self.view*/.frame
                let deltaX_9: CGFloat = location_9.x - prevLocation_9.x
                let deltaY_9: CGFloat = location_9.y - prevLocation_9.y
                myFrame_9.origin.x += deltaX_9
                myFrame_9.origin.y += deltaY_9
                Finallocation1 = myFrame_9.origin.x
                Finallocation2 = myFrame_9.origin.y
                mylabel[9]/*self.view*/.frame = myFrame_9
            default:
                break
            }
        }*/
        
         //for n in 0...9 {
        //let location_n = aTouch.location(in: mylabel[n]/*self.view*/)
        // 移動する前の座標を取得.
        //let prevLocation_n = aTouch.previousLocation(in: mylabel[n]/*self.view*/)
        // CGRect生成.
        //var myFrame_n: CGRect = mylabel[n]/*self.view*/.frame
        // ドラッグで移動したx, y距離をとる.
        //let deltaX_n: CGFloat = location_n.x - prevLocation_n.x
        //let deltaY_n: CGFloat = location_n.y - prevLocation_n.y
        // 移動した分の距離をmyFrameの座標にプラスする.
        //myFrame_n.origin.x += deltaX_n
        //myFrame_n.origin.y += deltaY_n
        //Finallocation1 = myFrame_n.origin.x
        //Finallocation2 = myFrame_n.origin.y
        // frameにmyFrameを追加.
        //mylabel[n]/*self.view*/.frame = myFrame_n
        //}
        
        
        
        
        
        
        // 移動する前の座標を取得.
         /*for n in 0...9 {
        let prevLocation_n = aTouch.previousLocation(in: mylabel[n]/*self.view*/)
        }*/
        // CGRect生成.
       // var myFrame: CGRect = mylabel[0]/*self.view*/.frame
        
        // ドラッグで移動したx, y距離をとる.
        /*let deltaX: CGFloat = location.x - prevLocation.x
        let deltaY: CGFloat = location.y - prevLocation.y*/
        
        // 移動した分の距離をmyFrameの座標にプラスする.
        /*myFrame.origin.x += deltaX
        myFrame.origin.y += deltaY
        Finallocation1 = myFrame.origin.x
        Finallocation2 = myFrame.origin.y*/
        // frameにmyFrameを追加.
        //mylabel[0]/*self.view*/.frame = myFrame
    }
    
    /*
     指が離れたことを感知した際に呼ばれるメソッド.
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for n in 0...9 {
            mylabel[n].isUserInteractionEnabled = true
        }
        print("touchesEndedが呼ばれました")
        //label.isUserInteractionEnabled = true
        // Labelアニメーション.
        UIView.animate(withDuration: 0.1,
                       
                       // アニメーション中の処理.
            animations: { () -> Void in
                if let labelT = touches.first?.view as? UILabel {
                    labelT.isUserInteractionEnabled = true
                    labelT.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                    labelT.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    //labelに対してあんなことや、こんなことを‥
                }
                /*func myFunc(sender: UILabel){
                    switch sender.tag{
                    case 0:
                        self.mylabel[0].transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                        self.mylabel[0].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    case 1:
                        self.mylabel[1].transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                        self.mylabel[1].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        
                    case 2:
                        self.mylabel[2].transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                        self.mylabel[2].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    case 3:
                        self.mylabel[3].transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                        self.mylabel[3].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    case 4:
                        self.mylabel[4].transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                        self.mylabel[4].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        
                    case 5:
                        self.mylabel[5].transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                        self.mylabel[5].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    case 6:
                        self.mylabel[6].transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                        self.mylabel[6].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    case 7:
                        self.mylabel[7].transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                        self.mylabel[7].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                    case 8:
                        self.mylabel[8].transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                        self.mylabel[8].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        
                    case 9:
                        self.mylabel[9].transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                        self.mylabel[9].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        
                    default:
                        break
                    }
                }*/
                        
                /*for n in 0...9 {
                // 拡大用アフィン行列を作成する.
                self.mylabel[n].transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                // 縮小用アフィン行列を作成する.
                self.mylabel[n].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }*/
        })
        { (Bool) -> Void in
            
        }
        
        print("移動先の座標は、x=\(Finallocation1 as CGFloat?)、y=\(Finallocation2 as CGFloat?)です") //as 型を用いれば警告を解消できる
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}



