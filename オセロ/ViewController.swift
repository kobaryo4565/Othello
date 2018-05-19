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

var Finallocation: CGPoint?

class ViewController: UIViewController {

    var label:UILabel! //labelの型が無を含んだUILabelクラスであることを示す（オプショナル型）なんで無がいるの？//型を明示的に指定するvar＜変数名＞：＜型＞ //型はクラスにもなる、？
    var myLabel: UILabel!
    //var myLabel2: UILabel!
    var turn = 1 //初期値1の変数turn
    
    
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
        myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        myLabel.text = "1"
        myLabel.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        myLabel.backgroundColor = UIColor.red
        myLabel.layer.masksToBounds = true
        myLabel.center = self.view.center //画面の短い方の中心に来るように設定
        myLabel.layer.cornerRadius = 20.0
        
        // Labe1をviewに追加.
        self.view.addSubview(myLabel)
        print("駒1がViewに追加されました")
        
        // Label2を生成.
        /*myLabel2 = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        myLabel2.text = "2"
        myLabel2.textAlignment = NSTextAlignment.center //画面長い方の中心に来るように設定違うかも
        myLabel2.backgroundColor = UIColor.blue
        myLabel2.layer.masksToBounds = true
        myLabel2.center = self.view.center //画面の短い方の中心に来るように設定
        myLabel2.layer.cornerRadius = 20.0
        
        // Labelをviewに追加.
        self.view.addSubview(myLabel2)
        print("駒2がViewに追加されました")*/
        
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
        print("touchesBeganが呼ばれました")
        
        // Labelアニメーション.
        UIView.animate(withDuration: 0.06,
                       // アニメーション中の処理.
            animations: { () -> Void in
                // 縮小用アフィン行列を作成する.
                self.myLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
        { (Bool) -> Void in
        }
    }
    
    /*
     ドラッグを感知した際に呼ばれるメソッド.
     (ドラッグ中何度も呼ばれる)
     */
    
    
        
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touchesMovedが呼ばれました")
        
        // タッチイベントを取得.
        let aTouch: UITouch = touches.first!
        
        // 移動した先の座標を取得.
        let location = aTouch.location(in: myLabel/*self.view*/)
        Finallocation = location
        
        // 移動する前の座標を取得.
        let prevLocation = aTouch.previousLocation(in: myLabel/*self.view*/)
        
        // CGRect生成.
        var myFrame: CGRect = myLabel/*self.view*/.frame
        
        // ドラッグで移動したx, y距離をとる.
        let deltaX: CGFloat = location.x - prevLocation.x
        let deltaY: CGFloat = location.y - prevLocation.y
        
        // 移動した分の距離をmyFrameの座標にプラスする.
        myFrame.origin.x += deltaX
        myFrame.origin.y += deltaY
        
        // frameにmyFrameを追加.
        myLabel/*self.view*/.frame = myFrame
    }
    
    /*
     指が離れたことを感知した際に呼ばれるメソッド.
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touchesEndedが呼ばれました")
        
        // Labelアニメーション.
        UIView.animate(withDuration: 0.1,
                       
                       // アニメーション中の処理.
            animations: { () -> Void in
                // 拡大用アフィン行列を作成する.
                self.myLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                // 縮小用アフィン行列を作成する.
                self.myLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        { (Bool) -> Void in
            
        }
        
        print("移動先の座標は\(Finallocation)です")
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}



