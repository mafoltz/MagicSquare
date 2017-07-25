//
//  MusicController.swift
//  nanoChallenge3
//
//  Created by George Vilnei Arboite Gomes on 03/07/17.
//
//

import AVFoundation

public class MusicController {
    
    public var backgroundMusic : AVAudioPlayer!
    public var audioEffect : AVAudioPlayer!
    var currentMusic : String!
    
    static let sharedInstance : MusicController = {
        let instance = MusicController()
        return instance
    }()
    
    private init(){}
    
    func playBackgroundMusic(music : String, type : String){
        if (currentMusic == nil || currentMusic != music) {
            do {
                let path = Bundle.main.path(forResource: music, ofType:type)!
                let url = URL(fileURLWithPath: path)
                
                let sound = try AVAudioPlayer(contentsOf: url)
                backgroundMusic = sound
                sound.numberOfLoops = -1
                sound.prepareToPlay()
                sound.play()
            } catch {
                print("couldn't load file")
            }

            currentMusic = music
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusic.stop()
        currentMusic = ""
    }
    
    func playAudioEffect(audio : String, type : String){
        do {
            let path = Bundle.main.path(forResource: audio, ofType:type)!
            let url = URL(fileURLWithPath: path)
            
            let sound = try AVAudioPlayer(contentsOf: url)
            audioEffect = sound
            sound.numberOfLoops = 0
            sound.prepareToPlay()
            sound.play()
        } catch {
            print("couldn't load file")
        }
    }
}
