//
//  FireVars.swift
//  pic24
//
//  Created by Mohammad Al-Ahdal on 2017-10-09.
//  Copyright © 2017 Mohammad Al-Ahdal. All rights reserved.
//

/*
 
 Each time you want to add just some general information, the process works such that you have to either:
     1. Specify .document("documentID").setData(["Data" : data]) // if you want a custom documentID
     2. Do ref = (...).addDocument(["Data":data]) // if you want to randomize the documentID
 
 */



import Firebase



//  FirebaseAuth Variables
var firAuth:Auth = Auth.auth()
var currentUser:User = firAuth.currentUser!

//  FireStore Variables
var fs:Firestore! = Firestore.firestore()
var fsUsersCollection = fs.collection("users")
var fsCurrentUser = fsUsersCollection.document(currentUser.uid)

class FSUser {
    var uid:String
    var name: String
    var dateOfBirth: Date?
    var joinDate: Date?
    var username: String
    var theme: Int
    var score: Int
    var postsCollection: [String:FSPost]
    
    init(user: User) {
        self.uid = user.uid
        self.name = fsUsersCollection.document(user.uid).value(forKey: "name") as! String
        self.username = fsUsersCollection.document(user.uid).value(forKey: "username") as! String
        self.theme = fsUsersCollection.document(user.uid).value(forKey: "theme") as! Int
        self.score = fsUsersCollection.document(user.uid).value(forKey: "score") as! Int
        self.postsCollection = ["shite":FSPost(), "moom":FSPost()]                                              // FIX THIS
        if fsUsersCollection.document(user.uid).value(forKey: "joinDate") != nil {
            self.joinDate = fsUsersCollection.document(user.uid).value(forKey: "joinDate") as? Date
        }
        if fsUsersCollection.document(user.uid).value(forKey: "dateOfBirth") != nil {
            self.dateOfBirth = fsUsersCollection.document(user.uid).value(forKey: "dateOfBirth") as? Date
        }
    }
}

class FSPost {
    var pid: String
    var url: String
    var mediaType: String
    var timeOut: Int
    var dateOfPost: Date
    var commentsCollection: [String:FSComment]
    var reactionsCollection: [String:FSReaction]
    
    init() {
        self.pid = ""
        self.url = ""
        self.mediaType = "photo"
        self.timeOut = 1
        self.dateOfPost = Date.init()
        self.commentsCollection = ["":FSComment()]
        self.reactionsCollection = ["":FSReaction()]
    }
}

class FSReaction {
    var rid: String
    var uid: String
    var dateOfReaction: Date
    var reactionType: Int
    init() {
        self.rid = ""
        self.uid = ""
        self.dateOfReaction = Date.init()
        self.reactionType = 1
    }
}

class FSComment {
    var cid: String
    var uid: String
    var dateOfComment: Date
    var commentText: String
    var commentReactions: [String:FSCommentReaction]
    
    init() {
        self.cid = ""
        self.uid = ""
        self.dateOfComment = Date.init()
        self.commentText = "OHHHHHHHHHH"
        self.commentReactions = ["" : FSCommentReaction(CRID: "")]
    }
}

class FSCommentReaction {
    var crid: String
    var uid: String
    var dateOfCommentReaction: Date
    var reactionType: Int
    
    init(CRID: String) {
        self.crid = ""
        self.uid = ""
        self.dateOfCommentReaction = Date.init()
        self.reactionType = 1
    }
}

//  PLEASE NOTE: THIS IS A TEMPORARY LOGIN
func performLogin() {
    firAuth.signIn(withEmail: "m@rz.ca", password: "RRRZZZ", completion: {(user, error) in
        if error != nil {
            print(error!.localizedDescription)
        }else{
            currentUser = user!
            performFSSetup()
            tempFillerSetup()
        }
    })
}
//  PLEASE NOTE: THIS IS A TEMPORARY LOGIN

func performFSSetup(){
    fs = Firestore.firestore()
    fsUsersCollection = fs.collection("users")
    fsCurrentUser = fsUsersCollection.document(currentUser.uid)
}

func tempFillerSetup() {
    fsCurrentUser.setData([
        "name"          : "Mohammad Al-Ahdal",
        "score"         : 0xFF,
        "theme"         : 0x01,
        "username"      : "mkaa00x",
        "dateOfBirth"   : NSDate.init(timeIntervalSinceNow: 0.0),
        "joinDate"      : NSDate.init(timeIntervalSinceNow: 0.0)
        ])
    
}
