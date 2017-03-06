//
//  PhotoViewController.swift
//  Photos Gallery
//
//  Created by hekai on 17/3/5.
//  Copyright © 2017年 hekai. All rights reserved.
//

import UIKit
import Photos
class PhotoViewController: UIViewController {

    var assetCollection: PHAssetCollection!
    var photoAsset: PHFetchResult<PHAsset>!
    
    var index: Int = 0
    
    
    @IBOutlet weak var imageview: UIImageView!
    @IBAction func actionClick(_ sender: UIBarButtonItem) {
        
    
    }
    @IBAction func trashClick(_ sender: UIBarButtonItem) {
     let alert = UIAlertController(title: "删除照片", message: "你确定要删除么么么么？？？？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "是的呢", style: .default, handler: { (alertAction) in
            //aaa
            PHPhotoLibrary.shared().performChanges({ 
                let request = PHAssetCollectionChangeRequest(for: self.assetCollection)
                request?.removeAssets([self.photoAsset[self.index]] as NSFastEnumeration)
            }, completionHandler: { (success, error) in
                if success
                {
                    print("成功")
                }
                else
                {
                    print("失败")
                }
                
                alert.dismiss(animated: true, completion:nil)
                
                self.photoAsset = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
                
                if self.photoAsset.count == 0 {
                   self.imageview.image = nil
                    print("没有照片了")
                }
                if self.index >= self.photoAsset.count {
                   self.index = self.photoAsset.count - 1
                }
                
                self.displayPhoto()
                
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "否", style: .cancel, handler: { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = true
        self.displayPhoto()
    }

    func displayPhoto() {
        let imageManager = PHImageManager.default()
        var ID = imageManager.requestImage(for: self.photoAsset[self.index], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) { (result, info) in
            self.imageview.image = result
        }
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
