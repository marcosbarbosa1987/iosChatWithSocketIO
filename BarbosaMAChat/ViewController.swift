//
//  ViewController.swift
//  BarbosaMAChat
//
//  Created by Marcos Barbosa on 28/09/18.
//  Copyright © 2018 Marcos Barbosa. All rights reserved.
//

import Foundation
import UIKit
import SocketSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    var client: Socket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Conectando..."
        
        do {
            self.client = try Socket(.inet, type: .stream, protocol: .tcp)
            print("configurado")
            do {
                try self.client.connect(port: 8800, address: "10.54.162.195")
                print("connectou")
                self.label.text = "Conectado"
                do {
                    print(try client.read())
                    //                    client.read()
                    //                    print(try client.accept())
                    //                    var message = try client.read(UnsafeMutableRawPointer.init(bitPattern: try client.read()), size: try client.read())
                    
                    //                    var message = [Byte]()
                    //                    while try self.client.read(). {
                    //
                    //                    }
                    var message = try self.client.read()
                    //                    var message = [Byte]()
                    //
                    //                    for i in 0...100 {
                    //                        //print(try self.client.read())
                    //                        message.append(try self.client.read())
                    //                    }
                    //
                    //                    for i in message.ele{
                    let string = NSString(bytes: &message, length: 100, encoding: String.Encoding.utf8.rawValue)
                    print(string)
                    //                    }
                    
                    
                    
                }catch {
                    print("erro listen")
                }
            }catch{
                print("erro no address")
            }
            
        }catch{
            print("nao configurado")
        }
        
    }
    
    
    @IBAction func buttonSendTapped(_ sender: Any) {
        
        self.label.text = "Enviando..."
        let helloBytes = ([UInt8])("\(textField.text!)" .utf8)
        do {
            
            try client.write(helloBytes)
            self.label.text = "\(try client.read())"
            
            var response = [UInt8]()
            
            var boolean = true
            var l = 0
            while boolean {
                try self.client.connect(port: 8800, address: "10.54.162.195")
                do {
                    //print(try client.read())
                    response.append(try client.read())
                }catch{
                    boolean = false
                    try client.close()
                }
                print("L: \(l)")
                l = l + 1
            }
            
//            for _ in 0...255 {
//
//                do{
//
//                    if let digit = try client.read() as? UInt8{
//                        response.append(digit)
//                        print("chegou aqui")
//                    }
//                }catch{
//
//                    print("Erro na bagaça \(error)")
//
//                }
//            }
            print("PARE!!!!\(response.count)")
            
            if response.count > 0 {
                print("tem dados \(response.count)")
                
//                for i in response.count {
//                    if let string = String(bytes: i, encoding: .utf8) {
//                        print(string)
//                    } else {
//                        print("not a valid UTF-8 sequence")
//                    }
//                }
                
            }else{
                print("nao tem dados")
            }
            
            
        }catch{
            print("error")
        }
        
    }
    
    
    
    
}

//extension String {
//
//    func decryptAES(key: String, iv: String) -> String {
//        do {
//            let encrypted = self
//            let key = Array(key.utf8)
//            let iv = Array(iv.utf8)
//            let aes = try AES(key: key, blockMode: CTR(iv: iv), padding: .noPadding)
//            let decrypted = try aes.decrypt(Array(hex: encrypted))
//            return String(data: Data(decrypted), encoding: .utf8) ?? ""
//        } catch {
//            return "Error: \(error)"
//        }
//    }
//}
