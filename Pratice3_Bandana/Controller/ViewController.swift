//
//  ViewController.swift
//  Pratice3_Bandana
//
//  Created by Rakesh Nangunoori on 29/01/20.
//  Copyright © 2020 Rakesh Nangunoori. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
    
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var postsTV: UITableView!
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        

       
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        postsTV.addSubview(refreshControl)
        spinner.isHidden = true
        GlobalMethod.shared.showActivityIndicator(view: view, targetVC: self)
        
        ViewModel.shared.getPosts { (error) in
            if error == nil{
                DispatchQueue.main.async {
                    GlobalMethod.shared.hideActivityIndicator(view: self.view)
                    self.postsTV.reloadData()
                }
                
            }
        }
    
        // Do any additional setup after loading the view.
    }
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
         if ViewModel.shared.totalPages > ViewModel.shared.currentPage {
             ViewModel.shared.pageCount = 0
            ViewModel.shared.postModel.removeAll()
            self.navigationItem.title = "0"
            fetchData()
        }
        refreshControl.endRefreshing()
        postsTV.reloadData()
    }
    
    func fetchData(){
        ViewModel.shared.getPosts { (error) in
            if error == nil{
                DispatchQueue.main.async {
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                    self.postsTV.reloadData()
                }
                
            }
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ViewModel.shared.postModel.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostsTableViewCell
        cell.getUpdatedCell(postModel: ViewModel.shared.postModel, indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
        
      }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        ViewModel.shared.getUpdateSwitchStatus(postModel: ViewModel.shared.postModel, indexPath: indexPath) { (error) in
            if error == nil{
                let filleteredArr = ViewModel.shared.postModel.filter{$0.switchStatus == true}
                
                if filleteredArr.count > 0 {
                    self.navigationItem.title = "\(filleteredArr.count)"
                }else{
                   self.navigationItem.title = "0"
                }
                self.postsTV.reloadData()
            }else{
                
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ViewModel.shared.postModel.count - 1{
            spinner.isHidden = false
            spinner.startAnimating()
            if ViewModel.shared.totalPages > ViewModel.shared.currentPage {
                ViewModel.shared.pageCount += 1
               
                self.fetchData()
            }else{
                spinner.isHidden = true
                spinner.stopAnimating()
            }
        }
    }
}

