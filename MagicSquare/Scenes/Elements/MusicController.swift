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
    var currentMusic : String!
    
    static let sharedInstance : MusicController = {
        let instance = MusicController()
        return instance
    }()
    
    private init(){}
    
    func backGroundMusic(music : String, type : String){
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
}
