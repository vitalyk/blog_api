class Api::V1::ArticlesController < ApplicationController
  before_action :set_article, except: %i[index create show]
  before_action :authenticate_user, only: %i[create destroy]

  def index
    @articles = if params[:category]
                  Article.all.select { |article| article.category == params[:category].downcase }
                elsif params[:user_id] then
                  id = params[:user_id].to_i
                  Article.all.select { |article| article.user_id == id }
                else
                  Article.all
                end

    decorated_articles = []
    @articles.each do |article|
      decorated_articles << {
          title: article.title,
          description: prettify_description_length(article),
          category: article.category,
          created_at: article.created_at,
          comments: article.comments.count
      }
    end
    render json: decorated_articles
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
    @article = Article.find(params[:id])
    render json:
               {
                   title: @article.title,
                   description: @article.description,
                   category: @article.category,
                   created_at: @article.created_at
               }, status: :ok
  end

  def destroy
    @article = current_user.articles.find(params[:id])
    if @article.destroy
      render json: { message: 'article removed' }
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

  def prettify_description_length(article)
    description = article.description
    description.length > 500 ? description.slice(0, 500) + "..." :  description
  end
end
