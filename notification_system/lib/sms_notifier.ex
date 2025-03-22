defmodule SmsNotifier do
  @message_client Application.compile_env(:my_app, :twilio_client, ExTwilio.Message)

  def send_sms(to, body) do
    case @message_client.create(to: to, from: System.get_env("TWILIO_PHONE_NUMBER"), body: body) do
      {:ok, msg} ->
        IO.puts("Message sent: #{msg.sid}")
        :ok

      {:error, reason} ->
        IO.puts("Failed to send SMS: #{inspect(reason)}")
        {:error, reason}
    end
  end
end
