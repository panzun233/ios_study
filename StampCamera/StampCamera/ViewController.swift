//
//  ViewController.swift
//  StampCamera
//
//  Created by Zun Pan on 2020/06/18.
//  Copyright © 2020 Pan Zun. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pickerController = UIImagePickerController()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var mainImageView:UIImageView!
    //スタンプ画像を配置するUIView
    @IBOutlet var canvasView: UIView!
    //AppDelegateを使うための変数
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
      let pickedImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
      mainImageView.image = pickedImage
        print("image 受け渡し成功")
      picker.dismiss(animated: true, completion: nil)
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //UIImagePickerControllerのデリゲートメソッドを使用する設定
        pickerController.delegate = self
    }
    //アクションシート表示メソッド
    @IBAction func cameraTapped(){
        // UIActionSheet生成
        let actionSheet:UIAlertController = UIAlertController(title:"写真を取得",
                                                              message: "写真の取得先を選択してください",
                                                              preferredStyle: UIAlertController.Style.actionSheet)
        // Cancelボタン
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                                                       style: UIAlertAction.Style.cancel,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in
                                                        print("Cancel")
        })
        // Cameraボタン
        let cameraAction:UIAlertAction = UIAlertAction(title: "Camera",
                                                       style: UIAlertAction.Style.default,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in
                                                        print("Camera")
                                                        //1番目のボタンを押したらソースタイプをカメラに設定
                                                        self.pickerController.sourceType = UIImagePickerController.SourceType.camera
                                                        //UIImagePickerControllerを表示
                                                        self.present(self.pickerController, animated: true, completion: nil)
        })
        // Libraryボタン
        let libraryAction:UIAlertAction = UIAlertAction(title: "Library",
                                                        style: UIAlertAction.Style.default,
                                                        handler:{
                                                            (action:UIAlertAction!) -> Void in
                                                            print("Library")
                                                            //2番目のボタンを押したらソースタイプをフォトライブラリに設定
                                                            self.pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                                                            //UIImagePickerControllerを表示
                                                            self.present(self.pickerController, animated: true, completion: nil)
        })
        // AlertViewControllerにボタンを追加
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        // 画面表示
        present(actionSheet, animated: true, completion: nil)
    }
    //スタンプ選択画面遷移メソッド
    @IBAction func stampTapped(){
        //SegueのIdentifierを設定
        self.performSegue(withIdentifier: "ToStampList", sender: self)
    }
    //スタンプ選択画面を閉じるメソッド
    
    //画面表示の直前に呼ばれるメソッド
    override func viewWillAppear(_ animated: Bool) {
        //viewWillAppearを上書きするときに必要な処理
        super.viewWillAppear(animated)
        //新規スタンプ画像フラグがtrueの場合、実行する処理
        if appDelegate.isNewStampAdded == true{
            //stampArrayの最後に入っている要素を取得
            let stamp = appDelegate.stampArray.last!
            //スタンプのフレームを設定
            stamp.frame = CGRectMake(0, 0, 100, 100)
            //スタンプの設置座標を写真画像の中心に設定
            stamp.center = mainImageView.center
            //スタンプのタッチ操作を許可
            stamp.isUserInteractionEnabled = true
            //スタンプを自分で配置したViewに設置
            canvasView.addSubview(stamp)
            //新規スタンプ画像フラグをfalseに設定
            appDelegate.isNewStampAdded = false
        }
    }
    //CGRectMake関数
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    //スタンプ画像の削除
    @IBAction func deleteTapped(){
        //canvasViewのサブビューの数が1より大きかったら実行
        if canvasView.subviews.count > 1{
            //canvasViewの子ビューの最後のものを取り出す
            let lastStamp = canvasView.subviews.last! as! Stamp
            //canvasViewからlastStampを削除する
            lastStamp.removeFromSuperview()
            //lastStampが格納されているstampArrayのインデックス番号を取得
            if let index = appDelegate.stampArray.firstIndex(of: lastStamp){
                //stampArrayからlastStampを削除
                appDelegate.stampArray.remove(at: index)
            }
        }
    }
    @IBAction func saveTapped(){
        //画像コンテキストをサイズ、透過の有無、スケールを指定して作成
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, canvasView.isOpaque, 0.0)
        //canvasViewのレイヤーをレンダリング
        canvasView.layer.render(in: UIGraphicsGetCurrentContext()!)
        //レンダリングした画像を取得
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //画像コンテキストを破棄
        UIGraphicsEndImageContext()
        //取得した画像をフォトライブラリへ保存
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        
        var title = "保存完了"
        var message = "カメラロールに保存しました"
        
        if error != nil {
            title = "エラー"
            message = "保存に失敗しました"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // OKボタンを追加
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // UIAlertController を表示
        self.present(alert, animated: true, completion: nil)
    }

}

