//
//  Process.swift
//  Pokedex-Luis
//
//  Created by LUIS SUAREZ on 14/11/20.
//

import Foundation
class Process {
    
    func getInicio() {
        
        let postEndpoint: String = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=50"
        let url = URL(string: postEndpoint)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let _ = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                return
            }
            
            do {
                
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                Global.global.response = object
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    func getDetallePokemon(url: String) {
        
        let postEndpoint: String = url
        let url = URL(string: postEndpoint)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let _ = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                return
            }
            
            do {
                
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                Global.global.detaPokemon = object
                //print(object)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }

   
    
    func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:             return DispatchQueue.main
            case .userInteractive:  return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
            case .userInitiated:    return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
            case .utility:          return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
            case .background:       return DispatchQueue.global(qos: DispatchQoS.QoSClass.background) }
        }
    }
}
