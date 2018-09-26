# module for checking the correctness of the input
module Validate
  def valid?
    validate!
  rescue StandardError
    false
  end
end
