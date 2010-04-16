require File.dirname(__FILE__) + '/../test_helper'
require 'picklists_controller'

# Re-raise errors caught by the controller.
class PicklistsController; def rescue_action(e) raise e end; end

class PicklistsControllerTest < Test::Unit::TestCase
  fixtures :picklists

  def setup
    @controller = PicklistsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
