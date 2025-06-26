defmodule Servy.FileHandler do
  @moduledoc """
  ch 11 Exercise: File Handler Module
  contains the handle_file and handle_form functions,
  to handle the reading of HTML files & forms
  """

  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File not found!"}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  def handle_form({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_form({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File not found!"}
  end

  def handle_form({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end
end
