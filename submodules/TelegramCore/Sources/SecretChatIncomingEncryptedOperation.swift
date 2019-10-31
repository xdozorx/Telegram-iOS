import Foundation
#if os(macOS)
    import PostboxMac
    import TelegramApiMac
#else
    import Postbox
    import TelegramApi
#endif

import SyncCore

private func keyFingerprintFromBytes(_ bytes: Buffer) -> Int64 {
    if let memory = bytes.data, bytes.size >= 4 {
        var fingerprint: Int64 = 0
        memcpy(&fingerprint, memory, 8)
        return fingerprint
    }
    return 0
}

extension SecretChatIncomingEncryptedOperation {
    convenience init(message: Api.EncryptedMessage) {
        switch message {
            case let .encryptedMessage(randomId, chatId, date, bytes, file):
                self.init(peerId: PeerId(namespace: Namespaces.Peer.SecretChat, id: chatId), globallyUniqueId: randomId, timestamp: date, type: .message, keyFingerprint: keyFingerprintFromBytes(bytes), contents: MemoryBuffer(bytes), mediaFileReference: SecretChatFileReference(file))
            case let .encryptedMessageService(randomId, chatId, date, bytes):
                self.init(peerId: PeerId(namespace: Namespaces.Peer.SecretChat, id: chatId), globallyUniqueId: randomId, timestamp: date, type: .service, keyFingerprint: keyFingerprintFromBytes(bytes), contents: MemoryBuffer(bytes), mediaFileReference: nil)
        }
    }
}
