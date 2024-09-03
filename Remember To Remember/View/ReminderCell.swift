//
//  ReminderCell.swift
//  Remember To Remember
//
//  Created by Daniel Lumbu on 8/17/24.
//

import UIKit

class ReminderCell: UITableViewCell {
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var body: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
