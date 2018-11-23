//
//  HomeViewController.swift
//  BarbosaMAChat
//
//  Created by Marcos Barbosa on 10/11/18.
//  Copyright © 2018 Marcos Barbosa. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldHost: UITextField!
    @IBOutlet weak var textFieldPort: UITextField!
    @IBOutlet weak var buttonConnect: UIButton!
    
    var sharedSocket = SocketManagerIO.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.buttonConnect.layer.cornerRadius = 8
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
            }
        }
    }

}
