//
//  TimerViewController.swift
//  Timer.Workout_Itea
//
//  Created by Anastasia Bilous on 2022-06-06.
//

import UIKit
import AVFoundation

protocol StartViewControllerDelegate: AnyObject {
    func changeUIProperties()
}

class StartViewController: UIViewController {
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timerForExercise = Timer()
    var timerForRest = Timer()
    var listOfExercises:[Exercise]?
    var receivedIndex = Int()
    var secondsExercise = Int()
    var secondsRest = Int()
    
    weak var delegate: StartViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseNameLabel.text = listOfExercises![receivedIndex].name
        secondsExercise = Int(listOfExercises![receivedIndex].timeForExercise) ?? 0
        timerLabel.text = "\(secondsExercise)"
        timerForExercise = Timer.scheduledTimer(timeInterval: 1.0,
                                                target:self,
                                                selector: #selector(updateTimerExercise),
                                                userInfo:nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timerForExercise.invalidate()
        timerForRest.invalidate()
    }
    
    @objc func updateTimerExercise() {
        
        if secondsExercise > 0 {
            DispatchQueue.main.async {
                self.timerLabel.text = "\(self.secondsExercise)"
            }
            secondsExercise -= 1
        } else {
            timerForExercise.invalidate()
            
            exerciseNameLabel.text = "Rest"
            self.secondsRest = Int(listOfExercises![receivedIndex].timeForRest) ?? 0
            self.timerLabel.text = "\(self.secondsRest)"
            timerForRest = Timer.scheduledTimer(timeInterval: 1.0,
                                                target:self,
                                                selector: #selector(updateTimerRest),
                                                userInfo:nil, repeats: true)
        }
    }
    
    @objc func updateTimerRest() {
        
        if secondsRest > 0 {
            DispatchQueue.main.async {
                self.timerLabel.text = "\(self.secondsRest)"
            }
            secondsRest -= 1
        } else {
            timerForRest.invalidate()            
            listOfExercises?.remove(at: receivedIndex)
            
            if listOfExercises!.isEmpty == true {
                showFinishSceen()
            } else {
                receivedIndex = 0
                exerciseNameLabel.text = listOfExercises![receivedIndex].name
                secondsExercise = Int(listOfExercises![receivedIndex].timeForExercise) ?? 0
                timerLabel.text = "\(secondsExercise)"
                timerForExercise = Timer.scheduledTimer(timeInterval: 1.0,
                                                        target:self,
                                                        selector: #selector(updateTimerExercise),
                                                        userInfo:nil, repeats: true)
            }
        }
    }
    
    func showFinishSceen() {
        let finishSceenVc = storyboard?.instantiateViewController(withIdentifier: "FinishViewController")
        as? FinishViewController
        navigationController?.pushViewController(finishSceenVc!, animated: true)
        self.delegate?.changeUIProperties()
    }
}


