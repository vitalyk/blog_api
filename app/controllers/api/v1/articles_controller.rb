class Api::V1::ArticlesController < ApplicationController
  before_action :set_article, except: %i[index create]
  before_action :authenticate_user, only: %i[create show destroy]

  def index
    @articles = Article.all

    render json: @articles
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      render json: @article, status: :created
    else
      render json: {
          error: @article.errors.full_messages
      }, status: 400
    end
  end

  def show
    render json: @article, status: :ok
  end


  def destroy
    if @article.destroy
      render head :no_content
    else
      render json: {
          error: @article.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
    render json: {
        error: 'not found'
    }, status: 404 if @article.nil?
  end

  def article_params
    params.permit(:title, :description, :category)
  end
end
