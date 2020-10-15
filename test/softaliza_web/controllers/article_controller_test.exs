defmodule SoftalizaWeb.ArticleControllerTest do
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

    {:ok, created_article} = Events.create_article(article)

    %{id: created_article.id, event_id: created_event.id}
  end

  describe "GET /articles" do
    test "list all articles", %{conn: conn} do
      conn = get(conn, "/api/articles")

      assert [
               %{"id" => _, "title" => "some title"}
             ] = json_response(conn, 200)
    end

    test "get article by id", %{conn: conn, id: id} do
      conn = get(conn, "/api/articles/#{id}")

      assert %{"id" => ^id} = json_response(conn, 200)
    end

    test "fail to get article by id", %{conn: conn} do
      conn = get(conn, "/api/articles/0")

      assert %{"error" => "article not found"} = json_response(conn, 404)
    end
  end

  describe "PUT /articles/:id" do
    test "update article", %{conn: conn, id: id} do
      params = %{title: "some updated title"}

      conn =
        conn
        |> put_req_header("authorization", "Token admin_secret")
        |> put("/api/articles/#{id}", params)

      assert %{"id" => ^id, "title" => "some updated title"} = json_response(conn, 200)
    end

    test "fail to update article: not found", %{conn: conn} do
      params = %{title: "some updated title"}

      conn =
        conn
        |> put_req_header("authorization", "Token admin_secret")
        |> put("/api/articles/0", params)

      assert %{"error" => "article not found"} = json_response(conn, 404)
    end

    test "fail to update article: unauthorized", %{conn: conn, id: id} do
      params = %{title: "some updated title"}
      conn = put(conn, "/api/articles/#{id}", params)

      assert %{"error" => "unauthorized"} = json_response(conn, 401)
    end
  end

  describe "CREATE and DELETE /articles" do
    test "create and delete article", %{conn: conn, event_id: event_id} do
      params = %{
        title: "created article",
        doi: "created doi",
        event_id: event_id
      }

      conn = put_req_header(conn, "authorization", "Token admin_secret")
      conn_create = post(conn, "/api/articles", params)

      assert %{"id" => id} = json_response(conn_create, 201)

      conn_get = get(conn, "/api/articles/#{id}")
      conn_delete = delete(conn, "/api/articles/#{id}")
      conn_get_fail = get(conn, "/api/articles/#{id}")

      assert %{"id" => ^id} = json_response(conn_get, 200)
      assert %{"id" => ^id} = json_response(conn_delete, 200)
      assert %{"error" => "article not found"} = json_response(conn_get_fail, 404)
    end

    test "fail to create article: unauthorized", %{conn: conn, event_id: event_id} do
      params = %{
        title: "created article",
        doi: "created doi 2",
        event_id: event_id
      }

      conn = post(conn, "/api/articles", params)

      assert %{"error" => "unauthorized"} = json_response(conn, 401)
    end
  end
end
