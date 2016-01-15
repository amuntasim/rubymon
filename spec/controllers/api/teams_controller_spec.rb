RSpec.describe TeamsController do
  describe "GET index" do
    it "blocks unauthenticated access" do
      get :index, format: :json
      expect(response.body).to eq({user: :invalid}.to_json)
    end

    context 'with login' do
      before do
        @user = create(:user)
        @team = create(:team, user: @user)
        sign_in @user
      end

      it "should return teams json" do
        get :index, format: :json
        expected_response = {success: true, teams: [@team].as_json}
        expect(response.body).to eq(expected_response.to_json)
      end


    end
  end

  describe "#create" do
    it "blocks unauthenticated access" do
      sign_in nil
      post :create, team: {name: 'Team1'}, format: :json
      expect(response.body).to eq({user: :invalid}.to_json)
    end

    context 'with login' do
      before do
        @user = create(:user)
        sign_in @user
      end

      it "creates a team" do
        post :create, team: {name: 'Team1'}, format: :json
        expected_response = {success: true, team: Team.last.as_json}
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end

  describe "#update" do
    it "blocks unauthenticated access" do
      sign_in nil
      post :update, id: 1, team: {name: 'Team1'}, format: :json
      expect(response.body).to eq({user: :invalid}.to_json)
    end

    context 'with login' do
      before do
        @user = create(:user)
        sign_in @user
        @team = create(:team, user: @user)
      end

      it "creates a team" do
        post :update, id: @team.id, team: {name: 'Team1o1'}, format: :json
        expected_response = {success: true, team: Team.last.as_json}
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end

  describe "#destroy" do
    it "blocks unauthenticated access" do
      sign_in nil
      delete :destroy, id: 1,format: :json
      expect(response.body).to eq({user: :invalid}.to_json)
    end

    context 'with login' do
      before do
        @user = create(:user)
        sign_in @user
        @team = create(:team, user: @user)
      end

      it "destroy the team" do
        delete :destroy, id: @team.id, format: :json
        expected_response = {success: true}
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end

end
