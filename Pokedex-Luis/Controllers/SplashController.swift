//
//  SplashController.swift
//  Pokedex-Luis
//
//  Created by LUIS SUAREZ on 15/11/20.
//

import UIKit

class SplashController: UIViewController {

    let db = DBHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let _ = db.openDatabase()
        db.createTable()
        
        
        Process().delay(bySeconds: 0.5) {
            Process().getInicio()
        }
        Process().delay(bySeconds: 1) {
            self.loadData()
        }
        
    }
    
    func loadData(){

        let read = db.read()
        print(read.count)
        
        if read.count > 0 {
            
            Instanciar()
            
        } else {
        
            var data = NSDictionary()

            let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
            let attributedString = NSAttributedString(string: "Descargando\n Recursos...", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                NSAttributedString.Key.foregroundColor : UIColor.darkGray
            ])
            alert.setValue(attributedString, forKey: "attributedMessage")
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating()
            loadingIndicator.color = .darkGray
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            
            Process().delay(bySeconds: 1) { [self] in
                
                data = Global.global.response
            
                if let result = data["results"] as? NSArray {
                
                    for x in 0..<result.count {
                        let pokeid = "\(x+1)"
                        
                        let dic = result[Int(x)] as! NSDictionary
                        let name = String(describing: dic["name"]!)
                        let url = String(describing: dic["url"]!)
                        //let img = getImage(urlString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(x+1).png")
                        let urlImg = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(x+1).png")!
                        let imageData:NSData = NSData.init(contentsOf: urlImg)!
                        var strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                        strBase64 = strBase64.filter { !$0.isNewline && !$0.isWhitespace }
                        print(url)
                        db.insert(id: pokeid, name: name, image: strBase64, url: url)

                    }
                }
                
                self.dismiss(animated: false, completion: nil)
                Instanciar()
            }
        }
    }
    
    func Instanciar() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"navi")
        self.present(viewController, animated: true)
        
    }

}
