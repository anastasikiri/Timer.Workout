//
//  ExercisesTableViewCell.swift
//  Timer.Workout_Itea
//
//  Created by Anastasia Bilous on 2022-06-06.
//

import UIKit

class ExercisesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exerciseCellLabel: UILabel!
    @IBOutlet weak var timeOfExerciseCellLabel: UILabel!
    @IBOutlet weak var timeOfRestCellLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
