module Android
  class HotPatchGamesController < ApplicationController
    before_action :set_android_hot_patch_game, only: %i[show edit update destroy]
    before_action :ensure_admin!, except: %i[index show]

    # GET /android/hot_patch_games or /android/hot_patch_games.json
    def index
      @android_hot_patch_games = if current_user&.admin?
                                   Android::HotPatchGame.all
                                 else
                                   # Filter out games with pending-review status for non-admin users
                                   Android::HotPatchGame.where("groups NOT LIKE ?", "%pending-review%")
                                 end
    end

    # GET /android/hot_patch_games/1 or /android/hot_patch_games/1.json
    def show; end

    # GET /android/hot_patch_games/new
    def new
      @android_hot_patch_game = Android::HotPatchGame.new
    end

    # GET /android/hot_patch_games/1/edit
    def edit; end

    # POST /android/hot_patch_games or /android/hot_patch_games.json
    def create
      @android_hot_patch_game = Android::HotPatchGame.new(android_hot_patch_game_params)

      respond_to do |format|
        if @android_hot_patch_game.save
          format.html { redirect_to android_hot_patch_game_url(@android_hot_patch_game), notice: "Hot patch game was successfully created." }
          format.json { render :show, status: :created, location: @android_hot_patch_game }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @android_hot_patch_game.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /android/hot_patch_games/1 or /android/hot_patch_games/1.json
    def update
      respond_to do |format|
        if @android_hot_patch_game.update(android_hot_patch_game_params)
          format.html { redirect_to android_hot_patch_game_url(@android_hot_patch_game), notice: "Hot patch game was successfully updated." }
          format.json { render :show, status: :ok, location: @android_hot_patch_game }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @android_hot_patch_game.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /android/hot_patch_games/1 or /android/hot_patch_games/1.json
    def destroy
      @android_hot_patch_game.destroy!

      respond_to do |format|
        format.html { redirect_to android_hot_patch_games_url, notice: "Hot patch game was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_android_hot_patch_game
      @android_hot_patch_game = Android::HotPatchGame.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def android_hot_patch_game_params
      params.require(:android_hot_patch_game).permit(:name, :icon, :splash, :html)
    end

    def ensure_admin!
      authenticate_user!
      redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.admin?
    end
  end
end
