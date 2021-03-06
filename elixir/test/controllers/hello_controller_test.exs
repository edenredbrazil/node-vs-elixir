defmodule ElixirApi.HelloControllerTest do
  use ElixirApi.ConnCase

  alias ElixirApi.Hello
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, hello_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    hello = Repo.insert! %Hello{}
    conn = get conn, hello_path(conn, :show, hello)
    assert json_response(conn, 200)["data"] == %{"id" => hello.id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, hello_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, hello_path(conn, :create), hello: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Hello, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, hello_path(conn, :create), hello: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    hello = Repo.insert! %Hello{}
    conn = put conn, hello_path(conn, :update, hello), hello: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Hello, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    hello = Repo.insert! %Hello{}
    conn = put conn, hello_path(conn, :update, hello), hello: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    hello = Repo.insert! %Hello{}
    conn = delete conn, hello_path(conn, :delete, hello)
    assert response(conn, 204)
    refute Repo.get(Hello, hello.id)
  end
end
