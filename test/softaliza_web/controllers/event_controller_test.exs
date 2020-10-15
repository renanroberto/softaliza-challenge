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

  describe "PUT /events/:id" do
    test "update event", %{conn: conn, id: id} do
      params = %{title: "some updated title"}

      conn =
        conn
        |> put_req_header("authorization", "Token admin_secret")
        |> put("/api/events/#{id}", params)

      assert %{"id" => ^id, "title" => "some updated title"} = json_response(conn, 200)
    end

    test "failt to update event: not found", %{conn: conn} do
      params = %{title: "some updated title"}

      conn =
        conn
        |> put_req_header("authorization", "Token admin_secret")
        |> put("/api/events/0", params)

      assert %{"error" => "event not found"} = json_response(conn, 404)
    end

    test "fail to update event: unauthorized", %{conn: conn, id: id} do
      params = %{title: "some updated title"}
      conn = put(conn, "/api/events/#{id}", params)

      assert %{"error" => "unauthorized"} = json_response(conn, 401)
    end
  end

  describe "CREATE and DELETE /events" do
    test "create and delete event", %{conn: conn} do
      params = %{
        title: "created event",
        end_date: ~D[2010-04-17],
        end_hour: ~T[14:00:00],
        start_date: ~D[2010-04-17],
        start_hour: ~T[14:00:00]
      }

      conn = put_req_header(conn, "authorization", "Token admin_secret")
      conn_create = post(conn, "/api/events", params)

      assert %{"id" => id} = json_response(conn_create, 201)

      conn_get = get(conn, "/api/events/#{id}")
      conn_delete = delete(conn, "/api/events/#{id}")
      conn_get_fail = get(conn, "/api/events/#{id}")

      assert %{"id" => ^id} = json_response(conn_get, 200)
      assert %{"id" => ^id} = json_response(conn_delete, 200)
      assert %{"error" => "event not found"} = json_response(conn_get_fail, 404)
    end

    test "fail to create event: unauthorized", %{conn: conn} do
      params = %{
        title: "created event",
        end_date: ~D[2010-04-17],
        end_hour: ~T[14:00:00],
        start_date: ~D[2010-04-17],
        start_hour: ~T[14:00:00]
      }

      conn = post(conn, "/api/events", params)

      assert %{"error" => "unauthorized"} = json_response(conn, 401)
    end
  end
end
