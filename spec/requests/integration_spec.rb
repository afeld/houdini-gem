require 'spec_helper'

describe "End-to-end" do
  before do
    Houdini.setup 'production', :api_key => "abc123", :app_url => "http://my-app:3333/"
    DummyApp::Article.delete_all
  end

  it "should send task to Houdini and properly receive the postback" do
    article = DummyApp::Article.new :original_text => 'This is incorect.'

    params = {
      "api_key"      => Houdini.api_key,
      "environment"  => Houdini.environment,
      "postback_url" => "http://my-app:3333/houdini/DummyApp%3A%3AArticle/model-slug/postbacks",
      "blueprint"    => "edit_for_grammar",
      "input"    => {
        "input1" => "This is incorect.",
        "input2" => "This is incorect.",
        "input3" => "some text"
      }
    }.symbolize_keys

    Houdini.should_receive(:request).with(params)

    article.save!
    article.reload
    article.houdini_request_sent_at.should == Date.today.to_time

    output_params = {"edited_text"=>"This is incorrect."}

    post "houdini/DummyApp%3A%3AArticle/model-slug/postbacks", params.merge("id" => "000000000000", "status"=>"complete", "output" => output_params, "verbose_output"=> output_params).to_json

    article.reload
    article.edited_text.should == "This is incorrect."
  end
end
