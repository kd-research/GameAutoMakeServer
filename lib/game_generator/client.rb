require "proto/gamegenerator_services_pb"

module GameGenerator
  class Client
    def initialize
      channel_args = {
        "grpc.max_send_message_length" => -1,
        "grpc.max_receive_message_length" => -1
      }

      @stub = GameGenerator::Stub.new("localhost:9451", :this_channel_is_insecure, channel_args:)
    end

    def generate_game
      @stub.generate_game(GenerateGameRequest.new)
    end
  end
end
