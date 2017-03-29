//
//  InstructionViewController.swift
//  Physical_Exam_App
//
//  Created by Yuchen Qian on 3/2/17.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit
import AVFoundation


class InstructionViewController: UIViewController {
    
    var player = AVPlayer()
    var playerLayer: AVPlayerLayer!
    var timeObserver: Any!
    var playerRateBeforeSeek: Float = 0
    var isFavorite = false
    
    let invisibleButton = UIButton()
    let timeRemainingLabel = UILabel()
    let seekSlider = UISlider()
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    @IBAction func marked(_ sender: Any) {
        isFavorite = !isFavorite
        if isFavorite == true{
            rightButton.image = #imageLiteral(resourceName: "star2")
            let newInstruction = Instruction(name: titleText)
            Favorite.favoriteVisited.append(newInstruction)
        }
        else{
            rightButton.image = #imageLiteral(resourceName: "star1")
            for i in 0..<Favorite.favoriteVisited.count{
                if titleText == Favorite.favoriteVisited[i].name{
                    Favorite.favoriteVisited.remove(at: i)
                    break
                }
            }
        }
        let _ = Instruction.saveFavorite(Favorite.favoriteVisited)
    }
   
    private var _orientations = UIInterfaceOrientationMask.portrait
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get { return self._orientations }
        set { self._orientations = newValue }
    }


    @IBOutlet weak var instructionText: UITextView!
    
    var titleText : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.instructionText.text = titleText
        addToRecent()
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        player = AVPlayer(url: videoURL!)
        playerLayer = AVPlayerLayer(player: player)
        self.view.layer.addSublayer(playerLayer)
        view.addSubview(invisibleButton)
        invisibleButton.addTarget(self, action: #selector(invisibleButtonTapped),for: .touchUpInside)
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        timeObserver = player.addPeriodicTimeObserver(forInterval: timeInterval,queue: DispatchQueue.main) { (elapsedTime: CMTime) -> Void in self.observeTime(elapsedTime: elapsedTime)
        }
        timeRemainingLabel.textColor = .white
        view.addSubview(timeRemainingLabel)
        view.addSubview(seekSlider)
        seekSlider.addTarget(self, action: #selector(sliderBeganTracking),
                             for: .touchDown)
        seekSlider.addTarget(self, action: #selector(sliderEndedTracking),
                             for: [.touchUpInside, .touchUpOutside])
        seekSlider.addTarget(self, action: #selector(sliderValueChanged),
                             for: .valueChanged)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        for i in 0..<Favorite.favoriteVisited.count{
            if Favorite.favoriteVisited[i].name == titleText{
                rightButton.image = #imageLiteral(resourceName: "star2")
                isFavorite = true
                break
            }
        }
        //RecentViewController.addViewedList(item: Instruction(name: titleText))
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                performSegue(withIdentifier: "unwindToTable", sender: self)
            default:
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("orientation changed")
        // Layout subviews manually
        playerLayer.frame = view.bounds
        invisibleButton.frame = view.bounds
        let controlsHeight: CGFloat = 30
        let controlsY: CGFloat = view.bounds.size.height - controlsHeight
        timeRemainingLabel.frame = CGRect(x: 5, y: controlsY, width: 60, height: controlsHeight)
        seekSlider.frame = CGRect(x: timeRemainingLabel.frame.origin.x + timeRemainingLabel.bounds.size.width,
                                  y: controlsY, width: view.bounds.size.width - timeRemainingLabel.bounds.size.width - 5, height: controlsHeight)
        player.play()
    }
    
    func invisibleButtonTapped(sender: UIButton) {
        let playerIsPlaying = player.rate > 0
        if playerIsPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
    
    func observeTime(elapsedTime: CMTime) {
        let duration = CMTimeGetSeconds(player.currentItem!.duration)
        if  duration.isFinite {
            let elapsedTime = CMTimeGetSeconds(elapsedTime)
            updateTimeLabel(elapsedTime: elapsedTime, duration: duration)
        }
    }
    
    func updateTimeLabel(elapsedTime: Float64, duration: Float64) {
        let timeRemaining: Float64 = CMTimeGetSeconds(player.currentItem!.duration) - elapsedTime
        timeRemainingLabel.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
    }
    
    func sliderBeganTracking(slider: UISlider) {
        playerRateBeforeSeek = player.rate
        player.pause()
    }
    
    func sliderEndedTracking(slider: UISlider) {
        let videoDuration = CMTimeGetSeconds(player.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
        
        player.seek(to: CMTimeMakeWithSeconds(elapsedTime, 100)) { (completed: Bool) -> Void in
            if self.playerRateBeforeSeek > 0 {
                self.player.play()
            }
        }
    }
    
    func sliderValueChanged(slider: UISlider) {
        let videoDuration = CMTimeGetSeconds(player.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
    }
    
    func addToRecent(){
        let newInstruction = Instruction(name: titleText)
        for i in 0..<Recent.recentVisited.count{
            if newInstruction.name == Recent.recentVisited[i].name{
                Recent.recentVisited.remove(at: i)
                break
            }
        }
        if Recent.recentVisited.count == Recent.capacity{
            Recent.recentVisited.remove(at: Recent.capacity - 1)
        }
        Recent.recentVisited.insert(newInstruction, at: 0)
        let _ = Instruction.saveRecent(Recent.recentVisited)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
