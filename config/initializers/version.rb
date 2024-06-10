class << Rails.application
  def app_version
    "0.0.1"
  end

  def app_name
    Rails.application.class.module_parent_name
  end

  def deprecator
    @deprecator ||= ActiveSupport::Deprecation.new("1.0", Rails.application.class.name)
  end
end

Rails.application.deprecators[:server] = Rails.application.deprecator
