//
//  MainViewController.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/13.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    // MARK: memBerVariable
    
    var flag: Bool = true
    var disposeBag = DisposeBag()
    let topTwentyIdentifier = "TopTwentyTableViewCell"
    //let viewModel = TopHundredViewModel()
    var temp:[SimpleViwer] = []
    
    
    
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
    

    
    
    
    
    
    
    
    @IBAction func clickTopMenu(_ sender: UIBarButtonItem) {
        changeMode()
    }
  
    
    
    
    
    //- MARK: ViewMethod
    override func viewDidLoad() {
        super.viewDidLoad()
        toptableView.dataSource = self
        toptableView.delegate = self
        toptableView.register(UINib(nibName: topTwentyIdentifier, bundle: nil), forCellReuseIdentifier: topTwentyIdentifier)
        toptableView.separatorStyle = .none
        
        
     
  
        
        // Do any additional setup after loading the view.
    }
    
    //- MARK: IBOUT
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var toptableView: UITableView!
    
}

extension MainViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toptableView.dequeueReusableCell(withIdentifier: topTwentyIdentifier, for: indexPath) as! TopTwentyTableViewCell
        cell.timeStampLabel.text = "12:00 기준"
        for i in 0...20{
            temp.append(SimpleViwer(id: "\(i)", title: "Song\(i)", artist: "\(i) artiest", image: "https://i.imgur.com/pobpfa1.png", url: "https://youtu.be/fgSXAKsq-Vo", last: 0))
        }
        cell.configure(with: temp)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

