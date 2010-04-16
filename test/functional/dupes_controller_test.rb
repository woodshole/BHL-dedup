require File.dirname(__FILE__) + '/../test_helper'
require 'dupes_controller'

# Re-raise errors caught by the controller.
class DupesController; def rescue_action(e) raise e end; end

class DupesControllerTest < Test::Unit::TestCase
  def setup
    @controller = DupesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
