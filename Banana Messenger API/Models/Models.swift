struct ServerError: Codable {
    let message: String
    let code: Int
}

struct ServerAnswer<T: Codable>: Codable {
    let success: Bool
    let successData: T?
    let errorData: ServerError?
}

struct LoginToken: Codable {
    let token: String
}

struct TestReply: Codable {
    let msg: String
}

struct ClientKeys {
    let eccKey: String
    let eccSignKey: String
}

/* Messages */
struct MessageFromServer: Codable {
    let fromUser: String
    let textBody: String
    let timestamp: Int
}
