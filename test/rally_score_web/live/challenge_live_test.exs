defmodule RallyScoreWeb.ChallengeLiveTest do
  use RallyScoreWeb.ConnCase

  import Phoenix.LiveViewTest
  import RallyScore.ScoresFixtures

  @create_attrs %{name: "some name", order: 42}
  @update_attrs %{name: "some updated name", order: 43}
  @invalid_attrs %{name: nil, order: nil}

  defp create_challenge(_) do
    challenge = challenge_fixture()
    %{challenge: challenge}
  end

  describe "Index" do
    setup [:create_challenge]

    test "lists all challenges", %{conn: conn, challenge: challenge} do
      {:ok, _index_live, html} = live(conn, ~p"/challenges")

      assert html =~ "Listing Challenges"
      assert html =~ challenge.name
    end

    test "saves new challenge", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/challenges")

      assert index_live |> element("a", "New Challenge") |> render_click() =~
               "New Challenge"

      assert_patch(index_live, ~p"/challenges/new")

      assert index_live
             |> form("#challenge-form", challenge: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#challenge-form", challenge: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/challenges")

      html = render(index_live)
      assert html =~ "Challenge created successfully"
      assert html =~ "some name"
    end

    test "updates challenge in listing", %{conn: conn, challenge: challenge} do
      {:ok, index_live, _html} = live(conn, ~p"/challenges")

      assert index_live |> element("#challenges-#{challenge.id} a", "Edit") |> render_click() =~
               "Edit Challenge"

      assert_patch(index_live, ~p"/challenges/#{challenge}/edit")

      assert index_live
             |> form("#challenge-form", challenge: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#challenge-form", challenge: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/challenges")

      html = render(index_live)
      assert html =~ "Challenge updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes challenge in listing", %{conn: conn, challenge: challenge} do
      {:ok, index_live, _html} = live(conn, ~p"/challenges")

      assert index_live |> element("#challenges-#{challenge.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#challenges-#{challenge.id}")
    end
  end

  describe "Show" do
    setup [:create_challenge]

    test "displays challenge", %{conn: conn, challenge: challenge} do
      {:ok, _show_live, html} = live(conn, ~p"/challenges/#{challenge}")

      assert html =~ "Show Challenge"
      assert html =~ challenge.name
    end

    test "updates challenge within modal", %{conn: conn, challenge: challenge} do
      {:ok, show_live, _html} = live(conn, ~p"/challenges/#{challenge}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Challenge"

      assert_patch(show_live, ~p"/challenges/#{challenge}/show/edit")

      assert show_live
             |> form("#challenge-form", challenge: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#challenge-form", challenge: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/challenges/#{challenge}")

      html = render(show_live)
      assert html =~ "Challenge updated successfully"
      assert html =~ "some updated name"
    end
  end
end
