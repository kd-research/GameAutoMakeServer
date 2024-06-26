require "proto/crewgenerator_services_pb"

module GameGenerator
  class CrewClient
    include Crewgen
    def initialize
      channel_args = {
        "grpc.max_send_message_length" => -1,
        "grpc.max_receive_message_length" => -1
      }

      server_host = ENV.fetch("CREW_GENERATOR_HOST", "localhost:9452")
      @stub = CrewGenerator::Stub.new(server_host, :this_channel_is_insecure, channel_args:)
    end

    def generate_html_game
      @stub.generate_html_game(GenerateHtmlGameRequest.new)
    end
  end
end
