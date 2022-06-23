//
//  UserDefaultsManager.swift
//  Timer.Workout_Itea
//
//  Created by Anastasia Bilous on 2022-06-21.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
  
    func setValueForSet(value: [Exercise]?) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: "SaveExercises")
    }
    
    func getValueForSet() -> [Exercise]? {
        var exercises = [Exercise]()
        if let data = UserDefaults.standard.value(forKey:"SaveExercises") as? Data {
            exercises = try! PropertyListDecoder().decode(Array<Exercise>.self, from: data)
        }
        return exercises
    }    
}

