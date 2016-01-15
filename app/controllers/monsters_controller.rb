class MonstersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_monster, only: [:show, :edit, :update, :destroy]

  def index
    @monsters = current_user.monsters
    @monsters = @monsters.order(params[:order]) if valid_order_params rescue @monsters
    respond_to do |format|
      format.html {}
      format.json { render json: {success: true, monsters: @monsters.as_json} }
    end
  end

  def show
  end

  def new
    @monster = Monster.new
  end

  def edit
  end

  def create
    @monster = Monster.new(monster_params)
    @monster.user_id = current_user.id
    respond_to do |format|
      if @monster.save
        format.html { redirect_to @monster, notice: 'Monster was successfully created.' }
        format.json { render json: {success: true, monster: @monster.as_json} }
      else
        format.html { render :new }
        format.json { render json: @monster.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @monster.update(monster_params)
        format.html { redirect_to @monster, notice: 'Monster was successfully updated.' }
        format.json { render json: {success: true, monster: @monster.as_json} }
      else
        format.html { render :edit }
        format.json { render json: @monster.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @monster.destroy
    respond_to do |format|
      format.html { redirect_to monsters_url, notice: 'Monster was successfully destroyed.' }
      format.json { render json: {success: true} }
    end
  end

  private
  def valid_order_params
    params[:order]
  end

  def set_monster
    @monster = current_user.monsters.find(params[:id])
  end

  def monster_params
    params.require(:monster).permit(:name, :monster_id, :power, :category)
  end
end
