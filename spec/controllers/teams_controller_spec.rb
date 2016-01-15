RSpec.describe TeamsController do
  describe "GET index" do
    it "blocks unauthenticated access" do
      sign_in nil
      get :index
      expect(response).to redirect_to(:root)
    end

    context 'with login' do
      before do
        @user = create(:user)
        @team = create(:team, user: @user)
        sign_in @user
      end

      it "assigns @teams" do
        get :index
        expect(assigns(:teams)).to eq([@team])
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end
  end

  describe "#create" do
    it "blocks unauthenticated access" do
      sign_in nil
      post :create, team: {name: 'Team1'}
      expect(response).to redirect_to(:root)
    end

    context 'with login' do
      before do
        @user = create(:user)
        sign_in @user
      end

      it "creates a team" do
        expect { post :create, team: {name: 'Team1'} }.to change { Team.count }.by(1)
        expect(assigns(:team)).to eq(Team.last)
      end

      it "redirects to the team page" do
        post :create, team: {name: 'Team1'}
        expect(response).to redirect_to assigns(:team)
      end
    end
  end

  describe "#update" do
    it "blocks unauthenticated access" do
      sign_in nil
      post :update, id: 1, team: {name: 'Team1'}
      expect(response).to redirect_to(:root)
    end

    context 'with login' do
      before do
        @user = create(:user)
        sign_in @user
        @team = create(:team, user: @user)
      end

      it "update a team" do
        post :update, id: @team.id, team: {name: 'Team1o1'}
        expect(assigns(:team).name).to eq('Team1o1')
      end

      it "redirects to the team page" do
        post :update, id: @team.id, team: {name: 'Team1o1'}
        expect(response).to redirect_to assigns(:team)
      end
    end
  end

  describe "#destroy" do
    it "blocks unauthenticated access" do
      sign_in nil
      delete :destroy, id: 1
      expect(response).to redirect_to(:root)
    end

    context 'with login' do
      before do
        @user = create(:user)
        sign_in @user
        @team = create(:team, user: @user)
      end

      it "destroy the team" do
        delete :destroy, id: @team.id
        expect(flash[:notice]).to eq "Team was successfully destroyed."
        expect(response.status).to eq 302 #redirected
      end
    end
  end

end
