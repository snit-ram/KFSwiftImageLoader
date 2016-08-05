//
//  Created by Kiavash Faisali on 2015-04-16.
//  Copyright (c) 2015 Kiavash Faisali. All rights reserved.
//

import WatchKit

final class HomeInterfaceController: WKInterfaceController {
    // MARK: - Properties
    @IBOutlet weak var animationImage: WKInterfaceImage!
    
    var imageURLStringsArray = [String]()
    
    // MARK: - Setup and Teardown
    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        
        // Animations created using KFWatchKitAnimations.
        // https://github.com/kiavashfaisali/KFWatchKitAnimations
        let drawCircleDuration = 2.0
        self.animationImage.setImageNamed("drawGreenCircle-")
        self.animationImage.startAnimatingWithImages(in: NSMakeRange(0, 118), duration: drawCircleDuration, repeatCount: 1)
        
        self.dispatchAnimationsAfterSeconds(drawCircleDuration) {
            let countdownDuration = 0.7
            self.animationImage.setImageNamed("removeBlur-")
            self.animationImage.startAnimatingWithImages(in: NSMakeRange(0, 41), duration: countdownDuration, repeatCount: 1)
            
            self.dispatchAnimationsAfterSeconds(countdownDuration) {
                let verticalShiftDuration = 1.0
                self.animationImage.setImageNamed("verticalShiftAndFadeIn-")
                self.animationImage.startAnimatingWithImages(in: NSMakeRange(0, 59), duration: verticalShiftDuration, repeatCount: 1)
                
                self.dispatchAnimationsAfterSeconds(verticalShiftDuration) {
                    let yellowCharacterDuration = 2.0
                    self.animationImage.setImageNamed("yellowCharacterJump-")
                    self.animationImage.startAnimatingWithImages(in: NSMakeRange(0, 110), duration: yellowCharacterDuration, repeatCount: 0)
                    self.loadDuckDuckGoResults()
                }
            }
        }
    }

    // MARK: - View Lifecycle
    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    // MARK: - Miscellaneous Methods
    func loadDuckDuckGoResults() {
        let session = URLSession.shared
        let url = URL(string: "http://api.duckduckgo.com/?q=simpsons+characters&format=json")!
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60.0)
        
        let dataTask = session.dataTask(with: request) {
            (taskData, taskResponse, taskError) in
            
            guard let data = taskData where taskError == nil else {
                print("Error retrieving response from the DuckDuckGo API.")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                        if let relatedTopics = jsonDict["RelatedTopics"] as? [[String: AnyObject]] {
                            for relatedTopic in relatedTopics {
                                if let imageURLString = relatedTopic["Icon"]?["URL"] as? String {
                                    if imageURLString != "" {
                                        for _ in 1...2 {
                                            self.imageURLStringsArray.append(imageURLString)
                                        }
                                    }
                                }
                            }
                            
                            if self.imageURLStringsArray.count > 0 {
                                // Uncomment to randomize the image ordering.
//                                self.randomizeImages()
                                
                                WKInterfaceController.reloadRootControllers(withNames: ["TableImageInterfaceController"], contexts: [self.imageURLStringsArray])
                            }
                        }
                    }
                }
                catch {
                    print("Error when parsing the response JSON: \(error)")
                }
            }
        }
        
        dataTask.resume()
    }
    
    func randomizeImages() {
        for i in 0 ..< self.imageURLStringsArray.count {
            let randomIndex = Int(arc4random()) % self.imageURLStringsArray.count
            let tempValue = self.imageURLStringsArray[randomIndex]
            self.imageURLStringsArray[randomIndex] = self.imageURLStringsArray[i]
            self.imageURLStringsArray[i] = tempValue
        }
    }
    
    func dispatchAnimationsAfterSeconds(_ seconds: Double, animations: () -> Void) {
        if seconds <= 0.0 {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.animationImage.stopAnimating()
            animations()
        }
    }
}
