//
//  ViewController.swift
//  CustomCameraPicker
//
//  Created by Usha Natarajan on 7/17/18.
//  Copyright © 2018 Usha Natarajan. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

protocol ImageProtocol {
    func setImage(image: UIImage)
}

class PickerViewController: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var photosArray:[UIImage] = [UIImage(named:"cameraInset")!]
    var delegate:ImageProtocol?
    
    struct storyBoard{
        static let imageCell = "imageCell"
        static let numberOfImagesPerRow:CGFloat = 3
    }
    
    override func viewDidLoad() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        //self.photoLibraryPermission(completion:getPhotos)
        getPhotos()
    }
    
    func getPhotos(){
        
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .fastFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResults: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResults.count > 0{
            for i in 0 ..< fetchResults.count{
                imageManager.requestImage(for: fetchResults.object(at: i) , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { image , error  in
                        if let image = image{
                            self.photosArray.append(image)
                        }
                    }
                }
            }else{
                print("Nothing to fetch")
                self.photoCollectionView.reloadData()
            }
    }//end of getPhotos
    
    //MARK: ImagePicker delegate and helper methods
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = true
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            delegate?.setImage(image: image)
        }else{
            print("Something went wrong")
        }
        self.dismiss(animated: true) {
             self.navigationController?.popViewController(animated: true)
        }
    }

    
    //MARK: Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: storyBoard.imageCell, for: indexPath) as! UserImagesCollectionViewCell
        
        imageCell.userImage.image = photosArray[indexPath.item]
        return imageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item{
        case 0://camera selected
            self.camera()
        default: //image picked
            if let indexPath = collectionView.indexPathsForSelectedItems?.first{
                let imageCell = collectionView.cellForItem(at: indexPath) as! UserImagesCollectionViewCell
                delegate?.setImage(image: imageCell.userImage!.image!)
                self.self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK: UICollectionViewFlowDelegate methods
    
    func collectionView(_ collectinView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / storyBoard.numberOfImagesPerRow) - 1
        
        return CGSize(width: width, height: width)
    }
}//end of PhotosCollectionViewController
