import Foundation
import UIKit

class AlertPresenter {
    
    func present(alert: AlertModel, presentingViewController: UIViewController) {
        let alertController = UIAlertController(title: alert.title,
                                      message: alert.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: alert.buttonText, style: .default, handler: alert.completion)
        
        alertController.addAction(action)
        alertController.preferredAction = action
        presentingViewController.present(alertController, animated: true, completion: nil)
    }
}
