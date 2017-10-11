import Vapor

extension Droplet {

    func setupRoutes() throws {

        post("joke") { req in

            return "'Q:  What do skeletons say before eating? \nA:  Bone Appetit!'"
        }

    }
}
