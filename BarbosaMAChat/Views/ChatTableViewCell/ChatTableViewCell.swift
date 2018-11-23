//
//  ViewControllerTableViewCell.swift
//  BarbosaMAChat
//
//  Created by Marcos Barbosa on 18/10/18.
//  Copyright © 2018 Marcos Barbosa. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelLeftCell: UIMarginLabel!
    @IBOutlet weak var labelRightCell: UIMarginLabel!
    @IBOutlet weak var labelCenterCell: UIMarginLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureLeftCell(array: [Response], indexPath: IndexPath) {
        labelLeftCell.text = array[indexPath.row].message
        labelLeftCell.layer.cornerRadius = 8
        labelLeftCell.layer.borderColor = UIColor.black.cgColor
        labelLeftCell.layer.borderWidth = 0.3
        labelLeftCell.leftInset = 10
        labelLeftCell.rightInset = 10
        labelLeftCell.clipsToBounds = true
    }
    
    func configureRightCell(array: [Response], indexPath: IndexPath) {
        labelRightCell.text = array[indexPath.row].message
        labelRightCell.layer.cornerRadius = 8
        labelRightCell.layer.borderColor = UIColor.black.cgColor
        labelRightCell.layer.borderWidth = 0.3
        labelRightCell.leftInset = 10
        labelRightCell.rightInset = 10
        labelRightCell.clipsToBounds = true
    }
    
    func configureCenterLoggedCell(array: [Response], indexPath: IndexPath) {
        labelCenterCell.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        labelCenterCell.textColor = UIColor.white
        labelCenterCell.text = array[indexPath.row].message
        labelCenterCell.layer.cornerRadius = 8
        labelCenterCell.layer.borderColor = UIColor.black.cgColor
        labelCenterCell.layer.borderWidth = 0.3
        labelCenterCell.leftInset = 10
        labelCenterCell.rightInset = 10
        labelCenterCell.clipsToBounds = true
    }
    
    func configureCenterLogoutCell(array: [Response], indexPath: IndexPath) {
        labelCenterCell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        labelCenterCell.textColor = UIColor.white
        labelCenterCell.text = array[indexPath.row].message
        labelCenterCell.layer.cornerRadius = 8
        labelCenterCell.layer.borderColor = UIColor.black.cgColor
        labelCenterCell.layer.borderWidth = 0.3
        labelCenterCell.leftInset = 10
        labelCenterCell.rightInset = 10
        labelRightCell.clipsToBounds = true
    }

}

class UIMarginLabel: UILabel {
    
    var topInset:       CGFloat = 0
    var rightInset:     CGFloat = 0
    var bottomInset:    CGFloat = 0
    var leftInset:      CGFloat = 0
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        return super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
