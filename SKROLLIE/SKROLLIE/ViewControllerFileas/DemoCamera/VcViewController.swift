
import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var timerLabel: UILabel!
    
    var secound  = 60
    var timer = Timer()
    var isTimerRunning = false
    var resumTapped = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    @IBAction func startTimerPressed(_ sender: UIButton)
    {
        runTimer()
    }
    
    @IBAction func btnPause(_ sender: UIButton)
    {
        if self.resumTapped == false
        {
            timer.invalidate()
            self.resumTapped = true
        }
        else
        {
            runTimer()
            self.resumTapped = false
        }
    }
    
    func runTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func timeString(time:TimeInterval) -> String
    {
        
        let minutes         = Int(time) / 60
        let seconds         = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        
        return String(format:"%02i.%01i", minutes, Int(seconds), Int(secondsFraction * 10.0))
    }
    
    @objc func updateTime()
    {
        if timerLabel.text! != "00.0"
        {
            secound -= 1
            timerLabel.text = timeString(time: TimeInterval(secound))
            print(timerLabel.text!)
        }
    }
}
