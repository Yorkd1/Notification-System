defmodule NotificationSystem do
  @moduledoc """
  A notification system that supports SMS (Twilio) and Email (Swoosh).
  """

  alias Swoosh.Email
  alias MyApp.Mailer

  @twilio_account_sid System.get_env("TWILIO_ACCOUNT_SID")
  @twilio_auth_token System.get_env("TWILIO_AUTH_TOKEN")
  @twilio_from_number System.get_env("TWILIO_FROM_NUMBER")
  @twilio_api_url "https://api.twilio.com/2010-04-01/Accounts/#{@twilio_account_sid}/Messages.json"

  def send_notification(:sms, phone_number, message) do
    Task.start(fn -> send_sms(phone_number, message) end)
  end

  def send_notification(:email, recipient, subject, body) do
    Task.start(fn -> send_email(recipient, subject, body) end)
  end

  defp send_sms(phone_number, message) do
    headers = [
      {"Authorization", "Basic " <> Base.encode64("#{@twilio_account_sid}:#{@twilio_auth_token}")},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    body = URI.encode_query(%{
      "To" => phone_number,
      "From" => @twilio_from_number,
      "Body" => message
    })

    case HTTPoison.post(@twilio_api_url, body, headers) do
      {:ok, %{status_code: 201}} ->
        IO.puts("SMS sent successfully to #{phone_number}")

      {:ok, %{status_code: status}} ->
        IO.puts("Failed to send SMS. Status code: #{status}")

      {:error, error} ->
        IO.puts("Error sending SMS: #{inspect(error)}")
    end
  end

  defp send_email(recipient, subject, body) do
    email =
      Email.new()
      |> Email.to(recipient)
      |> Email.from("noreply@myapp.com")
      |> Email.subject(subject)
      |> Email.text_body(body)

    case Mailer.deliver(email) do
      :ok -> IO.puts("Email sent successfully to #{recipient}")
      {:error, reason} -> IO.puts("Failed to send email: #{inspect(reason)}")
    end
  end
end
