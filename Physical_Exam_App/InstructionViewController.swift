//
//  InstructionViewController.swift
//  Physical_Exam_App
//
//  Created by Yuchen Qian on 3/2/17.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit
import AVFoundation

struct  Note {
    var time:Float64
    var content:String
    
    init(time:Float64,content:String) {
        self.time=time
        self.content=content
    }
    
    static func sortbytime(this:Note,that:Note)->Bool{
        return this.time<=that.time
    }
}

class InstructionViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    var player = AVPlayer()
    var playerLayer: AVPlayerLayer!
    var timeObserver: Any!
    var playerRateBeforeSeek: Float = 0
    var isFavorite = false
    var source = 1
    var time : Float64 = 0
    var note:[Note]=[Note]()
    
    let invisibleButton = UIButton()
    let timeLabel = UILabel()
    let seekSlider = UISlider()
    let AddingNote=UITextField()
    let NoteButton=UIButton()
    let DeleteButton=UIButton()
    let notepad=UIPickerView()
    let JumptoButton=UIButton()
    
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    @IBAction func marked(_ sender: Any) {
        isFavorite = !isFavorite
        if isFavorite == true{
            rightButton.image = #imageLiteral(resourceName: "star2")
            let newInstruction = Instruction(name: titleText)
            Global.favoriteVisited.append(newInstruction)
        }
        else{
            rightButton.image = #imageLiteral(resourceName: "star1")
            for i in 0..<Global.favoriteVisited.count{
                if titleText == Global.favoriteVisited[i].name{
                    Global.favoriteVisited.remove(at: i)
                    break
                }
            }
        }
        let _ = Instruction.saveFavorite(Global.favoriteVisited)
        Global.favoriteEdited = true
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
        instructionText.isEditable=false
        notepad.dataSource=self
        notepad.delegate=self
        addToRecent()
        AddingNote.delegate=self
        view.addSubview(AddingNote)
        view.addSubview(NoteButton)
        view.addSubview(DeleteButton)
        view.addSubview(JumptoButton)
        view.addSubview(notepad)
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        player = AVPlayer(url: videoURL!)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x:0,y:view.bounds.maxY/4,width:view.bounds.maxX,height:view.bounds.maxX/16*9)
        player.currentItem!.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)
        self.view.layer.addSublayer(playerLayer)
        view.addSubview(invisibleButton)
        invisibleButton.frame=playerLayer.frame
        invisibleButton.addTarget(self, action: #selector(invisibleButtonTapped),for: .touchUpInside)
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        NoteButton.addTarget(self, action: #selector(TakeNote), for: .touchUpInside)
        NoteButton.setTitle("Add", for: UIControlState.normal)
        NoteButton.backgroundColor=UIColor.blue
        DeleteButton.addTarget(self, action: #selector(DeleteNote), for: .touchUpInside)
        DeleteButton.setTitle("Delete", for: UIControlState.normal)
        DeleteButton.backgroundColor=UIColor.blue
        timeObserver = player.addPeriodicTimeObserver(forInterval: timeInterval,queue: DispatchQueue.main) { (elapsedTime: CMTime) -> Void in self.observeTime(elapsedTime: elapsedTime)
        }
        timeLabel.textColor = .white
        view.addSubview(timeLabel)
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
        for i in 0..<Global.favoriteVisited.count{
            if Global.favoriteVisited[i].name == titleText{
                rightButton.image = #imageLiteral(resourceName: "star2")
                isFavorite = true
                break
            }
        }
        //RecentViewController.addViewedList(item: Instruction(name: titleText))
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return note.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let t=String(format:"%02d:%02d",((lround(note[row].time) / 60) % 60), lround(note[row].time) % 60)
        return t+":    "+note[row].content
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if source == 1{
                    performSegue(withIdentifier: "unwindToTable", sender: self)
                }
                else if source == 3{
                    performSegue(withIdentifier: "unwindToFavorite", sender: self)
                }
                else if source == 2{
                    performSegue(withIdentifier: "unwindToRecent", sender: self)
                }
                else{
                    performSegue(withIdentifier: "unwindToAll", sender: self)
                }
            default:
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func TakeNote(sender: UIButton) {
        if(AddingNote.text != ""){
            let newNote=Note(time: time,content: AddingNote.text!)
            note.append(newNote)
            note.sort(by: Note.sortbytime)
            notepad.reloadAllComponents()
            AddingNote.text=""
        }
    }
    
    func DeleteNote(sender: UIButton){
        if(note.count>0){
        note.remove(at: notepad.selectedRow(inComponent: 0))
        notepad.reloadAllComponents()
        }
    }
    

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Layout subviews manually
        let controlsHeight: CGFloat = 30
        let controlsY: CGFloat = self.playerLayer.frame.maxY-controlsHeight
        print(controlsY)
        timeLabel.frame = CGRect(x: 5, y: controlsY, width: 110, height: controlsHeight)
        AddingNote.frame = CGRect(x:5,y:self.playerLayer.frame.maxY+5,width:view.bounds.size.width/4*3,height:30)
        AddingNote.borderStyle=UITextBorderStyle.roundedRect
        NoteButton.frame = CGRect(x:AddingNote.frame.maxX+5,y:self.playerLayer.frame.maxY+5,width:view.bounds.size.width/4-20,height:30)
        seekSlider.frame = CGRect(x: timeLabel.frame.origin.x + timeLabel.bounds.size.width,
                                  y: controlsY, width: view.bounds.size.width - timeLabel.bounds.size.width - 5, height: controlsHeight)
        instructionText.frame=CGRect(x:30,y:self.playerLayer.frame.minY-125,width:240,height:120)
        notepad.frame=CGRect(x:5,y:AddingNote.frame.maxY+50,width:view.bounds.size.width-10,height:view.bounds.size.height-AddingNote.frame.maxY-10)
        DeleteButton.frame=CGRect(x:view.bounds.midX+30,y:notepad.frame.minY-30,width:60,height:30)
        DeleteButton.isEnabled=true
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if player.currentItem?.status == AVPlayerItemStatus.readyToPlay {
            if UIDevice.current.orientation.isLandscape{
                let controlsHeight: CGFloat = 30
                let controlsY: CGFloat = view.bounds.size.height-controlsHeight
                timeLabel.frame = CGRect(x: 5, y: controlsY, width: 110, height: controlsHeight)
                seekSlider.frame = CGRect(x: timeLabel.frame.origin.x + timeLabel.bounds.size.width,
                                          y: controlsY, width: view.bounds.size.width - timeLabel.bounds.size.width - 5, height: controlsHeight)
            }
            else if UIDevice.current.orientation.isPortrait{
                            }
            
             player.play()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        print("return")
        textField.resignFirstResponder()
        return true;
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
            self.time=elapsedTime
        }
    }
    
    func updateTimeLabel(elapsedTime: Float64, duration: Float64) {
        timeLabel.text = String(format: "%02d:%02d / %02d:%02d", ((lround(elapsedTime) / 60) % 60), lround(elapsedTime) % 60,((lround(duration) / 60) % 60), lround(duration) % 60)
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
        if(titleText == nil){
            return
        }
        let newInstruction = Instruction(name: titleText)
        for i in 0..<Global.recentVisited.count{
            if newInstruction.name == Global.recentVisited[i].name{
                Global.recentVisited.remove(at: i)
                break
            }
        }
        if Global.recentVisited.count == Global.capacity{
            Global.recentVisited.remove(at: Global.capacity - 1)
        }
        Global.recentVisited.insert(newInstruction, at: 0)
        let _ = Instruction.saveRecent(Global.recentVisited)
        Global.recentEdited = true
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
