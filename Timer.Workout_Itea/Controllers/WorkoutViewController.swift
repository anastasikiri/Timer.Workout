//
//  ViewController.swift
//  Timer.Workout_Itea
//
//  Created by Anastasia Bilous on 2022-06-06.
//

import UIKit
import Foundation

class WorkoutViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var addMoreButton: UIButton!
    @IBOutlet weak var createSetButton: UIButton!
    @IBOutlet weak var exerciseTableView: UITableView!
    @IBOutlet weak var tableViewNameLabel: UILabel!
    
    var exerciseNameTextField: UITextField?
    var timeForExerciseTextField: UITextField?
    var timeForRestTextField: UITextField?
    
    var alertVC = UIAlertController (title: "",
                                     message: nil,
                                     preferredStyle:.alert
    )
    
    var exercises = [Exercise]()
    var choiceIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exercises = UserDefaultsManager.shared.getValueForSet() ?? [Exercise]()
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
        
        modifyScreen()
    }
    
    func modifyScreen() {
        createSetButton.isHidden = false
        startButton.isHidden = true
        addMoreButton.isHidden = true
        exerciseTableView.isHidden = true
        tableViewNameLabel.isHidden = true
    }
    
    func detailsOfWorkoutSet() {
        alertVC = UIAlertController (title: "Create new set",
                                     message: nil,
                                     preferredStyle:.alert
        )
        
        let plusAction = UIAlertAction (title: "Add", style: .default) { [self]
            (action) -> Void in
            
            if let exerciseName = self.exerciseNameTextField?.text {
                print("Exercise Name = \(exerciseName)")
            } else {
                print("No exercise name entered")
            }
            
            if let timeForExercise = self.timeForExerciseTextField?.text {
                print("Time for exercise = \(timeForExercise)")
            } else {
                print("No exercise name entered")
            }
            
            if let timeForRest = self.timeForRestTextField?.text {
                print("Time for rest = \(timeForRest)")
            } else {
                print("No exercise name entered")
            }
            
            if exerciseNameTextField?.text?.isEmpty == true ||
                timeForExerciseTextField?.text?.isEmpty == true ||
                timeForRestTextField?.text?.isEmpty == true {
                showAlertMessage(message: "Please enter required information!")
            } else if Int((self.timeForExerciseTextField?.text)!) == nil {
                showAlertMessage(message: "Time for exercise field must be a number!")
            } else if Int((self.timeForRestTextField?.text)!) == nil {
                showAlertMessage(message: "Time for rest field must be a number!")
            } else {
                startButton.isHidden = false
                addMoreButton.isHidden = false
                createSetButton.isHidden = true
                exerciseTableView.isHidden = false
                tableViewNameLabel.isHidden = false
                
                self.exercises.append(
                    Exercise(name: self.exerciseNameTextField?.text ?? "",
                             timeForExercise: self.timeForExerciseTextField?.text ?? "",
                             timeForRest: self.timeForRestTextField?.text ?? "")
                )
                UserDefaultsManager.shared.setValueForSet(value: exercises)
                exerciseTableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction (title: "Cancel", style: .cancel) { UIAlertAction in
            self.dismiss(animated: true,completion: nil
            )}
        
        alertVC.addAction(plusAction)
        alertVC.addAction(cancelAction)
        alertVC.preferredAction = plusAction
        
        alertVC.addTextField {
            (txtExercise) -> Void in
            self.exerciseNameTextField = txtExercise
            self.exerciseNameTextField!.placeholder = "Exercise name"
        }
        alertVC.addTextField {
            (txtTimeForExercise) -> Void in
            self.timeForExerciseTextField = txtTimeForExercise
            self.timeForExerciseTextField!.placeholder = "Time for exercise"
        }
        alertVC.addTextField {
            (txtTimeForRest) -> Void in
            self.timeForRestTextField = txtTimeForRest
            self.timeForRestTextField!.placeholder = "Time for rest"
        }
        present(alertVC, animated: true, completion: nil)
        alertVC.removeFromParent()
    }
    
    func showAlertMessage(message: String) {
        let innerAlertVC = UIAlertController (title: nil, message: message,
                                              preferredStyle:.alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.present(self.alertVC, animated: true, completion: nil
            )}
        
        innerAlertVC.addAction(okAction)
        present(innerAlertVC,
                animated: true,
                completion: nil
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let startViewController = segue.destination as? StartViewController {
            startViewController.listOfExercises = exercises
            startViewController.receivedIndex = choiceIndex
            choiceIndex = 0
            exerciseTableView.reloadData()
            startViewController.delegate = self
        }
    }
    
    @IBAction func createNewSetButton(_ sender: Any) {
        detailsOfWorkoutSet()
    }
    
    @IBAction func startButton(_ sender: Any) {
    }
    
    @IBAction func addMoreButton(_ sender: Any) {
        detailsOfWorkoutSet()
    }
}

extension WorkoutViewController: StartViewControllerDelegate {
    func changeUIProperties() {
        modifyScreen()
    }
}

extension WorkoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        choiceIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            choiceIndex = 0
            UserDefaultsManager.shared.setValueForSet(value: exercises)
            if exercises.isEmpty {
                modifyScreen()
            }
            tableView.endUpdates()
        }
    }
}


extension WorkoutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExercisesTableViewCell",
                                                 for: indexPath) as? ExercisesTableViewCell
        cell?.exerciseCellLabel.text = exercises[indexPath.row].name
        cell?.timeOfExerciseCellLabel.text = exercises[indexPath.row].timeForExercise
        cell?.timeOfRestCellLabel.text = exercises[indexPath.row].timeForRest
        return cell ?? UITableViewCell()
    }
}
