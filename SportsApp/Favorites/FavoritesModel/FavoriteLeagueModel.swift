//
//  FavoriteLeague.swift
//  SportsApp
//
//  Created by Anas Salah on 10/05/2024.
//

import Foundation

struct TeamResponse: Codable { // MARK: i will need from league when click save the team_key
    let success: Int
    let result: [Team]
        
    struct Team: Codable {
        let team_key: Int
        let team_name: String
        let team_logo: String?
        let players: [Player]?
        let coaches: [Coach]?
            
        struct Player: Codable {
            let player_key: Int
            let player_name: String
            let player_image: String
            let player_age: String
            let player_goals: String
            let player_match_played: String
            let player_number: String
            let player_injured: String
        }
            
        struct Coach: Codable {
            let coach_name: String
            let coach_country: String?
            let coach_age: Int?
        }
    }
}



// MARK: testin
//let fakeTeams: [FavoriteLeagueModel] = [
//    FavoriteLeagueModel(teamKey: "1",
//                   teamName: "Los Angeles Lakers",
//                   teamLogo:"https://apiv2.allsportsapi.com/logo-basketball/1_los_angeles_lakers.jpg"),
//    FavoriteLeagueModel(teamKey: "2",
//                   teamName: "Brooklyn Nets",
//                   teamLogo: nil)
//]

