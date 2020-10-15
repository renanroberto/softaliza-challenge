defmodule SoftalizaWeb.ArticleController do
  use SoftalizaWeb, :controller

  alias Softaliza.Events
  alias SoftalizaWeb.ErrorResponse

  def index(conn, _params) do
    articles = Events.list_articles()

    render(conn, "articles.json", data: articles)
  end

  def show(conn, %{"id" => id}) do
    case Events.get_article(id) do
      {:ok, article} ->
        render(conn, "article.json", data: article)

      {:error, :not_found} ->
        ErrorResponse.not_found(conn, "article")
    end
  end

  def create(conn, params) do
    case Events.create_article(params) do
      {:ok, article} ->
        conn
        |> put_status(201)
        |> render("article.json", data: article)

      {:error, changeset} ->
        ErrorResponse.bad_request(conn, changeset)
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, article} <- Events.get_article(id),
         {:ok, new_article} <- Events.update_article(article, params) do
      render(conn, "article.json", data: new_article)
    else
      {:error, :not_found} ->
        ErrorResponse.not_found(conn, "article")

      {:error, changeset} ->
        ErrorResponse.bad_request(conn, changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, article} <- Events.get_article(id),
         {:ok, deleted_article} <- Events.delete_article(article) do
      render(conn, "article.json", data: deleted_article)
    else
      {:error, :not_found} ->
        ErrorResponse.not_found(conn, "article")

      {:error, changeset} ->
        ErrorResponse.bad_request(conn, changeset)
    end
  end
end
