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

struct ResponseObject: Codable {
    let data: [CustomData]
}


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

struct CustomData: Codable, SocketData {
    let name: String
    let image: String
    
    func socketRepresentation() -> SocketData {
        return ["name": name, "image": image]
    }
    
    
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case image = "image"
    }
}

//socket.emit("myEvent", CustomData(name: "Erik", age: 24))


class ChatViewController: BaseViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var labelStatusConnection: UILabel!
    @IBOutlet weak var labelWriting: UILabel!
    @IBOutlet weak var buttonSend: UIButton!
    
    @IBOutlet weak var image: UIImageView!
    
    
    var responses = [String]()
    var questions = [String]()
    var printable = [Response].init()
    var user: String?
    var profile: UIImage?
    
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
        
//        let userImage:UIImage = profile!
//        let imageData:NSData = UIImagePNGRepresentation(userImage)! as NSData
//        let dataImage = imageData.base64EncodedString(options: .lineLength64Characters)
//        print(dataImage)
        
        let customData = CustomData(name: user!, image: ConvertImageToBase64String(img: profile!))
        
        sharedSocket.socketIsLogged(withUser: customData)
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
            
            for i in data {
                if let resp = i as? [String: Any] {
//                    print(resp["name"] as! String)
                    self.printable.append(Response(message: "\(resp["name"] as! String) acabou de entrar.", side: 0))
                    self.image.image = self.ConvertBase64StringToImage(imageBase64String: resp["image"] as! String)
                }
            }
//            self.recoveryData(data: data)
//            if let response = data[0] as? SocketData {
//                self.recoveryData(data: response)
////                if let resp: [String: AnyObject] = try response.socketRepresentation() as! [String : AnyObject] {
//
////                }
//            }
            
//            if let response = data[0].map
////            self.convertData(data: data)
//            if let typeDict = data[0] as? AnyObject {
////                if let dic =  {
////                    print("boom")
////                }
//                for i in typeDict {
//
//                }
//                print("deu merda )")
//            }
            
            //print("Test: retorno me mensagem \n\n \(data[0]) \n\n")
//            if let response = data[0]["image"] as? String {
//                print("chegou no response")
//            }
            
//            let imageData = dataImage
//            let dataDecode:NSData = NSData(base64Encoded: data[1] as! String, options:.ignoreUnknownCharacters)!
//            let avatarImage:UIImage = UIImage(data: dataDecode as Data)!
//            self.image.image = avatarImage
//            if let image: UIImage = self.ConvertBase64StringToImage(imageBase64String: data[1] as! String) {
//                self.image.image = image
//            }
            
            self.tableView.reloadData()
            
        }
        
        sharedSocket.socket.on("logout") {data, ack in
            print("Test: retorno me mensagem \n\n \(data[0]) \n\n")
            self.printable.append(Response(message: "\(data[0])", side: 2))
            self.tableView.reloadData()
            
        }
    }
    
//    internal func recoveryData(data: [Any]) {
    
       
//        print("\()")
//        if let response: [String: Any] = data[0] as? [String: Any] {
//            do {
//                let da = try response.socketRepresentation()
//                print("boom 4")
//            } catch {
//
//            }
//        }
        
//        do {
//            if let response: [String: Any] = try data.socketRepresentation() as? [String : Any] {
//                print("boom 2 \(response["name"] as! String)")
//            }
//        } catch {
//            print(error)
//        }
        
//    }
    
//    internal func convertData(data: Any) {
//        let decoder = JSONDecoder()
////        decoder.dateDecodingStrategy = .formatted(formatter)
//        do {
//            let responseObject = try decoder.decode(ResponseObject.self, from: data )
////            print(responseObject.data)
//            print("chegou aqui")
//        } catch {
//            print(error)
//        }
//    }
    
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
    
    func ConvertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = UIImageJPEGRepresentation(img, 0.01)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
    func ConvertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return (image ?? nil)!
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
extension Dictionary {
    public init(keyValuePairs: [(Key, Value)]) {
        self.init()
        for pair in keyValuePairs {
            self[pair.0] = pair.1
        }
    }
}
