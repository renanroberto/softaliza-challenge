defmodule SoftalizaWeb.EventView do
  use SoftalizaWeb, :view

  def render("event.json", %{data: event}) do
    articles =
      render_many(
        event.articles,
        SoftalizaWeb.ArticleView,
        "article.json",
        as: :data
      )

    %{
      id: event.id,
      title: event.title,
      description: event.description,
      start_hour: event.start_hour,
      end_hour: event.end_hour,
      start_date: event.start_date,
      end_date: event.end_date,
      articles: articles,
      online: event.online,
      hosted_by: event.hosted_by,
      link: event.link
    }
  end

  def render("events.json", %{data: events}) do
    render_many(events, __MODULE__, "event.json", as: :data)
  end
end
