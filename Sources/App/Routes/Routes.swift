import Vapor

extension Droplet {

    private static let bearerToken = "Bearer AAAAAAAAAAAAAAAAAAAAACVphAAAAAAAfLc3DfzM4mYmGmHDP6EVZ3ek%2FUI%3DH1iR4TxjlKqdvlmSWheZLsXbE594B8hBPzaojByNemtSOaRi3P"

    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        try resource("posts", PostController.self)

        get("post") { req in
            guard let content = req.data["content"]?.string else {
                throw Abort(.badRequest)
            }

            let post = Post(content: content)
            try post.save()
            return try post.makeJSON()
        }

        get("posts") { req in
            let posts = try Post.makeQuery().all()
            return try posts.makeJSON()
        }

        delete("post") { req in
            guard let id = req.data["id"]?.string else {
                throw Abort(.badRequest)
            }

            guard let post = try Post.makeQuery().all().filter({ (post) -> Bool in
                return post.id?.string == id
            }).first else {
                throw Abort(.notFound)
            }

            try post.delete()
            return try post.makeJSON()
        }

        get("tweets") { req in
            guard let query = req.data["query"]?.string else {
                throw Abort(.badRequest)
            }

            let response = try self.client.get("https://api.twitter.com/1.1/search/tweets.json",
                            query: ["q" : query], ["Authorization": Droplet.bearerToken])
            return response.makeResponse()
        }

        post("joke") { req in
//            print("Requested")
//            return "this is a joke"
            return "{\r\n    \"response_type\": \"ephemeral\",\r\n    \"text\": \"Here are the currently open tickets:\",\r\n    \"attachments\": [\r\n        {\r\n            \"text\": \"#123456 http://domain.com/ticket/123456 \\n\r\n            #123457 http://domain.com/ticket/123457 \\n\r\n            #123458 http://domain.com/ticket/123458 \\n\r\n            #123459 http://domain.com/ticket/123459 \\n\r\n            #123460 http://domain.com/ticket/123460\"\r\n        }\r\n    ]\r\n}"
        }
    }
}
