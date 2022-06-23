//
//  FinishViewController.swift
//  Timer.Workout_Itea
//
//  Created by Anastasia Bilous on 2022-06-15.
//

import UIKit

class FinishViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        sleep(5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goToFirstScreen()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func goToFirstScreen() {
        navigationController?.popToRootViewController(animated: true)
    }
}
