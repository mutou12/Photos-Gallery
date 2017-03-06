//
//  ViewController.swift
//  Photos Gallery
//
//  Created by hekai on 17/3/5.
//  Copyright © 2017年 hekai. All rights reserved.
//

import UIKit
import Photos

let albumName = "Photos Gallery"

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var albumFound: Bool = false
    
    var assetCollection: PHAssetCollection!
    
    var photoAsset: PHFetchResult<PHAsset>!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func cameraClick(_ sender: UIBarButtonItem) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            var picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
            
        }else {
            let alert = UIAlertController(title: "错误", message: "没有可用的摄像头", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (alertAction) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func photoAlumClick(_ sender: UIBarButtonItem) {
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = false
        self.photoAsset = PHAsset.fetchAssets(in: self.assetCollection, options: nil)

        self.collectionView.reloadData()
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        
        let collection = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: .any, options: fetchOptions)
        if collection.firstObject != nil {
           self.albumFound = true
           self.assetCollection = collection.firstObject
        }else
        {
            print("照片集:\(albumName) 不存在，现在创建")
            
            PHPhotoLibrary.shared().performChanges({ 
                _ = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            }, completionHandler: { (success: Bool, error: Error?) in
                if error != nil {
                   print("照片创建失败")
                }else {
                   print("照片集创建成功")
                }
                
                self.albumFound = success
                
            })
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count = 0
        if self.photoAsset != nil
        {
            return self.photoAsset.count
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    
        let resuseIdentifier = "PhotoCell"
        let cell: PhotoThumbnail = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifier, for: indexPath) as! PhotoThumbnail
        
        let asset: PHAsset = self.photoAsset[indexPath.item] as PHAsset
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) { (result, info) in
            cell.setThumbnailImage(thumbnailImage: result!)
        }
        
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewLargePhoto" {
            let controller = segue.destination as! PhotoViewController
            
            let indexPath: IndexPath = self.collectionView.indexPath(for: sender as! UICollectionViewCell)!
            controller.index = indexPath.item
            controller.photoAsset = self.photoAsset
            controller.assetCollection = self.assetCollection
            
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
    
        PHPhotoLibrary.shared().performChanges({ 
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection, assets: self.photoAsset)
            
            
            albumChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)
            
        }){ (success, error) in
            NSLog("添加照片到照片集->%@", (success ? "成功" : "失败"))
            DispatchQueue.main.async {
                picker.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

