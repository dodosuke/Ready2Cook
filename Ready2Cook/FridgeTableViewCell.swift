//
//  FridgeTableViewCell.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/27/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

protocol FridgeTableViewCellDelegate {
    
    func textFieldDidEndEditing(cell: FridgeTableViewCell, value: NSString) -> ()
    
}


class FridgeTableViewCell: UITableViewCell  {
    
    var delegate: FridgeTableViewCellDelegate! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func textFieldDidEndEditing(textField: UITextField) {
        self.delegate.textFieldDidEndEditing(self, value: textField.text!)
    }
}