describe SessionsController, :omniauth do

  describe "#create" do

    it "creates a session " do
      expect(session[:user_id]).to be_nil
      auth_token = '1234123234123'
      allow(SecureRandom).to receive(:hex).and_return(auth_token)
      post :create, provider: :facebook, auth: {uid: '2341234123'}, format: :json
      expected_token = auth_token + User.last.id.to_s
      expect(response.body).to eq({success: true, auth_token: expected_token}.to_json)
    end
  end

  describe "#destroy" do

    before do
      post :create, provider: :facebook, auth: {uid: '2341234123'}, format: :json
    end
    it "resets the session" do
      expect(session[:user_id]).not_to be_nil
      delete :destroy, format: :json
      expect(session[:user_id]).to be_nil
      expect(response.status).to eq 200
      expect(response.body).to eq({success: true}.to_json)
    end
  end
end
