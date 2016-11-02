class PointsSettingsController < ApplicationController
  before_action :set_points_setting, only: [:show, :edit, :update, :destroy]

  # GET /points_settings
  def index
    @points_settings = PointsSetting.all
  end

  # GET /points_settings/1
  def show
  end

  # GET /points_settings/new
  def new
    @points_setting = PointsSetting.new
  end

  # GET /points_settings/1/edit
  def edit
  end

  # POST /points_settings
  def create
    @points_setting = PointsSetting.new(points_setting_params)

    if @points_setting.save
      redirect_to @points_setting, notice: 'Points setting was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /points_settings/1
  def update
    if @points_setting.update(points_setting_params)
      redirect_to @points_setting, notice: 'Points setting was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /points_settings/1
  def destroy
    @points_setting.destroy
    redirect_to points_settings_url, notice: 'Points setting was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_points_setting
      @points_setting = PointsSetting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def points_setting_params
      params[:points_setting]
    end
end
