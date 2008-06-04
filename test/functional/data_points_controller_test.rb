require File.dirname(__FILE__) + '/../test_helper'

class DataPointsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:data_points)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_data_point
    assert_difference('DataPoint.count') do
      post :create, :data_point => { }
    end

    assert_redirected_to data_point_path(assigns(:data_point))
  end

  def test_should_show_data_point
    get :show, :id => data_points(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => data_points(:one).id
    assert_response :success
  end

  def test_should_update_data_point
    put :update, :id => data_points(:one).id, :data_point => { }
    assert_redirected_to data_point_path(assigns(:data_point))
  end

  def test_should_destroy_data_point
    assert_difference('DataPoint.count', -1) do
      delete :destroy, :id => data_points(:one).id
    end

    assert_redirected_to data_points_path
  end
end
