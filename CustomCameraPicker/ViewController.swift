//
//  ViewController.swift
//  CustomCameraPicker
//
//  Created by Usha Natarajan on 7/17/18.
//  Copyright © 2018 Usha Natarajan. All rights reserved.
//


// Prerequistes - set Privacy Photo Library usage description,
// Camera Usage Description
// and Media Library Usage Description

import UIKit
import Photos
import AVFoundation

class ViewController: UIViewController,ImageProtocol {
    
    func setImage(image: UIImage) {
        self.profileImage = image
    }
    

    @IBOutlet weak var profileImageView: UIImageView!
    
    var profileImage:UIImage?
    
    struct storyBoard{
        static let pickerViewController = "PickerViewController"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let image = profileImage{
            DispatchQueue.main.async{
                self.profileImageView.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoLibraryPermission()
        
    }

    @IBAction func didTapProfile(_ sender: Any) {
         let pickerViewController = self.storyboard?.instantiateViewController(withIdentifier: storyBoard.pickerViewController) as! PickerViewController
        pickerViewController.delegate = self
        self.navigationController?.pushViewController(pickerViewController, animated: true)
    }
    
    //MARK: Helper Methods
    
    func photoLibraryPermission(){
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .denied, .restricted:
            print("access denied")
            return
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status != .authorized{
                    print("access denied")
                }
            })
        case .authorized:
            return
        }
    }//end of photoLibraryPermission*/
}
