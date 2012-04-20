Rails.application.routes.draw do
  scope "houdini/:object_class/:object_id" do
    resources :postbacks,
      :as => 'houdini_postbacks',
      :controller => 'houdini/postbacks',
      :only => [:create]
  end
end
