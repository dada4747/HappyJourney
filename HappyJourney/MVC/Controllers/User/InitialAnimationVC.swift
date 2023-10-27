//
//  InitialAnimationVC.swift
//  Internacia
//
//  Created by Admin on 07/11/22.
//

import UIKit
import ImageIO

class InitialAnimationVC: UIViewController {
    var window: UIWindow?
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let user_profile = UserDefaults.standard.object(forKey: TMXUser_Profile)

    @IBOutlet weak var img_animated: UIImageView!
    var img : UIImage?
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        img = UIImage.sd_image(withGIFData: getData())
        img_animated.image  =  img
//        animate()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(startingInformationMethod), userInfo: nil, repeats: false)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        animate()


    }
    
    func getData() -> Data {
        
        let path = Bundle.main.path(forResource: "Interngif", ofType: "gif")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        return data
    }
    private func animate(){
        UIView.animate(withDuration: 6, animations: {
            self.img_animated.image  =  self.img

        }) { finished in
            self.startingInformationMethod()

        }
//            UIView.animate(withDuration: 6) {
//            } completion: { isCompleted in
//                if isCompleted {
////                    let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "SocialLoginVC")
////                    self.navigationController?.pushViewController( vc
////                        , animated: true)
//                    self.startingInformationMethod()
//
//                }
//            }

            
        }
    
  @objc  func startingInformationMethod() -> Void {
//        
//        // keyboard manager...
//        VKKeyboardManager.shared.setEnable()
//        
//        // APIs allocation...
//        VKAPIs.shared.basicURL = TMX_Base_URL
//        // user existed...
        print("Profile: \(String(describing: user_profile))")

        if user_profile != nil {

            // move to home(Change root for window)...
            moveToHomeScreen()
        } else {
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "SocialLoginVC")
            let navi_ctrl = UINavigationController.init(rootViewController: vc)
            navi_ctrl.isNavigationBarHidden = true
            appDel.window?.rootViewController = navi_ctrl
//            self.window?.rootViewController
//            self.navigationController.i.pushViewController( vc
//                    , animated: true)
        }
        func moveToHomeScreen() {
            
            // move to home(Change root for window)...
            let home_vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CustomTabBarVC") as! CustomTabBarVC
            let navi_ctrl = UINavigationController.init(rootViewController: home_vc)
            navi_ctrl.isNavigationBarHidden = true
            appDel.window?.rootViewController = navi_ctrl
        }
    }
}
