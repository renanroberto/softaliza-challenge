defmodule SoftalizaWeb.ArticleView do
  use SoftalizaWeb, :view

  def render("article.json", %{data: article}) do
    %{
      id: article.id,
      title: article.title,
      authors: article.authors,
      event_id: article.event_id,
      doi: article.doi,
      publication_date: article.publication_date,
      published_by: article.published_by
    }
  end

  def render("articles.json", %{data: articles}) do
    render_many(articles, __MODULE__, "article.json", as: :data)
  end
end
