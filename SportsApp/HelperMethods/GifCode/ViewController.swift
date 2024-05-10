//
//  ViewController.swift
//  SportsApp
//
//  Created by Anas Salah on 10/05/2024.
//

import UIKit

// MARK: this only will handel the Gif and nav to HomeScreen "Sports"

protocol SplashScreenDelegate: AnyObject {
    func splashScreenDismissed()
}

class ViewController: UIViewController {

    @IBOutlet weak var imageGif: UIImageView!
    weak var delegate: SplashScreenDelegate?
    
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

    func navigateToNextController() {
        self.dismiss(animated: true) {
            self.delegate?.splashScreenDismissed() // Notify delegate
        }
    }

}

