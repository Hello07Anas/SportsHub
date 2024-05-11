//
//  FavoritesVM.swift
//  SportsHub
//
//  Created by Anas Salah on 11/05/2024.
//

import Foundation
import Alamofire
import CoreData
import Kingfisher

class FavoritesVM {
    
    // coreData
    var favorites: [FavoritesTeam] = []
    let context: NSManagedObjectContext

    
    // netwrok related
    var teamResponse: TeamResponse?
    var teamID = 100
    var league = "football/?&met=Teams&teamId=" // "cricket/?&met=Teams&teamId=" //
    var baseUrl = "https://apiv2.allsportsapi.com/"
    let apiKey = "463e81a5fab411a1723707c80e9aaec0c16bdfbf90536258ea9448bf4a838721"
    
    var url: String {
        return "\(baseUrl)\(league)\(teamID)&APIkey=\(apiKey)"
    }
    
    var onDataFetch: ((Data?, String) -> Void)?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchData(completion: @escaping (Error?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    self.teamResponse = try decoder.decode(TeamResponse.self, from: data)
                    
                    if let imageUrlString = self.teamResponse?.result[0].team_logo, let name = self.teamResponse?.result[0].team_name {
                        self.downloadImage(from: imageUrlString) { imageData in
                            self.onDataFetch?(imageData, name)
                        }
                    }
                    
                    completion(nil)
                } catch {
                    completion(error)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    private func downloadImage(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // Use Kingfisher to download the image asynchronously
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                completion(value.image.pngData())
            case .failure:
                // Image downloading failed
                completion(nil)
            }
        }
    }
    
    func fetchDataFromCoreData() {
        let fetchRequest: NSFetchRequest<FavoritesTeam> = FavoritesTeam.fetchRequest()
        
        do {
            // Fetch data from Core Data
            favorites = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch data from Core Data: \(error)")
        }
    }
}



// now save the data in Core Data

//    func saveDataToCoreData(imageData: Data?, name: String) {
//        // Initialize Core Data stack
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        // Create a new FavoritesTeam managed object
//        let favoritesTeamEntity = NSEntityDescription.entity(forEntityName: "FavoritesTeam", in: context)!
//        let favoritesTeam = NSManagedObject(entity: favoritesTeamEntity, insertInto: context) as! FavoritesTeam
//
//        // Set values
//        if let imageData = imageData {
//            favoritesTeam.image = imageData
//        }
//        favoritesTeam.name = name
//
//        // Save the managed object context
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save data to Core Data: \(error)")
//        }
//    }
