# test/notification_system_test.exs
defmodule NotificationSystemTest do
  use ExUnit.Case, async: true
  import Mox

  setup :verify_on_exit!

  test "sends an SMS message using Twilio" do
    HTTPoisonMock
    |> expect(:post, fn _url, _body, _headers ->
      {:ok, %{status_code: 201}}
    end)

    NotificationSystem.send_notification(:sms, "+1234567890", "Hello from test")
    :timer.sleep(100)  # Give the Task time to run
  end

  test "sends an email using Swoosh" do
    MailerMock
    |> expect(:deliver, fn %Swoosh.Email{} ->
      :ok
    end)

    NotificationSystem.send_notification(:email, "test@example.com", "Test Subject", "Test body")
    :timer.sleep(100)
  end
end
