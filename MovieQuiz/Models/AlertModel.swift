//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by assistant on 13.03.2023.
//

import Foundation
import UIKit

struct AlertModel {
    let title:             String
    let message:           String
    let buttonText:        String
    let completion:        (UIAlertAction) -> Void
    
}
