//
//  TopTwentyTableViewCell.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/16.
//

import UIKit
import RxCocoa
import RxSwift

class TopTwentyTableViewCell: UITableViewCell{
   
    
    
    // - MARK: global variable
    var index:Int = 0
    // - MARK: Static
    let identifier = "TopTwentyCollectionViewCell"
    var selectedIndex:Int = 0
    var nowModels:[SimpleViwer] = []
    
    func configure(with models: [SimpleViwer])
    {
        self.nowModels = models
        collectionView.reloadData()
    }
    
    
    
    
    

    
    // - MARK: member Function

    func setUpTableView()
    {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "TopTwentyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        radioButtons[0].isSelected = true // 첫번째꺼 선택
        radioButtons[0].configuration?.background.backgroundColor = UIColor(named:"wakColor")
        radioButtons[0].configuration?.baseForegroundColor = UIColor.white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    // - MARK: IBOUT
    
    @IBOutlet var radioButtons: [UIButton]!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var timeStampLabel: UILabel!
    @IBAction func pushRadioButton(_ sender:UIButton)
    {
        
        var check:Int = 0
        for index in radioButtons.indices
        {
            if(sender==radioButtons[index])
            {
                check = index
            }
        }
        
        if(check==selectedIndex)
        {
            print("Same")
        }
        else
        {
            selectedIndex = check
            sender.isSelected = true
           
            sender.configuration?.background.backgroundColor = UIColor(named:"wakColor") //버튼 색 채우기
            sender.configuration?.baseForegroundColor = UIColor.white
            /*
             table 변경
             */
            
            for unselectedIndex in radioButtons.indices
            {
                if(selectedIndex != unselectedIndex)
                {
                    radioButtons[unselectedIndex].isSelected = false
                    radioButtons[unselectedIndex].configuration?.background.backgroundColor = UIColor(named:"unSelectedBtnColor")
                    //버튼 색 채우기
                    
                    radioButtons[unselectedIndex].configuration?.baseForegroundColor = UIColor(named: "unSelectedTextColor")
                    
                
                }
            }
        }
        
        
        
        
        
        
    }
    
 

}

extension TopTwentyTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nowModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TopTwentyCollectionViewCell
        
        cell.configure(with: nowModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSize(width: 200, height: 230)
    }
  
   
    
    
    
    
}
