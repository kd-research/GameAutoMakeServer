class ClientTerminal < ApplicationRecord
  before_create :assign_snowflake_id
  has_many :scores, class_name: 'ScoreBoard::Score', foreign_key: :client_terminal_id

  private
  def self.snowflake_generator
    @snowflake_generator ||= begin
                               service_epock = Time.new(2024, 1, 1, 0, 0, 0).strftime('%s%L').to_i
                               node_id = 1

                               AnyFlake.new(service_epock, node_id)
                             end
  end

  def assign_snowflake_id
    self.snowflake_id = ClientTerminal.snowflake_generator.next_id
  end
end
