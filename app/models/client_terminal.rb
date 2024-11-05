class ClientTerminal < ApplicationRecord
  before_create :assign_snowflake_id
  has_many :scores, class_name: "ScoreBoard::Score"

  def self.find_by_token(token)
    find_by(snowflake_id: token.to_i(36))
  end

  def token
    snowflake_id.to_s(36)
  end

  private

  def self.snowflake_generator
    @snowflake_generator ||= begin
      service_epock = Time.new(2024, 1, 1, 0, 0, 0).strftime("%s%L").to_i
      node_id = 1

      AnyFlake.new(service_epock, node_id)
    end
  end

  def assign_snowflake_id
    self.snowflake_id = ClientTerminal.snowflake_generator.next_id
  end
end
