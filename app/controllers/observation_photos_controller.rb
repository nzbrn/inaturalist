class ObservationPhotosController < ApplicationController
  before_filter :login_required
  
  def show
    @observation_photo = ObservationPhoto.find_by_id(params[:id])
    respond_to do |format|
      format.json do
        render :json => @observation_photo.to_json(:include => {
          :photo => {
            :methods => %w(license_code)
          }
        })
      end
    end
  end
  
  def create
    @observation_photo = ObservationPhoto.new(params[:observation_photo])
    unless @observation_photo.observation
      respond_to do |format|
        format.json do
          if params[:observation_photo] && params[:observation_photo][:observation_id]
            render :json => "Observation hasn't been added to NatureWatch NZ", 
              :status => :unprocessable_entity
          else
            render :json => "No observation specified", :status => :unprocessable_entity
          end
        end
      end
      return
    end
    if params[:file]
      @photo = LocalPhoto.new(:file => params[:file], :user => current_user, :mobile => is_mobile_app?)
      @photo.save
      @observation_photo.photo = @photo
    end
    
    unless @observation_photo.photo && @observation_photo.photo.valid?
      respond_to do |format|
        Rails.logger.error "[ERROR #{Time.now}] Failed to create observation photo, params: #{params.inspect}"
        format.json { render :json => "No photo specified", :status => :unprocessable_entity }
      end
      return
    end
    
    @observation_photo.save
    
    respond_to do |format|
      format.json do
        if @observation_photo.valid?
          render :json => @observation_photo.to_json(:include => [:photo])
        else
          Rails.logger.error "[ERROR #{Time.now}] Failed to create observation photo: #{@observation_photo.errors.full_messages.to_sentence}"
          render :json => @observation_photo.errors, :status => :unprocessable_entity
        end
      end
    end
  end
  
  def update
    unless @observation_photo = ObservationPhoto.find_by_id(params[:id])
      respond_to do |format|
        format.json { render :json => "No photo specified", :status => :unprocessable_entity }
      end
      return
    end
    
    @observation_photo.photo.file = params[:file] if params[:file]
    if @observation_photo.save
      render :json => @observation_photo.to_json(:include => [:photo])
    else
      Rails.logger.error "[ERROR #{Time.now}] Failed to update observation photo: #{@observation_photo.errors.full_messages.to_sentence}"
      render :json => @observation_photo.errors, :status => :unprocessable_entity
    end
  end
end
