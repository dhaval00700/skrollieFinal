//
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/15/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import SwiftMessages

var messageBar = MessageBarController()

enum fontSize: CGFloat {
    case largeTitleFont = 20
    case smallTitleFont = 14
}

class UtilityClass: NSObject {

    // MARK: - Message Alert Show
    class func showMessageForError(_ strTitle: String)
    {
        messageBar.MessageShow(title: strTitle as NSString, alertType: MessageView.Layout.cardView, alertTheme: .error, TopBottom: true)
    }

    
    class func showMessageForSuccess(_ strTitle: String)
    {
        messageBar.MessageShow(title: strTitle as NSString, alertType: MessageView.Layout.cardView, alertTheme: .success, TopBottom: true)
    }
   
    class func getAppDelegate() -> AppDelegate {
        
        let appdel = UIApplication.shared.delegate as? AppDelegate
        
        return appdel!
    }
        
    
class func setNavigationBarInViewController (controller : UIViewController,naviColor : UIColor, naviTitle : String, leftImage : String , rightImage : String, font : UIFont)
{
    let btnLeft = UIButton.init()
    var image = UIImage.init(named: leftImage)
    btnLeft.semanticContentAttribute = .forceLeftToRight
    
    if UserDefaults.standard.value(forKey: "i18n_language") != nil {
        if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
            if language == "ar-AE" {
                btnLeft.semanticContentAttribute = .forceRightToLeft
                
                image = UIImage.init(named: leftImage)?.imageFlippedForRightToLeftLayoutDirection()
            }
        }
    }
    btnLeft.setImage(image, for: .normal)
    btnLeft.layer.setValue(controller, forKey: "controller")
    
    btnLeft.setTitle("   \(naviTitle)", for: .normal)
    btnLeft.titleLabel?.font = font//UIFont.Bold(ofSize: 22)
    if leftImage == ""
    {
        // btnLeft.addTarget(self, action: #selector(OpenMenuViewController(_:)), for: .touchUpInside)
    }
    else
    {
        btnLeft.addTarget(self, action: #selector(poptoViewController(_:)), for: .touchUpInside)
    }
    
    let btnLeftBar : UIBarButtonItem = UIBarButtonItem.init(customView: btnLeft)
    btnLeftBar.style = .plain
    controller.navigationItem.leftBarButtonItem = btnLeftBar
    
    //        UIApplication.shared.statusBarStyle = .lightContent
    controller.navigationController?.isNavigationBarHidden = false
    controller.navigationController?.navigationBar.isOpaque = false
    controller.navigationController?.navigationBar.isTranslucent = true
    controller.navigationController?.navigationBar.backgroundColor = UIColor.clear;    controller.navigationController?.navigationBar.barTintColor = naviColor;
    controller.navigationController?.navigationBar.tintColor = UIColor.white;

        }
    
    @objc class func poptoViewController (_ sender: UIButton?)
    {
        let controller = sender?.layer.value(forKey: "controller") as? UIViewController
        controller?.navigationController?.popViewController(animated: true)
    }
    



class func convertDateFormater(_ date: String) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "HH:mm"
    return  dateFormatter.string(from: date!)
}

}
    // MARK: - Appdelegate Get Method
    
    typealias CompletionHandler = (_ success:Bool) -> Void
    
func showAlert(_ title: String, message: String, vc: UIViewController) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        //        if(vc.presentedViewController != nil)
        //        {
        //        }
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        
        //        vc.present(alert, animated: true, completion: nil)
    }
    
    
func getAppDelegate() -> AppDelegate {
        
        let appdel = UIApplication.shared.delegate as? AppDelegate

        return appdel!
    }
    
    
func poptoViewController (_ sender: UIButton?)
    {
        let controller = sender?.layer.value(forKey: "controller") as? UIViewController
        controller?.navigationController?.popViewController(animated: true)
    }
    

    
func showAlertWithCompletion(_ title: String, message: String, vc: UIViewController,completionHandler: @escaping CompletionHandler) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    

    
func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "HH:mm"
        return  dateFormatter.string(from: date!)
    }

extension UITextField {
    
    enum Direction {
        case Left
        case Right
    }
    
    // add image to textfield
    func withImage(direction: Direction, image: UIImage){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        mainView.layer.cornerRadius = 5
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        view.backgroundColor = .clear
//        view.borderColorUIView = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = CGFloat(0.5)
        view.layer.borderColor = UIColor.clear.cgColor
        mainView.addSubview(view)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
        view.addSubview(imageView)
        
        let seperatorView = UIView()
        mainView.addSubview(seperatorView)
        
        if(Direction.Left == direction){ // image left
            seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: 20)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: 20)
            self.rightViewMode = .always
            self.rightView = mainView
        }
        
        self.layer.borderWidth = CGFloat(0.5)
        self.layer.cornerRadius = 5
    }
    
}
