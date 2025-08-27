//
//  SettingModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 25/08/25.
//

import Foundation
import UIKit

struct SettingsModel {
    let title: String?
    var items: [SettingsItem]
}

struct SettingsItem {
    let icon: UIImage?
    let title: String
    let isNextIcon: Bool? // typically right arrow
}

