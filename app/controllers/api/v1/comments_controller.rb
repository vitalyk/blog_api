class Api::V1::CommentsController < ApplicationController
  before_action :set_comment, except: %i[create index destroy]
  before_action :set_article, only: %i[create destroy]
  before_action :authenticate_user, only: %i[create destroy]

  def create
    @comment = @article.comments.build(comment_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: {
          error: @comment.errors.full_messages
      }, status: 400
    end
  end

  def index
    @comment = Article.find(params[:article_id]).comments.all
    render json: @comment, status: :ok
  end

  def destroy
    @comment = @article.comments.find(params[:id])
    if @comment.destroy
      render json: { message: 'comment removed' }
    else
      render json: {
          error: @comment.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_comment
    @comment = @article.comments.find(params[:id])
    render json: {
        error: 'not found'
    }, status: 404 if @comment.nil?
  end

  def set_article
    @article = current_user.articles.find(params[:article_id])
  end

  def comment_params
    params.permit(:description)
  end
end
