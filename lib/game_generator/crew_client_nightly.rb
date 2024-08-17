module GameGenerator
  class CrewClientNightly
    include CrewClientMixin
    def server_host = ENV.fetch("CREW_GENERATOR_NIGHTLY_HOST", "localhost:9452")
  end
end
