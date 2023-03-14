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
    
//    замыкание без параметров для действия по кнопке алерта completion
    
//    func completion(){
//        self.title = nil
//        self.message = nil
//        self.buttonText = nil
//    }
}
