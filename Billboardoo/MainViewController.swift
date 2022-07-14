//
//  MainViewController.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/13.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    var flag: Bool = true
    
    //- MARK: IBOUT
    
    
    
    //- MARK: MemberFunc
    @objc func changeMode()
    {
        
        if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if #available(iOS 15.0, *) {
                let windows = window.windows.first
                windows?.overrideUserInterfaceStyle = self.flag  == true ? .dark : .light
                flag = !flag
                
            }
        } else if let window = UIApplication.shared.windows.first {
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = self.flag == true ? .dark : .light
                flag = !flag
            } else { //IOS 13 미만은 dark모드 불가
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    func configureTopBar(){
  
        
        //navigationController?.navigationBar.tintColor = UIColor(named: "iconColor")!
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.dash"),style: .plain, target: self, action: #selector(changeMode))
        
    }
    
    
    
    
    
    
    
    
    
    
    
    //- MARK: ViewMethod
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTopBar()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    
}
