//
//  Promisify.swift
//  
//
//  Created by user on 2019/11/18.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Hydra
import SwiftDiscord

enum DiscordError: Error {
    case withResponse(HTTPURLResponse)
    case unknown
}

private func getObjOrError<ObjectType>(obj: ObjectType?, res: HTTPURLResponse?) throws -> ObjectType {
    if let obj = obj {
        return obj
    } else if let res = res {
        throw DiscordError.withResponse(res)
    } else {
        throw DiscordError.unknown
    }
}

extension DiscordClient {
    func getChannel(_ channelId: ChannelID) -> Promise<DiscordChannel> {
        Promise { resolve, reject, status in
            self.getChannel(channelId) { channel, response in
                do {
                    resolve(try getObjOrError(obj: channel, res: response))
                } catch {
                    reject(error)
                }
            }
        }
    }
    
    func getGuildMember(by id: UserID, on guildId: GuildID) -> Promise<DiscordGuildMember> {
        Promise { resolve, reject, status in
            self.getGuildMember(by: id, on: guildId) { member, res in
                do {
                    resolve(try getObjOrError(obj: member, res: res))
                } catch {
                    reject(error)
                }
            }
        }
    }
}
