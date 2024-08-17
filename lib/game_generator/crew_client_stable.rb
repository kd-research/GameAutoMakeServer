module GameGenerator
  class CrewClientStable
    include CrewClientMixin
    def server_host = ENV.fetch("CREW_GENERATOR_HOST", "localhost:9452")
  end
end
