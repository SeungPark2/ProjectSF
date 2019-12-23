//
//  PlayListViewController.swift
//  ProjectSF
//
//  Created by PST on 2019/12/23.
//  Copyright © 2019 PST. All rights reserved.
//

import UIKit
import Firebase

class PlayListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?
    var postsRef = Database.database().reference().child("DATA").child("0").child("game").ref
    var keyArray: [String] = []
    var post = [MatchData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDatabase()
        setTableView()
    }
    
    @IBAction func InsertMatchButton(_ sender: UIButton) {
        guard let insertmatch = self.storyboard?.instantiateViewController(withIdentifier: "InsertMatchView") else {return}
        self.navigationController?.pushViewController(insertmatch, animated: true)
    }
    
    func setTableView() {
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.frame = self.view.frame
        tableView?.tableFooterView = UIView()
    }
    
    func setDatabase() {
        postsRef.observe(.value, with: { (snapshot) in
            self.post.removeAll()
            
            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot else {return}
                let posted = MatchData(snapshot: childSnapshot)
                self.post.insert(posted, at: 0)
            }
            self.tableView?.reloadData(with: .simple(duration: 0.45, direction: .left(useCellsFrame: true), constantDelay: 0))
        })
    }
    
    func getAllKeys() {
        postsRef.observeSingleEvent(of: .value, with: { (snapshot ) in
            
            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot else {return}
                let key = childSnapshot.key
                self.keyArray.append(key)
            }
        })
    }
        
}

class TeamListCell: UITableViewCell {
    
    @IBOutlet weak var teamName: UILabel?
    @IBOutlet weak var teamAge: UILabel?
    @IBOutlet weak var teamClass: UILabel?
    @IBOutlet weak var teamUniform: UILabel?
    
    var post: MatchData? {
        didSet {
            teamName?.text = post?.teamName
            teamAge?.text = post?.teamAge
            teamClass?.text = post?.teamClass
            teamUniform?.text = post?.teamUniform
        }
    }
}

extension PlayListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListCell", for: indexPath) as? TeamListCell else {
            return TeamListCell.init()
        }
        
        let item = post[indexPath.row]
        
        cell.teamName?.text = item.teamName
        cell.teamAge?.text = item.teamAge
        cell.teamClass?.text = item.teamClass
        cell.teamUniform?.text = item.teamUniform
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

extension PlayListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}
