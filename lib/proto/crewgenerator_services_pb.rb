# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: proto/crewgenerator.proto for package 'crewgen'

require "grpc"
require "proto/crewgenerator_pb"

module Crewgen
  module CrewGenerator
    class Service
      include ::GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = "crewgen.CrewGenerator"

      rpc :GenerateHtmlGame, ::Crewgen::GenerateHtmlGameRequest, ::Crewgen::GenerateHtmlGameResponse
    end

    Stub = Service.rpc_stub_class
  end
end