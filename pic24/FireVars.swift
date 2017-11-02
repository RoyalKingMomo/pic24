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
var firAuth:Auth!
var currentUser:User!

//  FireStore Variables
var fs:Firestore!
var fsUsersCollection:CollectionReference!
var fsCurrentUser:DocumentReference!

//Custom Class Variables
var temporaryFSUser:FSUser!

class FSUser {
    var uid:String
    var name: String!
    var dateOfBirth: Date!
    var joinDate: Date!
    var username: String!
    var theme: Int!
    var score: Int!
    var postsCollection: [String : FSPost]!
    var userDocument:DocumentReference
    
    init(user: User) {
        self.uid = user.uid
        self.userDocument = fsUsersCollection.document(user.uid)
        
        var name: String!
        var dateOfBirth: Date!
        var joinDate: Date!
        var username: String!
        var theme: Int!
        var score: Int!
        
        self.userDocument.getDocument(completion: {(documentSnapshot, error) in
            if documentSnapshot != nil {
                name = documentSnapshot!.data()["name"] as! String
                dateOfBirth = documentSnapshot!.data()["dateOfBirth"] as! Date
                joinDate = documentSnapshot!.data()["joinDate"] as! Date
                username = documentSnapshot!.data()["username"] as! String
                theme = documentSnapshot!.data()["theme"] as! Int
                score = documentSnapshot!.data()["score"] as! Int
                self.name = name
                self.dateOfBirth = dateOfBirth
                self.joinDate = joinDate
                self.username = username
                self.theme = theme
                self.score = score
            }else{
                print(error!.localizedDescription)
            }
            
        })
        
    }
    
    func pullPosts()/* -> [String : FSPost]*/{
        userDocument.collection("posts").order(by: "dateOfPost").getDocuments(completion: {(querySnapshot, error) in
            if error == nil {
                for i in 0...querySnapshot!.documents.count-1{
                    let n = querySnapshot!.documents.count-i-1
                    // using n gives you most recent post if you sort by "dateOfPost"
                    print(querySnapshot!.documents[n].documentID)
                }
            }else{
                print(error!.localizedDescription)
            }
        })
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

func attemptAutoLogin (successToDo: @escaping () -> Void, failToDo: @escaping () -> Void) {
    if let alreadySignedIn = Auth.auth().currentUser {
        print(alreadySignedIn.email!)
        successToDo()
    }else{
        print("Not Signed in")
        failToDo()
    }
}

func logOut (completion: @escaping () -> Void) {
    try! Auth.auth().signOut()
    attemptAutoLogin(successToDo: {
        fatalError("Still Logged in! Despite sign out")
    }, failToDo: {
        print("userSignedOutSuccy")
        completion()
    })
}

func performLogin(email: String, password: String, completion: @escaping () -> Void ) {
    firAuth = Auth.auth()
    firAuth.signIn(withEmail: email, password: password, completion: {(user, error) in
        if error != nil {
            let alertController = UIAlertController(title: "Ooops!", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.default, handler: nil))
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(alertController, animated: true, completion: nil)
                // topController should now be your topmost view controller
            }
        }else{
            currentUser = user!
            performFSSetup()
            print(user!.email!)
            completion()
        }
    })
}

func performSignUp(email: String, password: String, completion: @escaping () -> Void ) {
    firAuth = Auth.auth()
    firAuth.createUser(withEmail: email, password: password, completion:{ (user, error) in
        if error != nil{
            let alertController = UIAlertController(title: "Ooops!", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.default, handler: nil))
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(alertController, animated: true, completion: nil)
                // topController should now be your topmost view controller
            }
        }else{
            currentUser = user!
            performFSSetup()
            print(user!.email!)
            completion()
        }
    })
}

func fillUserDataOnSignUp (name: String, username: String, dateOfBirth: Date){
    fsCurrentUser.setData([
        "name"          : name,
        "score"         : 0x00,
        "theme"         : 0x01,
        "username"      : username,
        "dateOfBirth"   : NSDate.init(timeInterval: 0, since: dateOfBirth),
        "joinDate"      : NSDate.init(timeIntervalSinceNow: 0.0)
        ])
}

func performFSSetup(){
    fs = Firestore.firestore()
    fsUsersCollection = fs.collection("users")
    if currentUser == nil {
        print("userNotLoggedIn")
    } else {
        fsCurrentUser = fsUsersCollection.document(currentUser.uid)
    }
}
