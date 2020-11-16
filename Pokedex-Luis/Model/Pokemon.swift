//
//  Pokemon.swift
//  Pokedex-Luis
//
//  Created by LUIS SUAREZ on 15/11/20.
//

import Foundation

class Pokemon
{
    
    var id: String = ""
    var name: String = ""
    var image: String = ""
    var url: String = ""
    
    
    init(id:String, name:String, image:String, url:String)
    {
        self.id = id
        self.name = name
        self.image = image
        self.url = url
    }
    
}
