defmodule SoftalizaWeb.EventControllerTest do
  use SoftalizaWeb.ConnCase

  alias Softaliza.Events

  setup do
    event = %{
      description: "some description",
      end_date: ~D[2010-04-17],
      end_hour: ~T[14:00:00],
      hosted_by: "some hosted_by",
      link: "some link",
      online: true,
      start_date: ~D[2010-04-17],
      start_hour: ~T[14:00:00],
      title: "some title"
    }

    {:ok, created_event} = Events.create_event(event)
    Events.create_event(%{event | title: "another title"})

    article = %{
      event_id: created_event.id,
      description: "some description",
      end_date: ~D[2010-04-17],
      end_hour: ~T[14:00:00],
      doi: "some doi",
      hosted_by: "some hosted_by",
      link: "some link",
      online: true,
      start_date: ~D[2010-04-17],
      start_hour: ~T[14:00:00],
      title: "some title"
    }

    Events.create_article(article)

    %{id: created_event.id}
  end

  describe "GET /events" do
    test "list all events", %{conn: conn} do
      conn = get(conn, "/api/events")

      assert [
               %{"id" => _, "title" => "some title", "articles" => [_]},
               %{"id" => _, "title" => "another title", "articles" => []}
             ] = json_response(conn, 200)
    end

    test "get event by id", %{conn: conn, id: id} do
      conn = get(conn, "/api/events/#{id}")

      assert %{"id" => ^id} = json_response(conn, 200)
    end

    test "fail to get event by id", %{conn: conn} do
      conn = get(conn, "/api/events/0")

      assert %{"error" => "event not found"} = json_response(conn, 404)
    end
  end
end
