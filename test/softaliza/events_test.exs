defmodule Softaliza.EventsTest do
  use Softaliza.DataCase

  alias Softaliza.Events

  describe "events" do
    alias Softaliza.Events.Event

    @valid_attrs %{active: true, description: "some description", end_date: ~D[2010-04-17], end_hour: ~T[14:00:00], hosted_by: "some hosted_by", link: "some link", online: true, start_date: ~D[2010-04-17], start_hour: ~T[14:00:00], title: "some title"}
    @update_attrs %{active: false, description: "some updated description", end_date: ~D[2011-05-18], end_hour: ~T[15:01:01], hosted_by: "some updated hosted_by", link: "some updated link", online: false, start_date: ~D[2011-05-18], start_hour: ~T[15:01:01], title: "some updated title"}
    @invalid_attrs %{active: nil, description: nil, end_date: nil, end_hour: nil, hosted_by: nil, link: nil, online: nil, start_date: nil, start_hour: nil, title: nil}

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

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
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
      assert event == Events.get_event!(event.id)
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
end
