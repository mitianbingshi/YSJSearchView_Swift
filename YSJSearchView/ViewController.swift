//
//  ViewController.swift
//  YSJSearchView
//
//  Created by 闫树军 on 16/4/20.
//  Copyright © 2016年 闫树军. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var aSearchBar : YSJSearchView!
    var mainTableView :UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainTableView = UITableView.init(frame: CGRectMake(0, 64+44, kScreenWidth, kScreenHeight))
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.view.addSubview(mainTableView)
        
        
        aSearchBar = YSJSearchView.init(frame: CGRectMake(0, 44, kScreenWidth, 44))
        aSearchBar.placeholder = "搜索"
        aSearchBar.delegate = self
        aSearchBar.searchResultDelegate = self
        aSearchBar.searchResultDataSource = self
        self.view.addSubview(aSearchBar)
        
        
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController : UITableViewDelegate{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifer :String! = "RetailGoodsCell"
        let cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: identifer)
        if tableView == mainTableView {
            cell.textLabel?.text = "1"
        }else
        {
            cell.textLabel?.text = "2"
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
}

extension ViewController : UITableViewDataSource{
    
}

extension ViewController : YSJSearchViewDelegate{
    func searchWith(searchBar: UISearchBar, searchText: String) {
        aSearchBar.searchResultTableView.reloadData()
    }
}




