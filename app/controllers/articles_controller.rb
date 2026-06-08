class ArticlesController < ApplicationController
  before_action :set_article, only: %i[
    show edit update destroy report
  ]

  before_action :require_authentication,
                except: %i[index show]

  before_action :authorize_owner,
                only: %i[edit update destroy]

  def index
    @articles = Article.where(archived: false)
  end

  def show
  end

  def new
    @article = Current.user.articles.build
  end

  def create
    @article = Current.user.articles.build(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  def report
    return if @article.user == Current.user

    @article.increment!(:reports_count)

    redirect_to articles_path
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def authorize_owner
    redirect_to articles_path unless @article.user == Current.user
  end

  def article_params
    params.require(:article).permit(
      :title,
      :body,
      :image
    )
  end
end