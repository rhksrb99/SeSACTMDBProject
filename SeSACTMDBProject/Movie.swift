//
//  Movie.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/06.
//

import Foundation

struct Movie {
    var id : String
    var title : String
    var image : String
    var backGroundImage : String
    var date : String
    var rate : String
    var genreId : Int
    var overview : String
}

struct Actor {
    var actorName : String
    var actorCharacter : String
    var actorImage : String
}
