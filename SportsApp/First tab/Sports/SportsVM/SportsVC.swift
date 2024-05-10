//
//  SportsVC.swift
//  SportsApp
//
//  Created by Anas Salah on 10/05/2024.
//

import UIKit

class SportsVC: UIViewController, SplashScreenDelegate {

    var didGoToSplashScreen = false
    var isPresentingSplashScreen = false

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
}

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
