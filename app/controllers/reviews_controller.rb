class ReviewsController < ApplicationController
  before_action :review_authenticate, only: [:new, :edit]
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  # GET /reviews
  # GET /reviews.json
  def index
    # @reviews = Review.all
    @reviews = Review.page(params[:page]).per(6)
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
    @job = @review.job
    @user = @review.user
  end

  # GET /reviews/new
  def new
    unless user_signed_in?
      redirect_to root_path, notice: "로그인이 필요합니다 ^^"
    else
      @jobs = Job.all
      @review = current_user.reviews.new
    end
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to @review, notice: 'Review was successfully created.' }
        format.json { render action: 'show', status: :created, location: @review }
      else
        format.html { render action: 'new' }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:title, :contents, :user_id, :job_id)
    end
    
    def review_authenticate
      unless user_signed_in?
        redirect_to omniauth_authorize_path(:user, "facebook"), notice: ""
      end
    end
end
