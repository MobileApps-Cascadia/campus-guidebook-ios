//
//  Rooms.swift
//  Campus-Guidebook-ios
//
//  Created by Student Account on 11/21/22.
//

import Foundation
class Rooms {
    //Array is in the format of building, room number, floor, longitude, latitude
    //Make sure the below values are unique or the search algorithems will freak out
    //Rooms with 1, 1 mean the location has not been added yet
    var rooms = [
        ["CC2", 180, 2, 47.7612937, -122.1919183],
        ["CC2", 170, 2, 47.7612477, -122.1918023],
        ["CC2", 161, 2, 47.7611409, -122.1917763],
        ["CC1", 102, 2, 1, 1],
        ["CC1", 231, 3, 47.7605901, -122.1914429],
        ["CC1", 210, 3, 47.7607183, -122.191432],
        ["CC1", 211, 3, 47.7607138, -122.1915578],
        ["CC1", 202, 3, 2, 2],
        ["CC1", 240, 3, 47.7645366, -122.1862012],
        ["CC1", 250, 3, 47.7645365, -122.1862013],
        ["CC2", 260, 3, 47.7612277, -122.1917231],
        ["CC2", 261, 3, 47.7611688, -122.1917305],
        ["CC2", 380, 4, 3, 3],
        ["CC2", 360, 4, 47.7613089, -122.1918239],
        ["CC2", 361, 4, 47.7611717, -122.1916787],
        ["CC1", 350, 4, 4, 4],
        ["CC1", 340, 4, 47.7610431, -122.191515],
        ["CC1", 351, 4, 47.7609508, -122.1915333],
        ["CC1", 302, 4, 47.7608001, -122.1914598],
        ["CC1", 330, 4, 47.7607571, -122.1914251],
        ["CC1", 331, 4, 47.7606605, -122.1914543]
    ]
    init(){
        
    }
    func getRoomCoordinatesByName(Room: String) -> String{
        let Building: String = String(Room.components(separatedBy: "-")[0])
        let roomNumber: Int = Int(Room.components(separatedBy: "-")[1])!
        for room in rooms{
            if ("\(room[0])" == Building){
                if(room[1] as! Int == roomNumber){
                    return "\(room[3]), \(room[4])"
                }
            }
        }
        return "Error in searching for coordinates"
    }
}
