RSpec.describe MonstersController do
  describe "GET index" do
    it "blocks unauthenticated access" do
      get :index, format: :json
      expect(response.body).to eq({user: :invalid}.to_json)
    end

    context 'with login' do
      before do
        @user = create(:user)
        @monster = create(:monster, user: @user, category: 'fire')
        sign_in @user
      end

      it "should return monsters json" do
        get :index, format: :json
        expected_response = {success: true, monsters: [@monster].as_json}
        expect(response.body).to eq(expected_response.to_json)
      end

      it "should return ordered monsters json" do
        @monster2 = create(:monster, user: @user, category: 'earth')
        get :index, order: {category: 'desc'}, format: :json
        expected_response = {success: true, monsters: [@monster, @monster2].as_json}
        expect(response.body).to eq(expected_response.to_json)
      end

    end
  end

  describe "#create" do
    it "blocks unauthenticated access" do
      sign_in nil
      post :create, monster: {name: 'Monster1'}, format: :json
      expect(response.body).to eq({user: :invalid}.to_json)
    end

    context 'with login' do
      before do
        @user = create(:user)
        sign_in @user
      end

      it "creates a monster" do
        post :create, monster: attributes_for(:monster), format: :json
        expected_response = {success: true, monster: Monster.last.as_json}
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end

  describe "#update" do
    it "blocks unauthenticated access" do
      sign_in nil
      post :update, id: 1, monster: attributes_for(:monster), format: :json
      expect(response.body).to eq({user: :invalid}.to_json)
    end

    context 'with login' do
      before do
        @user = create(:user)
        sign_in @user
        @monster = create(:monster, user: @user)
      end

      it "creates a monster" do
        post :update, id: @monster.id, monster: {name: 'Monster1o1'}, format: :json
        expected_response = {success: true, monster: Monster.last.as_json}
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end

  describe "#destroy" do
    it "blocks unauthenticated access" do
      sign_in nil
      delete :destroy, id: 1, format: :json
      expect(response.body).to eq({user: :invalid}.to_json)
    end

    context 'with login' do
      before do
        @user = create(:user)
        sign_in @user
        @monster = create(:monster, user: @user)
      end

      it "destroy the monster" do
        delete :destroy, id: @monster.id, format: :json
        expected_response = {success: true}
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end

end
