require 'spec_helper'

describe "Postbacks" do
  before do
    Post.delete_all
  end

  it "should receive postback" do
    pending "This is testing image moderation, which we don't have set up in v2 yet"
    p = Post.create(:image_url => 'http://google.com', :flagged => nil)
    post "houdini/post/#{p.id}/image_moderation/postbacks", :flagged => "yes"

    p.reload

    p.should be_flagged
    p.houdini_request_sent_at.to_date.should == Time.now.to_date
  end
end