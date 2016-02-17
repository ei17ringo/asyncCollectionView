//
//  ViewController.swift
//  sampleCollectionView
//
//  Created by Eriko Ichinohe on 2016/02/11.
//  Copyright © 2016年 Eriko Ichinohe. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate  {

    let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

    var musicList:[NSDictionary] = []

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.hidden = true
        
        dispatch_async(queue) {() -> Void in
            // 別スレッドでの処理
            //itunesのAPIからmaroon5の情報を20件取得
            var url = NSURL(string: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?term=maroon5&limit=20")
            var request = NSURLRequest(URL:url!)
            var jsondata = (try! NSURLConnection.sendSynchronousRequest(request, returningResponse: nil))
            let jsonDictionary = (try! NSJSONSerialization.JSONObjectWithData(jsondata, options: [])) as! NSDictionary
            
            //APIから取得してきたデータの中で使用するものだけを、newMusicに保存
            
            for(key, data) in jsonDictionary{
                //print("\(key)=\(data)")
                if (key as! String == "results"){
                    var resultArray = data as! NSArray
                    for (eachMusic) in resultArray{
                        
                        print(eachMusic["artworkUrl100"])
                        print(eachMusic["trackName"])
                        var newMusic:NSDictionary = ["name":eachMusic["trackName"] as! String,"image":eachMusic["artworkUrl100"] as! String]
                        
                        //配列のプロパティに追加
                        self.musicList.append(newMusic)
                        
                    }
                    
                }
            }
            
            self.myCollectionView.reloadData()
            self.myCollectionView.hidden = false
        }


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UICollectionViewDelegate Protocol
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:CustomCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CustomCell
//        cell.title.text = "タイトル";
//        cell.image.image = UIImage(named: "berry.png")
        
        // URLを元に画像データを取得
        let url = NSURL(string: musicList[indexPath.row]["image"] as! String);
        var err: NSError?;
        let imageData :NSData = (try! NSData(contentsOfURL:url!,options: NSDataReadingOptions.DataReadingMappedIfSafe));
        var img = UIImage(data:imageData);
        
        cell.title.text = musicList[indexPath.row]["name"] as! String;
        cell.image.image = img
        cell.backgroundColor = UIColor.blackColor()
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicList.count;
    }

}

