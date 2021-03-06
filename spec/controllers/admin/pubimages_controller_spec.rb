require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../factories'

RSpec.configure do |c|
  c.include PunditMock
end

describe Admin::PubimagesController do
  describe 'handling GET to index' do
    before(:each) do
      FactoryGirl.create(:pubimage)
      FactoryGirl.create(:pubimage, pimage: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', '美丽的sky.jpg')))
      sign_in FactoryGirl.create(:admin)
      get :index
    end

    it "is successful" do
      expect(response).to be_success
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end

    it "finds pubimages for the view" do
      expect(assigns[:pubimages].size).to eq(2)
    end
  end
  describe 'handling POST to create with valid attributes' do
    it 'creates a pubimage' do
      sign_in FactoryGirl.create(:admin)
      expect { post :create, :pubimage => FactoryGirl.attributes_for(:pubimage) }.to change(Pubimage, :count).by(1)
    end
  end
  describe 'handling DELETE to delete with valid attributes' do 
    before(:each) do
      @pubimage = instance_double("pubimage")
      allow(@pubimage).to receive(:destroy).and_return(true)
      allow(Pubimage).to receive(:find).and_return(@pubimage)
      mock_authorize(@pubimage)
    end

    def do_delete
      sign_in FactoryGirl.create(:admin)
      delete :destroy, :id => 1
    end

    it 'updates the page' do
      do_delete
      expect(@pubimage).to have_received(:destroy)
    end

    it 'it redirects to index' do
      do_delete
      expect(response).to be_redirect
      expect(response).to redirect_to(admin_pubimages_path)
    end
  end

  describe 'handling download with valid attributes' do
    it 'should return a right file with right name' do
      pubimage1 = FactoryGirl.create(:pubimage)
      expect(@controller).to receive(:download) {
        @controller.render nothing: true # to prevent a 'missing template' error
        assigns[:pubimage].name = "sky.jpg"
      }
      sign_in FactoryGirl.create(:admin)
      get :download, :id => pubimage1.id
    end
  end

end