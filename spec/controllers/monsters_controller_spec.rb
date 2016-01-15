RSpec.describe MonstersController do
  describe "GET index" do
    it "blocks unauthenticated access" do
      sign_in nil
      get :index
      expect(response).to redirect_to(:root)
    end

    context 'with login' do
      before do
        @user = create(:user)
        @monster = create(:monster, user: @user)
        sign_in @user
      end

      it "assigns @monsters" do
        get :index
        expect(assigns(:monsters)).to eq([@monster])
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
      post :create, monster: {name: 'Monster1'}
      expect(response).to redirect_to(:root)
    end

    context 'with login' do
      before do
        @user = create(:user)
        sign_in @user
      end

      it "creates a monster" do
        expect { post :create, monster: attributes_for(:monster) }.to change { Monster.count }.by(1)
        expect(assigns(:monster)).to eq(Monster.last)
      end

      it "redirects to the monster page" do
        post :create, monster: attributes_for(:monster)
        expect(response).to redirect_to assigns(:monster)
      end
    end
  end

  describe "#update" do
    it "blocks unauthenticated access" do
      sign_in nil
      post :update, id: 1, monster: {name: 'Monster1o1'}
      expect(response).to redirect_to(:root)
    end

    context 'with login' do
      before do
        @user = create(:user)
        sign_in @user
        @monster = create(:monster, user: @user)
      end

      it "update a monster" do
        post :update, id: @monster.id, monster: {name: 'Monster1o1'}
        expect(assigns(:monster).name).to eq('Monster1o1')
      end

      it "redirects to the monster page" do
        post :update, id: @monster.id, monster: {name: 'Monster1o1'}
        expect(response).to redirect_to assigns(:monster)
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
        @monster = create(:monster, user: @user)
      end

      it "destroy the monster" do
        delete :destroy, id: @monster.id
        expect(flash[:notice]).to eq "Monster was successfully destroyed."
        expect(response.status).to eq 302 #redirected
      end
    end
  end
end
