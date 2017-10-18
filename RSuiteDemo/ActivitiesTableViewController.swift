//
//  ActivitiesTableViewController.swift
//  RSuiteDemo
//
//  Created by James Kizer on 6/7/17.
//  Copyright © 2017 ResearchSuite. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss
import ResearchSuiteAppFramework

class ActivitiesTableViewController: UITableViewController {

    var schedule: RSAFSchedule!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.schedule = AppDelegate.loadSchedule(filename: "surveys")
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).signOut()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedule.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activity_cell", for: indexPath)
        
        assert(indexPath.row < self.schedule.items.count)
        
        // Configure the cell...
        let scheduleItem = self.schedule.items[indexPath.row]
        cell.textLabel?.text = scheduleItem.title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        assert(indexPath.row < self.schedule.items.count)
        
        let scheduleItem = self.schedule.items[indexPath.row]
        
        self.launchActivity(forItem: scheduleItem)
        
    }
    
    func launchActivity(forItem item: RSAFScheduleItem) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let steps = appDelegate.taskBuilder.steps(forElement: item.activity as JsonElement) else {
                return
        }
        
        let task = ORKOrderedTask(identifier: item.identifier, steps: steps)
        
        let taskFinishedHandler: ((ORKTaskViewController, ORKTaskViewControllerFinishReason, Error?) -> ()) = { [weak self] (taskViewController, reason, error) in
            //when finised, if task was successful (e.g., wasn't canceled)
            //process results
            if reason == ORKTaskViewControllerFinishReason.completed {
                let taskResult = taskViewController.result
                appDelegate.resultsProcessor.processResult(taskResult: taskResult, resultTransforms: item.resultTransforms)
            }
            
            if let task = taskViewController.task,
                task.identifier == "yadl_full" {
                
                self?.processYADLResult(taskResult: taskViewController.result)
                
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        let tvc = RSAFTaskViewController(
            activityUUID: UUID(),
            task: task,
            taskFinishedHandler: taskFinishedHandler
        )
        
        self.present(tvc, animated: true, completion: nil)
        
    }
    
    func processYADLResult(taskResult: ORKTaskResult) {
        
        print(taskResult)
        
        if let stepResults = taskResult.results as? [ORKStepResult] {
            print(stepResults.count)
            let identifierPredicate = NSPredicate(format: "identifier BEGINSWITH %@", "yadl_full.")
            let filteredStepResults = (stepResults as NSArray).filtered(using: identifierPredicate) as! [ORKStepResult]
            
            print(filteredStepResults.count)
            filteredStepResults.forEach({ (stepResult) in
                print(stepResult)
            })
            
            let identifierSelector = NSExpression(forKeyPath: "identifier")
            let valueSelector = NSExpression(forKeyPath: "result.answer")
            
            let mappedResults = filteredStepResults.flatMap({ (stepResult) -> (String, String)? in
                guard let identifier = identifierSelector.expressionValue(with: stepResult, context: nil) as? String,
                    let value = valueSelector.expressionValue(with: stepResult, context: nil) as? String else {
                        return nil
                }
                return (identifier, value)
            })
            
            // hi there this is me typing really fast
            
            print(mappedResults)
            print(filteredStepResults.count)
            mappedResults.forEach({ (result) in
                print(result)
            })
            
            
        }
        
        
    }

}
