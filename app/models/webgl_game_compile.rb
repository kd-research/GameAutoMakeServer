class WebglGameCompile < ApplicationRecord
  def self.build(_game_project)
    raise DeprecationError, "Webgl game type is not supported anymore"
  end

  # @deprecated
  def self.new_from_build(path, project_name = "Build")
    file_attribute = lambda do |name, **attributes|
      custom_attributes = attributes.delete(:custom) || {}
      path = Pathname.new(path)
      {
        io: File.open(path.join(name)),
        filename: name,
        metadata: { custom: custom_attributes },
        **attributes
      }
    end

    new(
      loader_file: file_attribute["#{project_name}.loader.js"],
      data_file: file_attribute["#{project_name}.data.unityweb", custom: { content_encoding: "gzip" }],
      framework_file: file_attribute["#{project_name}.framework.js.unityweb", content_type: "application/javascript",
                                                                              identify: false, custom: { content_encoding: "gzip" }],
      code_file: file_attribute["#{project_name}.wasm.unityweb", content_type: "application/wasm", identify: false,
                                                                 custom: { content_encoding: "gzip" }]
    )
  end

  self.class.deprecate :new_from_build, deprecator: Rails.application.deprecator

  # @param loader [String] The content of the loader file
  # @param data [String] The content of the data file
  # @param framework [String] The content of the framework file
  # @param code [String] The content of the code file
  # @return [WebglGameCompile]
  def self.new_from_bytes(loader:, data:, framework:, code:, worker: nil, symbol: nil)
    if [worker, symbol].any?
      raise ArgumentError, "Worker and symbol files are not supported yet"
    end

    file_attribute = lambda do |name, file_data, **attributes|
      custom_attributes = attributes.delete(:custom) || {}
      {
        io: StringIO.new(file_data),
        filename: name,
        metadata: { custom: custom_attributes },
        **attributes
      }
    end

    new(
      loader_file: file_attribute["Build.loader.js", loader,
                                  content_type: "application/javascript"],

      data_file: file_attribute["Build.data.unityweb", data,
                                custom: { content_encoding: "gzip" }],

      framework_file: file_attribute["Build.framework.js.unityweb", framework,
                                     content_type: "application/javascript", identify: false, custom: { content_encoding: "gzip" }],

      code_file: file_attribute["Build.wasm.unityweb", code,
                                content_type: "application/wasm", identify: false, custom: { content_encoding: "gzip" }]
    )
  end

  belongs_to :game_project
  has_one :game_compile, as: :gameable

  has_one_attached :loader_file
  has_one_attached :data_file
  has_one_attached :framework_file
  has_one_attached :worker_file
  has_one_attached :code_file
  has_one_attached :symbol_file
end
