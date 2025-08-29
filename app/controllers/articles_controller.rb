class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_author!, only: [ :edit, :update, :destroy ]

  def index
  @articles = collection_scope.page(page_number)
  end

  def show
    unless @article.published? || (user_signed_in? && @article.author == current_user)
      redirect_to articles_path, alert: "Article not found"
    end
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
  @articles = collection_scope.page(page_number)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @article, notice: "Article was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
  @articles = collection_scope.page(page_number)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @article, notice: "Article was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
  @articles = collection_scope.page(page_number)
  @from_show = params[:from].to_s == "show"
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to articles_path, notice: "Article was successfully deleted." }
    end
  end

  private

  def set_article
    @article = Article.find_by!(slug: params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content, :published)
  end

  def authorize_author!
    unless @article.author == current_user
      redirect_to articles_path, alert: "You are not authorized to perform this action."
    end
  end

  # Collection helper selecting scope based on auth state
  def collection_scope
    if user_signed_in?
      Article.recent
    else
      Article.published.recent
    end
  end

  # Sanitize and clamp the page param to a positive integer
  def page_number
    page = params[:page].to_i
    page > 0 ? page : 1
  end
end
