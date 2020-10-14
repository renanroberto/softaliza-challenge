defmodule Softaliza.EventsTest do
  use Softaliza.DataCase

  alias Softaliza.Events

  describe "events" do
    alias Softaliza.Events.Event

    @valid_attrs %{
      active: true,
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
    @update_attrs %{
      active: false,
      description: "some updated description",
      end_date: ~D[2011-05-18],
      end_hour: ~T[15:01:01],
      hosted_by: "some updated hosted_by",
      link: "some updated link",
      online: false,
      start_date: ~D[2011-05-18],
      start_hour: ~T[15:01:01],
      title: "some updated title"
    }
    @invalid_attrs %{
      active: nil,
      description: nil,
      end_date: nil,
      end_hour: nil,
      hosted_by: nil,
      link: nil,
      online: nil,
      start_date: nil,
      start_hour: nil,
      title: nil
    }

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event(event.id) == {:ok, event}
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.active == true
      assert event.description == "some description"
      assert event.end_date == ~D[2010-04-17]
      assert event.end_hour == ~T[14:00:00]
      assert event.hosted_by == "some hosted_by"
      assert event.link == "some link"
      assert event.online == true
      assert event.start_date == ~D[2010-04-17]
      assert event.start_hour == ~T[14:00:00]
      assert event.title == "some title"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = Events.update_event(event, @update_attrs)
      assert event.active == false
      assert event.description == "some updated description"
      assert event.end_date == ~D[2011-05-18]
      assert event.end_hour == ~T[15:01:01]
      assert event.hosted_by == "some updated hosted_by"
      assert event.link == "some updated link"
      assert event.online == false
      assert event.start_date == ~D[2011-05-18]
      assert event.start_hour == ~T[15:01:01]
      assert event.title == "some updated title"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert {:ok, event} == Events.get_event(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end

  describe "articles" do
    alias Softaliza.Events.Article

    @event_attrs %{
      active: true,
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
    @valid_attrs %{
      active: true,
      authors: "some authors",
      doi: "some doi",
      publication_date: ~D[2010-04-17],
      published_by: "some published_by",
      title: "some title"
    }
    @update_attrs %{
      active: false,
      authors: "some updated authors",
      doi: "some updated doi",
      publication_date: ~D[2011-05-18],
      published_by: "some updated published_by",
      title: "some updated title"
    }
    @invalid_attrs %{
      active: nil,
      authors: nil,
      doi: nil,
      publication_date: nil,
      published_by: nil,
      title: nil
    }

    def article_fixture(attrs \\ %{}) do
      {:ok, event} = Events.create_event(@event_attrs)

      {:ok, article} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{event_id: event.id})
        |> Events.create_article()

      article
    end

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      assert Events.list_articles() == [article]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert Events.get_article!(article.id) == article
    end

    test "create_article/1 with valid data creates a article" do
      article = article_fixture()

      assert article.active == true
      assert article.authors == "some authors"
      assert article.doi == "some doi"
      assert article.publication_date == ~D[2010-04-17]
      assert article.published_by == "some published_by"
      assert article.title == "some title"
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()
      assert {:ok, %Article{} = article} = Events.update_article(article, @update_attrs)
      assert article.active == false
      assert article.authors == "some updated authors"
      assert article.doi == "some updated doi"
      assert article.publication_date == ~D[2011-05-18]
      assert article.published_by == "some updated published_by"
      assert article.title == "some updated title"
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_article(article, @invalid_attrs)
      assert article == Events.get_article!(article.id)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = Events.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> Events.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = Events.change_article(article)
    end
  end
end
