//
//  ViewController.swift
//  Pokedex-Luis
//
//  Created by LUIS SUAREZ on 14/11/20.
//

import UIKit

struct Pokedex {
    var id: String?
    var name: String?
    var imageName: UIImage?
    var url: String?
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data = NSDictionary()
    let db = DBHelper()
    var isFiltering = false
    var pokedex = [Pokedex]()
    var filteredPokedex = [Pokedex]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let _ = db.openDatabase()
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.navigationController?.navigationBar.isTranslucent = true
        tableView.delegate = self
        tableView.dataSource = self

        Process().delay(bySeconds: 0.5) {
            self.load()
        }
        searchBar.delegate = self
    }
    
    func load() {
        
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
        
        Process().delay(bySeconds: 1) { [self] in
        
            let pokemon = db.read()
            if pokemon.count > 0 {
                for x in 0..<pokemon.count {
                                       
                    let dataDecoded : Data = Data(base64Encoded: pokemon[x].image, options: .ignoreUnknownCharacters)!
                    let decodedimage = UIImage(data: dataDecoded)
                    
                    pokedex.append(Pokedex(id: pokemon[x].id, name: pokemon[x].name, imageName: decodedimage!,url: pokemon[x].url))
                    
                }
            }
            tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.pokedex.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "Please Wait!!!"
            emptyLabel.textColor = #colorLiteral(red: 0.2464925945, green: 0.2464992404, blue: 0.2464956939, alpha: 1)
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return 0
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return pokedex.count
        return isFiltering == true ? filteredPokedex.count : pokedex.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let num = "\(indexPath.row+1)"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell else {return UITableViewCell()}
        //cell.lblName.text = pokedex[indexPath.row].name?.capitalized
        cell.lblName.text = isFiltering == true ? filteredPokedex[indexPath.row].name?.capitalized : pokedex[indexPath.row].name?.capitalized
        //cell.imageView?.image = pokedex[indexPath.row].imageName
        cell.imageView?.image = isFiltering == true ? filteredPokedex[indexPath.row].imageName : pokedex[indexPath.row].imageName
            
        let id = isFiltering == true ? filteredPokedex[indexPath.row].id : pokedex[indexPath.row].id
        
        switch num.count {
        case 1:
            cell.lblNumber.text = "#00\(String(describing: id!))"
        case 2:
            cell.lblNumber.text = "#0\(String(describing: id!))"
        default:
            cell.lblNumber.text = "#\(String(describing: id!))"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let id = isFiltering == true ? filteredPokedex[indexPath.row].id : pokedex[indexPath.row].id
        Global.global.pokemonId = String(describing: id!)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"detailVC")
        self.present(viewController, animated: true)
        
    }

}

extension RangeReplaceableCollection where Self: StringProtocol {
    func paddingToLeft(upTo length: Int, using element: Element = " ") -> SubSequence {
        return repeatElement(element, count: Swift.max(0, length-count)) + suffix(Swift.max(count, count-length))
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count>0) {
            isFiltering = true
            filteredPokedex = pokedex.filter {
                $0.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        }
        else
        {
            isFiltering = false
            filteredPokedex = pokedex
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        isFiltering = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

