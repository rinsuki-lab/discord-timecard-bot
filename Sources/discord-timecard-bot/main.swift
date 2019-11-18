import CoreFoundation
import Foundation
import SwiftDiscord
import Hydra

guard let discordToken = ProcessInfo.processInfo.environment["DISCORD_TOKEN"] else {
    fatalError("DISCORD_TOKEN environment missing")
}

let token: DiscordToken = .init(stringLiteral: "Bot \(discordToken)")
var userJoinedChannelDictionary = [UserID: DiscordGuildVoiceChannel]()

class MyBot: DiscordClientDelegate {
    lazy var client = DiscordClient(token: token, delegate: self)
    
    func connect() {
        print("Let's Connect!")
        client.connect()
    }
    
    func client(_ client: DiscordClient, didConnect connected: Bool) {
        print("ﾑｸﾘ")
        
    }
    
    func client(_ client: DiscordClient, didReceiveVoiceStateUpdate voiceState: DiscordVoiceState) {
        let p = async { _ in
            let member = try await(client.getGuildMember(by: voiceState.userId, on: voiceState.guildId))
            let nickname = member.nick ?? member.user.username
            
            let lastChannel = userJoinedChannelDictionary[voiceState.userId]

            if voiceState.channelId == 0 { // left from last channel
                guard let lastChannel = lastChannel else { return }
                userJoinedChannelDictionary[voiceState.userId] = nil
                print("[\(lastChannel.name)] \(nickname) was left.")
                return
            }
            
            guard let currentChannel = try await(client.getChannel(voiceState.channelId)) as? DiscordGuildVoiceChannel else {
                print("failed to cast DiscordChannel to DiscordGuildVoiceChannel")
                return
            }
            userJoinedChannelDictionary[voiceState.userId] = currentChannel
            
            if let lastChannel = lastChannel { // move
                print("[\(currentChannel.name)] \(nickname) moved from \(lastChannel.name)")
            } else { // join
                print("[\(currentChannel.name)] \(nickname) joined.")
            }
        }
        p.catch { e in
            print(e)
        }
    }
}

let bot = MyBot()
DispatchQueue.global().async {
    bot.connect()
}

CFRunLoopRun()
