//
//  ViewController.swift
//  basic-social-network
//
//  Created by jashwanth reddy gangula on 8/20/17.
//  Copyright © 2017 jashwanth reddy gangula. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailfield: FancyField!
    @IBOutlet weak var pwdfield: FancyField!
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("ID found in Keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        emailfield.returnKeyType = UIReturnKeyType.done
        pwdfield.returnKeyType = UIReturnKeyType.done
        // Do any additional setup after loading the view, typically from a nib.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookBtnTrapped(_ sender: Any) {
       let facebookLogin = FBSDKLoginManager()
       facebookLogin.logIn(withReadPermissions: ["email"],
                           from: self) { (result, error) in
         if error != nil {
            print("Unable to authenticate with Facebook - \(String(describing: error))")
         } else if result?.isCancelled == true {
             print("User cancelled facebook authentication")
         } else {
             print("Successfully authenticated with facebook")
             let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
             self.firebaseAuth(credential)
          }
       }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: {(user, error) in
            if error != nil {
               print("JESS: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("Successfully authenticated with firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                    KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                }
            }
        })
    }
    
    @IBAction func signInTap(_ sender: Any) {
        if let email = emailfield.text, let pwd = pwdfield.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                   print("Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Unable to authenticate with Firebase using email")
                        } else {
                            print("Successfully authenticated the user")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                        
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to keychain \(keyChainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}
