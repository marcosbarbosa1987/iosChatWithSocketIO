//
//  SocketIOManager.swift
//  BarbosaMAChat
//
//  Created by Marcos Barbosa on 29/09/18.
//  Copyright © 2018 Marcos Barbosa. All rights reserved.
//

import UIKit
import Socket

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    var chatSocket: Socket!
    
//    var socket: SocketIOClient!
//    let manager = SocketManager(socketURL: URL(string: "10.54.162.195:9800")!, config: [.log(true), .compress])
    
    override init() {
        super.init()
        
    }
    
    public func runClient(_ server: String, port: String) -> Bool{
        
        
        do {
//            let chatSocket = try Socket.create(family: .inet6)
            self.chatSocket = try Socket.create(family: Socket.ProtocolFamily.inet)
            
            try chatSocket.connect(to: server, port: Int32(port)!)
            try chatSocket.listen(on: Int(port)!)
//            try chatSocket.connect(to: "10.54.172.79", port: 8801)
//            try chatSocket.connect(to: "10.54.170.141", port: 8800)
            
            if try readFromServer(chatSocket) == "Conectado" {
                return true
            }else{
                return false
            }
            sleep(1)  // Be nice to the server
        }
        catch {
            guard let socketError = error as? Socket.Error else {
                print("Unexpected error ...")
                return false
            }
            print("Error reported:\n \(socketError.description)")
            return false
        }
    }
    
    public func listenSocket() {
        do {
            try self.chatSocket.listen(on: 1)
            print("escutando")
        } catch {
            print(error)
        }
    }
    
    public func offLine() -> Bool {
        do {
            try chatSocket.close()
            return true
        } catch {
            return false
        }
    }
    
    func online(_ chatSocket: Socket) -> Bool {
        do{
            try chatSocket.write(from: "\(UIDevice.current.identifierForVendor!.uuidString)")
            return true
        } catch {
            return false
        }
    }
    
    
//    func readFromServer() throws -> String{
//        var readData = Data(capacity: self.chatSocket.readBufferSize)
//        let bytesRead = try self.chatSocket.read(into: &readData)
//        guard bytesRead > 0 else {
//            print("Zero bytes read.")
//            return ""
//        }
//
//
//        guard let response = String(data: readData, encoding: .utf8) else {
//            print("Error decoding response ...")
//            return ""
//        }
//
//        print("printando a resposta1: \(response)")
//        return response
//    }
    
    func checkMessage() -> String {
        
        do {
            let response = try self.readFromServer(chatSocket)
          
            return response
        } catch {
           print(error.localizedDescription)
            return ""
        }
        
    }
  
    
    func readFromServer(_ chatSocket : Socket) throws -> String{
        var readData = Data(capacity: chatSocket.readBufferSize)
        
        
        let bytesRead = try chatSocket.read(into: &readData)
        guard bytesRead > 0 else {
            print("Zero bytes read.")
            return ""
        }


        guard let response = String(data: readData, encoding: .utf8) else {
            print("Error decoding response ...")
            return ""
        }

        print("printando a resposta1: \(response)")
        return response
    }
    
//    func checkMessages() -> String{
//        var readData = Data(capacity: self.chatSocket.readBufferSize)
//        let bytesRead = try self.chatSocket.read(into: &readData)
//        guard bytesRead > 0 else {
//            print("Zero bytes read.")
//            return ""
//        }
//
//
//        guard let response = String(data: readData, encoding: .utf8) else {
//            print("Error decoding response ...")
//            return ""
//        }
//
//        print("printando a resposta1: \(response)")
//        return response
//    }
    
    
    func sendToServer(message: String) -> [String]{
        do {
            try self.chatSocket.write(from: message)
            var validator = false
            var responses = [String]()
//            print("printando a resposta2 = \(try readFromServer(chatSocket))")
            repeat{
                let response = try readFromServer(chatSocket)
                if response == "" {
                    validator = true
                    
                } else {
                    responses.append(response)
                }
                
            }while validator == true
            
//            self.chatSocket.close()
           return responses
        } catch {
            print("\(error.localizedDescription)")
            return [String]()
        }

    }
    
}
