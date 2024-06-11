require "proto/gamegenerator_services_pb"

module GameGenerator
  class Client
    def initialize
      channel_args = {
        "grpc.max_send_message_length" => -1,
        "grpc.max_receive_message_length" => -1
      }

      server_host = ENV.fetch("GENERATOR_HOST", "localhost:9451")
      @stub = GameGenerator::Stub.new(server_host, :this_channel_is_insecure, channel_args:)
    end

    def generate_game
      @stub.generate_game(GenerateGameRequest.new)
    end
  end
end
