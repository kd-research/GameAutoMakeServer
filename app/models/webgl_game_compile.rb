class WebglGameCompile < ApplicationRecord
  def self.new_from_build(path, project_name='Build')
    path = Pathname.new(path)
    new(
      loader_file: File.open(path.join("#{project_name}.loader.js")),
      data_file: File.open(path.join("#{project_name}.data.unityweb")),
      framework_file: File.open(path.join("#{project_name}.framework.js.unityweb")),
      code_file: File.open(path.join("#{project_name}.wasm.unityweb")),
    )
  end

  belongs_to :game_project

  has_one_attached :loader_file
  has_one_attached :data_file
  has_one_attached :framework_file
  has_one_attached :worker_file
  has_one_attached :code_file
  has_one_attached :symbol_file
end
