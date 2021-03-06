//
//  ViewController.swift
//  BarbosaMAChat
//
//  Created by Marcos Barbosa on 28/09/18.
//  Copyright © 2018 Marcos Barbosa. All rights reserved.
//

import Foundation
import UIKit
import SocketIO

struct Response {
    var message: String
    var side: Int
    
    init(message: String, side: Int) {
        self.message = message
        self.side = side
    }
    
    init() {
        self.message = ""
        self.side = 0
    }
}


class ChatViewController: BaseViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var labelStatusConnection: UILabel!
    @IBOutlet weak var labelWriting: UILabel!
    @IBOutlet weak var buttonSend: UIButton!
    
    
    
    var responses = [String]()
    var questions = [String]()
    var printable = [Response].init()
    var user: String?
    
    var booleanConect = true
    var sharedSocket = SocketManagerIO.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSend.layer.cornerRadius = 8
        labelStatusConnection.text = "\(sharedSocket.socket.status)"
        labelWriting.text = ""
        listenSocket()

        tableView.dataSource = self
        tableView.delegate = self
        textField.delegate = self
        
        sharedSocket.socketIsLogged(withUser: user!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sharedSocket.socketIsNotLogged(withUser: user!)
        sharedSocket.socketDesconect()
        
    }
    
    
    func listenSocket() {
        
        sharedSocket.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.labelStatusConnection.text = "Online"
            self.labelStatusConnection.textColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            self.booleanConect = true
        }
        
        sharedSocket.socket.on(clientEvent: .disconnect) {data, ack in
            print("socket connected")
            self.labelStatusConnection.text = "Offline"
            self.labelStatusConnection.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            self.booleanConect = true
        }
        
        sharedSocket.socket.on("resposta") {data, ack in
            print("Test: retorno me mensagem \n\n \(data[0]) \n\n")
            self.printable.append(Response(message: "\(data[0])", side: -1))
            self.tableView.reloadData()
        }
        
        sharedSocket.socket.on("isWriting") {data, ack in
            print("Test: retorno me mensagem2 \n\n \(data[0]) \n\n")
            self.labelWriting.text = "\(data[0])"
            self.view.layoutIfNeeded()
            
        }
        
        sharedSocket.socket.on("logged") {data, ack in
            print("Test: retorno me mensagem \n\n \(data[0]) \n\n")
            self.printable.append(Response(message: "\(data[0])", side: 0))
            self.tableView.reloadData()
            
        }
        
        sharedSocket.socket.on("logout") {data, ack in
            print("Test: retorno me mensagem \n\n \(data[0]) \n\n")
            self.printable.append(Response(message: "\(data[0])", side: 2))
            self.tableView.reloadData()
            
        }
    }
    
    
    @IBAction func buttonSendTapped(_ sender: Any) {
        
        
        if let message: String = textField.text, !((textField.text?.isEmpty)!) {
            self.printable.append(Response(message: message, side: 1))
            tableView.reloadData()
            
            self.textField.text = ""

            if booleanConect {
                sharedSocket.socketSendMessage(withMessage: message)
            } else {
                let alert = UIAlertController(title: "Aviso", message: "Você precisar estar online para poder enviar essa mensagem!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return printable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if printable[indexPath.row].side == -1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "leftCell", for: indexPath) as! ChatTableViewCell
            cell.configureLeftCell(array: printable, indexPath: indexPath)
            return cell
        } else if printable[indexPath.row].side == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rightCell", for: indexPath) as! ChatTableViewCell
            cell.configureRightCell(array: printable, indexPath: indexPath)
            return cell
        } else if printable[indexPath.row].side == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "centerCell", for: indexPath) as! ChatTableViewCell
            cell.configureCenterLoggedCell(array: printable, indexPath: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "centerCell", for: indexPath) as! ChatTableViewCell
            cell.configureCenterLogoutCell(array: printable, indexPath: indexPath)
            return cell
        }
        
    }
    
}

extension ChatViewController: UITextFieldDelegate {
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if (textField.text?.isEmpty)! {
//            sharedSocket.socketIsWriting(withUser: "", isWriting: false)
//        } else {
//            if let user: String = user {
//                sharedSocket.socketIsWriting(withUser: user, isWriting: true)
//            }
//            sharedSocket.socketIsWriting(withUser: "", isWriting: false)
//
//        }
//        return true
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        sharedSocket.socketIsWriting(withUser: user!, isWriting: true)
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            sharedSocket.socketIsWriting(withUser: "", isWriting: false)
        } else {
            sharedSocket.socketIsWriting(withUser: user!, isWriting: true)
        }
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
