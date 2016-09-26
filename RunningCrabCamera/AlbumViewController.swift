//
//  AlbumViewController.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/22.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit
import STZPopupView
import RealmSwift

class AlbumViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var popupView: PopUpPhotoView!
    var photoObjectArray: [PhotoObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "PhotoCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "PhotoCell")
        
        loadPhoto()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoObjectArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        cell.configure(photoObjectArray[indexPath.row].image!)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        popupView =  UINib(nibName: "PopUpPhotoView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! PopUpPhotoView
        popupView.delegate = self
        popupView.configure(photoObjectArray[indexPath.row])
        presentPopupView(popupView)
    }

}

extension AlbumViewController {
    private func loadPhoto() {
        guard let realm = try? Realm() else { return }
        photoObjectArray = realm.objects(PhotoObject).sorted("timeStamp").reverse()
    }
}

extension AlbumViewController: PopUpPhotoViewDelegate {
    func didTapActionButton(object: PhotoObject) {
        self.presentViewController(ShareActivityController.create(object), animated: true, completion: nil)
    }
}