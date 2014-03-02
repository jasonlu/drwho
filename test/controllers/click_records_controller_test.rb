require 'test_helper'

class ClickRecordsControllerTest < ActionController::TestCase
  setup do
    @click_record = click_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:click_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create click_record" do
    assert_difference('ClickRecord.count') do
      post :create, click_record: { ad_id: @click_record.ad_id, from: @click_record.from, referer: @click_record.referer, url: @click_record.url }
    end

    assert_redirected_to click_record_path(assigns(:click_record))
  end

  test "should show click_record" do
    get :show, id: @click_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @click_record
    assert_response :success
  end

  test "should update click_record" do
    patch :update, id: @click_record, click_record: { ad_id: @click_record.ad_id, from: @click_record.from, referer: @click_record.referer, url: @click_record.url }
    assert_redirected_to click_record_path(assigns(:click_record))
  end

  test "should destroy click_record" do
    assert_difference('ClickRecord.count', -1) do
      delete :destroy, id: @click_record
    end

    assert_redirected_to click_records_path
  end
end
