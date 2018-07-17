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
    }

    @IBAction func didTapProfile(_ sender: Any) {
         let pickerViewController = self.storyboard?.instantiateViewController(withIdentifier: storyBoard.pickerViewController) as! PickerViewController
        pickerViewController.delegate = self
        self.navigationController?.pushViewController(pickerViewController, animated: true)
    }
}
