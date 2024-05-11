//
//  SportsVC.swift
//  SportsApp
//
//  Created by Anas Salah on 10/05/2024.
//

import UIKit

class SportsVC: UIViewController, SplashScreenDelegate {

    
    @IBOutlet weak var footBallImage: UIImageView!
    @IBOutlet weak var tennisImage: UIImageView!
    @IBOutlet weak var basketBallImage: UIImageView!
    
    var didGoToSplashScreen = true
    var isPresentingSplashScreen = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        isDisplayedSplash()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didGoToSplashScreen && !isPresentingSplashScreen {
            didGoToSplashScreen = true
        }
        
//        let footBallImg = UIImage.gifImageWithName("Foot Ball")
//        footBallImage.image = footBallImg
//        
//        let tennisImg = UIImage.gifImageWithName("Tennis")
//        tennisImage.image = tennisImg
//        
//        let basketBallImg = UIImage.gifImageWithName("Basket ball")
//        basketBallImage.image = basketBallImg
        
        let tapGestureOnFootBall = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        footBallImage.addGestureRecognizer(tapGestureOnFootBall)
        
        let tapGestureOnTennis = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tennisImage.addGestureRecognizer(tapGestureOnTennis)
        
        let tapGestureOnBasketBall = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        basketBallImage.addGestureRecognizer(tapGestureOnBasketBall)
    }

    // MARK: Helper Methods
    
    func splashScreenDismissed() {
        didGoToSplashScreen = true
        isPresentingSplashScreen = false
    }
    
    func isDisplayedSplash() {
        if !didGoToSplashScreen && !isPresentingSplashScreen {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                viewController.modalPresentationStyle = .fullScreen
                viewController.delegate = self
                isPresentingSplashScreen = true
                navigationController?.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func imageTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "LeaguesVC") as? FavoritesVC {
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }

}

/*    
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 self.navigationItem.hidesBackButton = true
}

override func viewDidAppear(_ animated: Bool) {
 super.viewDidAppear(animated)
 let img = UIImage.gifImageWithName("intro")
 imageGif.image = img
 // MARK: withTimeInterval: 12 << is the good time
 // for testing make it 1 to run fast
 Timer.scheduledTimer(withTimeInterval: 12, repeats: false) { timer in
     self.navigateToNextController()
 }
}
 */

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
