//
//  YSJSearchView.swift
//  YSJSearchView
//
//  Created by 闫树军 on 16/4/20.
//  Copyright © 2016年 闫树军. All rights reserved.
//

import UIKit


protocol YSJSearchViewDelegate {
    
    func searchWith(searchBar:UISearchBar,searchText:String)
}


let kScreenWidth           = CGRectGetWidth(UIScreen.mainScreen().bounds)
let kScreenHeight          = CGRectGetHeight(UIScreen.mainScreen().bounds)

class YSJSearchView: UIView {
    
    var cancelBtn               : UIButton!
    var _maskView               : UIButton!
    var _frame                  : CGRect!
    var _searchBar              : UISearchBar!
    var placeholder             : String!
    var searchResultTableView   : UITableView!
    var searchResultDelegate    : UITableViewDelegate!
    var searchResultDataSource  : UITableViewDataSource!
    var delegate                : YSJSearchViewDelegate!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGrayColor()
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, kScreenWidth, 44)
        _frame = self.frame  // 捕获self.frame
        
        if (_searchBar == nil) {
            _searchBar = UISearchBar.init(frame: CGRectMake(0, 0, kScreenWidth, 44))
            _searchBar.delegate = self
            _searchBar.autocorrectionType = UITextAutocorrectionType.No
            _searchBar.autocapitalizationType = UITextAutocapitalizationType.None
            _searchBar.subviews[0].subviews[0].removeFromSuperview()
            _searchBar.placeholder = placeholder
            self.addSubview(_searchBar)
            
            
        
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(YSJSearchView.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(YSJSearchView.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        }

        self.addSubview(_searchBar)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func showMaskView() {
        
        cancelBtn = UIButton.init(type: UIButtonType.RoundedRect)
        cancelBtn .setTitle("取消", forState: .Normal)
        cancelBtn.addTarget(self, action: #selector(YSJSearchView.hiddenMaskView), forControlEvents: .TouchUpInside)

        
        _maskView = UIButton.init(type: UIButtonType.RoundedRect)
        _maskView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        _maskView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)
        _maskView.addTarget(self, action: #selector(YSJSearchView.hiddenMaskView), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(cancelBtn)
        self.superview!.addSubview(_maskView)

    }
    
    func hiddenMaskView() {
        _searchBar.resignFirstResponder()
        _searchBar.text = "";
        self._maskView.removeFromSuperview()
        self.cancelBtn.removeFromSuperview()
        self.searchResultTableView.removeFromSuperview()

    }
    
    func aSearchResultTableView() ->UITableView {
        
        if (searchResultTableView == nil) {
            searchResultTableView = UITableView.init(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))
            searchResultTableView.delegate = searchResultDelegate
            searchResultTableView.dataSource = searchResultDataSource

        }
        return searchResultTableView
       

    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView .animateWithDuration(duration, animations: { 
            self.frame = CGRectMake(0, 0, kScreenWidth, 64);
            self._searchBar.frame = CGRectMake(0, 20, kScreenWidth - 50, 44)
            self.cancelBtn.frame = CGRectMake(kScreenWidth - 50, 20, 50, 44);
            
            var object = self .nextResponder()
            
            while (!((object?.isKindOfClass(UIViewController))! ) && object != nil){
                    object = object?.nextResponder()
            }
            
            let vc = object as! UIViewController
            //vc.navigationController!.navigationBarHidden = true
            }) { (finished) in
 
        }
        
        
        
        
    }
    
    func keyboardWillHide(notification:NSNotification)  {
        
        
        let userInfo:NSDictionary = notification.userInfo!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView .animateWithDuration(duration, animations: {
            self.frame = self._frame
            self._searchBar.frame = CGRectMake(0, 0, kScreenWidth, 44)
            
            var object = self .nextResponder()
            
            while (!((object?.isKindOfClass(UIViewController))! ) && object != nil){
                object = object?.nextResponder()
            }
            
            let vc = object as! UIViewController
            //vc.navigationController!.navigationBarHidden = false
        }) { (finished) in
            
        }
        

    }
 
    
}

// 
extension YSJSearchView : UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        showMaskView()
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (delegate != nil) {
            if searchBar.text?.characters.count != 0 {
                _maskView.addSubview(aSearchResultTableView())
                delegate.searchWith(searchBar, searchText: searchText)
            }
        }
    }
    
}



