require File.dirname(__FILE__) + '/../../spec_helper'

describe PostsController do
  describe "route" do
    # it 'generates show params' do
    #   expect({:get => "/admin/session"}).to route_to(:controller => 'admin/sessions', :action => 'show')
    # end

    it 'generates new params' do
      expect({:get => "/admin/sign_in"}).to route_to(:controller => 'devise/sessions', :action => 'new')
    end

    it 'generates destroy params' do
      expect({:delete => "/admin/sign_out"}).to route_to(:controller => 'devise/sessions', :action => 'destroy')
    end
  end
end
