//
//  PokemonDetailController.swift
//  Pokedex-Luis
//
//  Created by LUIS SUAREZ on 16/11/20.
//

import UIKit

class PokemonDetailController: UIViewController {
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var imgPokemon: UIImageView!
    @IBOutlet weak var lblPokemon: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var type1: UIImageView!
    @IBOutlet weak var type2: UIImageView!
    @IBOutlet weak var type3: UIImageView!
    @IBOutlet weak var btnCancelar: UIButton!
    
    @IBOutlet weak var hp: UILabel!
    @IBOutlet weak var atk: UILabel!
    @IBOutlet weak var def: UILabel!
    @IBOutlet weak var satk: UILabel!
    @IBOutlet weak var sdef: UILabel!
    @IBOutlet weak var spd: UILabel!
    
    @IBOutlet weak var lblhp: UILabel!
    @IBOutlet weak var lblatk: UILabel!
    @IBOutlet weak var lbldef: UILabel!
    @IBOutlet weak var lblsatk: UILabel!
    @IBOutlet weak var lblsdef: UILabel!
    @IBOutlet weak var lblspd: UILabel!
    
    @IBOutlet weak var progressHp: UIProgressView!
    @IBOutlet weak var progressAtk: UIProgressView!
    @IBOutlet weak var progressDef: UIProgressView!
    @IBOutlet weak var progressSatk: UIProgressView!
    @IBOutlet weak var progressSdef: UIProgressView!
    @IBOutlet weak var progressSpd: UIProgressView!
    
    var desc:String = ""
    let db = DBHelper()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        type1.isHidden = true
        type2.isHidden = true
        type3.isHidden = true
        lblPokemon.isHidden = true
        lblDesc.isHidden = true

        setupViews()
        let _ = db.openDatabase()
        Process().delay(bySeconds: 0.5) {
            self.loadData()
        }
    }
    
    func setupViews(){
        imgView.layer.cornerRadius = 40
    }

    func loadData() {
        
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        let attributedString = NSAttributedString(string: "Please wait...", attributes: [
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
        
        var url = "https://pokeapi.co/api/v2/pokemon-species/\(Global.global.pokemonId)"
        
        Process().delay(bySeconds: 0.5) {
            Process().getDetallePokemon(url: "\(String(describing: url))")
        }

        Process().delay(bySeconds: 1.5) { [self] in
            
            if let result = Global.global.detaPokemon["flavor_text_entries"] as? NSArray {
                
                for x in 0..<result.count {
                    //
                    let data = result[x] as! NSDictionary
                    let lang = data["language"] as! NSDictionary
                    let nameLang = String(describing: lang["name"])
                    let version = data["version"] as! NSDictionary
                    let nameVer = String(describing: version["name"])
                    
                    if nameLang.contains("es") && nameVer.contains("omega-ruby"){
                        desc =  String(describing: data["flavor_text"]!)
                        lblDesc.text = desc
                        lblDesc.isHidden = false
                    }
                }

            }
            
            url = "https://pokeapi.co/api/v2/pokemon/\(Global.global.pokemonId)/"
            
            Process().getDetallePokemon(url: "\(String(describing: url))")
            
            
            let pokemon = db.readforId(Id: Global.global.pokemonId)
            if pokemon.count > 0 {
                let dataDecoded : Data = Data(base64Encoded: pokemon[0].image, options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                imgPokemon.image = decodedimage
                lblPokemon.text = pokemon[0].name.capitalized
                lblPokemon.isHidden = false
            }
        }
       
        
        
        Process().delay(bySeconds: 3) { [self] in
            
            if let result = Global.global.detaPokemon["types"] as? NSArray {

                if result.count > 1 {
                    type1.isHidden = false
                    type2.isHidden = false
                    let dict1 = result[0] as! NSDictionary
                    let t1 = dict1["type"] as! NSDictionary
                    let name1 = String(describing: t1["name"]!)
                    imgBack.image = UIImage(named: "\(name1).png")!
                    type1.image = UIImage(named: "lbl_\(name1).png")!
                    
                    let dict2 = result[1] as! NSDictionary
                    let t2 = dict2["type"] as! NSDictionary
                    let name2 = String(describing: t2["name"]!)
                    type2.image = UIImage(named: "lbl_\(name2).png")!
                    
                } else {
                    type3.isHidden = false
                    let dict1 = result[0] as! NSDictionary
                    let t1 = dict1["type"] as! NSDictionary
                    let name1 = String(describing: t1["name"]!)
                    imgBack.image = UIImage(named: "\(name1).png")!
                    type3.image = UIImage(named: "lbl_\(name1).png")!
                }
                
                
            }
            
            if let result = Global.global.detaPokemon["stats"] as? NSArray {
                
                for x in 0..<result.count {
                    
                    let stats = result[x] as! NSDictionary
                    let stat = stats["stat"] as! NSDictionary
                    let name = String(describing: stat["name"]!)
                    let base = String(describing: stats["base_stat"]!)
                    
                    switch name {
                    case "hp":
                        hp.text = base
                        lblhp.textColor = UIColor(patternImage: imgBack.image!)
                        progressHp.tintColor = UIColor(patternImage: imgBack.image!)
                        progressHp.progress = Float(base)!/100
                        hp.isHidden = false
                        lblhp.isHidden = false
                        progressHp.isHidden = false
                    case "attack":
                        atk.text = base
                        lblatk.textColor = UIColor(patternImage: imgBack.image!)
                        progressAtk.tintColor = UIColor(patternImage: imgBack.image!)
                        progressAtk.progress = Float(base)!/100
                        atk.isHidden = false
                        lblatk.isHidden = false
                        progressAtk.isHidden = false
                    case "defense":
                        def.text = base
                        lbldef.textColor = UIColor(patternImage: imgBack.image!)
                        progressDef.tintColor = UIColor(patternImage: imgBack.image!)
                        progressDef.progress = Float(base)!/100
                        def.isHidden = false
                        lbldef.isHidden = false
                        progressDef.isHidden = false
                    case "special-attack":
                        satk.text = base
                        lblsatk.textColor = UIColor(patternImage: imgBack.image!)
                        progressSatk.tintColor = UIColor(patternImage: imgBack.image!)
                        progressSatk.progress = Float(base)!/100
                        satk.isHidden = false
                        lblsatk.isHidden = false
                        progressSatk.isHidden = false
                    case "special-defense":
                        sdef.text = base
                        lblsdef.textColor = UIColor(patternImage: imgBack.image!)
                        progressSdef.tintColor = UIColor(patternImage: imgBack.image!)
                        progressSdef.progress = Float(base)!/100
                        sdef.isHidden = false
                        lblsdef.isHidden = false
                        progressSdef.isHidden = false
                    case "speed":
                        spd.text = base
                        lblspd.textColor = UIColor(patternImage: imgBack.image!)
                        progressSpd.tintColor = UIColor(patternImage: imgBack.image!)
                        progressSpd.progress = Float(base)!/100
                        spd.isHidden = false
                        lblspd.isHidden = false
                        progressSpd.isHidden = false
                    default:
                        print("vacio")
                    }
                    
                }
            
            }
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    @IBAction func Cancelar(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
}
