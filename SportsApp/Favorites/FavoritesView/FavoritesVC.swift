//
//  Leagues.swift
//  SportsHub
//
//  Created by Anas Salah on 10/05/2024.
//

import UIKit
import CoreData

class FavoritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    var viewModel: FavoritesVM!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
        
        showLoadingIndicator()
        viewModel.fetchDataFromCoreData()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Erro!")
        }

        let context = appDelegate.persistentContainer.viewContext

        viewModel = FavoritesVM(context: context)

        showLoadingIndicator()

        viewModel.fetchData { [weak self] error in
            if let error = error {
                print("Error fetching data: \(error)")
            } else {
                DispatchQueue.main.async {
                    // Hide loading indicator once data is fetched
                    self?.hideLoadingIndicator()
                    self?.tableView.reloadData()
                }
            }
        }

        viewModel.onDataFetch = { [weak self] imageData, name in
            guard let self = self else { return }
            print("Going to save to CoreData")
            self.saveDataToCoreData(imageData: imageData, name: name)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell

        let favoriteTeam = viewModel.favorites[indexPath.row]
        
        cell.teamImage.layer.masksToBounds = true
        cell.teamImage.layer.borderColor = UIColor.black.cgColor
        cell.teamImage.layer.borderWidth = 3
        
        cell.teamImage.layer.cornerRadius = cell.teamImage.frame.height / 2

        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 20

        cell.teamName.text = favoriteTeam.name
        
        if let imageData = favoriteTeam.image {
            cell.teamImage.image = UIImage(data: imageData)
        } else {
            cell.teamImage.image = UIImage(named: "SportsLogoWhiteMode")
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFavoriteTeam(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    //MARK: Helper methods :-
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            let image = UIImage(data: data)
            completion(image)
        }
        task.resume()
    }
    
    func saveDataToCoreData(imageData: Data?, name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let favoritesTeamEntity = NSEntityDescription.entity(forEntityName: "FavoritesTeam", in: context)!
        let favoritesTeam = NSManagedObject(entity: favoritesTeamEntity, insertInto: context) as! FavoritesTeam
        
        if let imageData = imageData {
            favoritesTeam.image = imageData
        }
        favoritesTeam.name = name
        
        do {
            try context.save()
            print("Data saved to CoreData successfully!")
        } catch {
            print("Failed to save data to Core Data: \(error)")
        }
    }

    
    func deleteFavoriteTeam(at indexPath: IndexPath) {
        let favoriteTeam = viewModel.favorites[indexPath.row]
        let context = viewModel.context
        
        context.delete(favoriteTeam)
        
        do {
            try context.save()
            viewModel.favorites.remove(at: indexPath.row)
        } catch {
            print("Failed to delete favorite team: \(error)")
        }
    }
    
    func showLoadingIndicator() {
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }


}

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamName: UILabel!
}

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
