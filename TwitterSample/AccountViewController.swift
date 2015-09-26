//
//  AccountViewController.swift
//  TwitterSample
//
//  Created by OsadaTakuya on 2015/09/26.
//  Copyright © 2015年 Sample. All rights reserved.
//

import UIKit
import Accounts
import Social

class AccountViewController: UITableViewController {
    /** アカウント情報取得中かどうか */
    var initializing = false
    /** アカウントストア */
    let accountStore = ACAccountStore()
    /** 取得したアカウント */
    var accounts: [ACAccount] = []
    /** 次のViewControllerに渡すアカウント情報 */
    var passAccount: ACAccount!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // セルの登録
        let nib = UINib(nibName: "AccountCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "account_cell");

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // アカウントが取得できていない場合は再取得
        if accounts.count == 0 {
            initAccounts()
        }
    }
    
    /**
     * 指定したアカウントを表示する
     */
    private func initAccounts() {
        if initializing {
            return
        }
        initializing = true
        
        // アカウント情報の取得処理
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted: Bool, error: NSError?) -> Void in
            self.initializing = false
            
            // エラー
            if let e = error {
                // TODO: エラー処理
                print("failed to get accounts information: \(e.description)")
                return
            }
            
            // 拒否
            if !granted {
                // TODO: 許可を促す
                print("access to accounts information is denied.")
                return
            }
            
            let accounts = self.accountStore.accountsWithAccountType(accountType)
            if accounts.count == 0 {
                // TODO: アカウント設定を促す
                print("no available accounts information.")
                return
            }
            
            // Viewの初期化
            if let a = accounts as? [ACAccount] {
                self.accounts = a
                self.tableView.reloadData()
            } else {
                print("unexpected error. failed to cast ACAccount list")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("account_cell", forIndexPath: indexPath)
        let data = accounts[indexPath.row]
        
        // Configure the cell...
        if let c = cell as? AccountCell {
            c.update(nil, name: data.username, id: data.userId())
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88.0
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        passAccount = accounts[indexPath.row]
        performSegueWithIdentifier("show_timeline", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "show_timeline", let controller = segue.destinationViewController as? TimelineViewController {
            controller.account = passAccount
        }
    }


}

extension ACAccount {
    
    func userId() -> String?  {
        if let id = valueForKeyPath("properties.user_id") as? String {
            return id
        } else {
            return nil
        }
    }
}
