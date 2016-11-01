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
        self.collectionView.register(nib, forCellWithReuseIdentifier: "PhotoCell")
        
        loadPhoto()
    }
    
    @IBAction func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoObjectArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.configure(photoObjectArray[(indexPath as NSIndexPath).row].image!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        popupView =  UINib(nibName: "PopUpPhotoView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PopUpPhotoView
        popupView.delegate = self
        popupView.configure(photoObjectArray[(indexPath as NSIndexPath).row])
        presentPopupView(popupView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.width / 3 - 2
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }

}

extension AlbumViewController {
    fileprivate func loadPhoto() {
        guard let realm = try? Realm() else { return }
        photoObjectArray = realm.objects(PhotoObject.self).sorted(byProperty: "timeStamp").reversed()
    }
}

extension AlbumViewController: PopUpPhotoViewDelegate {
    func didTapActionButton(_ object: PhotoObject) {
        self.present(ShareActivityController.create(object), animated: true, completion: nil)
    }
}
