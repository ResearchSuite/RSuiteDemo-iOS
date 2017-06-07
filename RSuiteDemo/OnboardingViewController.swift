//
//  OnboardingViewController.swift
//  RSuiteDemo
//
//  Created by James Kizer on 6/6/17.
//  Copyright © 2017 ResearchSuite. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss
import ResearchSuiteAppFramework

class OnboardingViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signInTapped(_ sender: Any) {
        
        
        //show sign in
        guard let signInActivity = AppDelegate.loadActivity(filename: "signIn"),
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let steps = appDelegate.taskBuilder.steps(forElement: signInActivity as JsonElement) else {
            return
        }
        
        let task = ORKOrderedTask(identifier: "signIn", steps: steps)
        
        let taskFinishedHandler: ((ORKTaskViewController, ORKTaskViewControllerFinishReason, Error?) -> ()) = { [weak self] (taskViewController, reason, error) in
            
            self?.dismiss(animated: true, completion: {
                appDelegate.showViewController(animated: true)
            })
            
        }
        
        let tvc = RSAFTaskViewController(
            activityUUID: UUID(),
            task: task,
            taskFinishedHandler: taskFinishedHandler
        )
        
        self.present(tvc, animated: true, completion: nil)
        //when done, tell the app delegate to go back to the correct screen
        
        
    }
}
