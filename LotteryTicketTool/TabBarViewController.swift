//
//  TabBarViewController.swift
//  LotteryTicketTool
//
//  Created by 成殿 on 21/11/2018.
//  Copyright © 2018 chengluffy. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for i in 0...((self.tabBar.items?.count ?? 1) - 1) {
            let item: UITabBarItem = self.tabBar.items?[i] ?? UITabBarItem()
            item.image = item.image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            item.selectedImage = item.selectedImage?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:i == 1 ? #colorLiteral(red: 0.9490196078, green: 0.3137254902, blue: 0.3882352941, alpha: 1) : #colorLiteral(red: 0.862745098, green: 0.2431372549, blue: 0.9215686275, alpha: 1)], for: .selected)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
