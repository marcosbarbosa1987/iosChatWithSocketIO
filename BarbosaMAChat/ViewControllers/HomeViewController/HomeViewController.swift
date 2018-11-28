//
//  HomeViewController.swift
//  BarbosaMAChat
//
//  Created by Marcos Barbosa on 10/11/18.
//  Copyright © 2018 Marcos Barbosa. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldHost: UITextField!
    @IBOutlet weak var textFieldPort: UITextField!
    @IBOutlet weak var buttonConnect: UIButton!
    
    var sharedSocket = SocketManagerIO.shared
    var imagePicker = UIImagePickerController()
    var image = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        // Do any additional setup after loading the view.
        self.buttonConnect.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func connectButtonClicked(_ sender: Any) {
        if (textFieldHost.text?.isEmpty)! || (textFieldPort.text?.isEmpty)! || (textFieldUserName.text?.isEmpty)!{
            print("campos vazios")
        } else {
            
            sharedSocket.socketConnect(withIP: textFieldHost.text!, port: textFieldPort.text!)
            self.listenSocket()
            
        }
    }
    
    
    
    
     func listenSocket() {
        sharedSocket.socket.on(clientEvent: .connect) {data, ack in
           self.performSegue(withIdentifier: SEGUES.goChat.rawValue, sender: self.textFieldUserName.text!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUES.goChat.rawValue {
            if let value = sender as? String {
                let destination = segue.destination as! ChatViewController
                destination.user = value
                destination.profile = image
            }
        }
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        
//        self.btnEdit.setTitleColor(UIColor.white, for: .normal)
//        self.btnEdit.isUserInteractionEnabled = true
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as! UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
            image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

}
