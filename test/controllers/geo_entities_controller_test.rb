require 'test_helper'

class GeoEntitiesControllerTest < ActionController::TestCase
  setup do
    @geo_entity = geo_entities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:geo_entities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create geo_entity" do
    assert_difference('GeoEntity.count') do
      post :create, geo_entity: { description: @geo_entity.description, latlon: @geo_entity.latlon, name: @geo_entity.name, user_id: @geo_entity.user_id }
    end

    assert_redirected_to geo_entity_path(assigns(:geo_entity))
  end

  test "should show geo_entity" do
    get :show, id: @geo_entity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @geo_entity
    assert_response :success
  end

  test "should update geo_entity" do
    patch :update, id: @geo_entity, geo_entity: { description: @geo_entity.description, latlon: @geo_entity.latlon, name: @geo_entity.name, user_id: @geo_entity.user_id }
    assert_redirected_to geo_entity_path(assigns(:geo_entity))
  end

  test "should destroy geo_entity" do
    assert_difference('GeoEntity.count', -1) do
      delete :destroy, id: @geo_entity
    end

    assert_redirected_to geo_entities_path
  end
end
