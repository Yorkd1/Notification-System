defmodule SmsNotifier do
  @moduledoc """
  A lightweight wrapper for sending SMS messages using the configured Twilio client.
  """

  # During compilation, resolve which module to use for sending SMS messages.
  # Defaults to ExTwilio.Message, but can be overridden in config
  @message_client Application.compile_env(:my_app, :twilio_client, ExTwilio.Message)

  @doc """
  Sends an SMS message using the configured Twilio client.

  ## Parameters
    - to: The recipient's phone number
    - body: The content of the SMS message

  ## Returns
    - :ok if the message is sent successfully
    - {:error, reason} if an error occurs
  """
  def send_sms(to, body) do
    # Attempt to send the SMS using the Twilio client
    case @message_client.create(to: to, from: System.get_env("TWILIO_PHONE_NUMBER"), body: body) do
      {:ok, msg} ->
        # Log the SID of the successfully sent message
        IO.puts("Message sent: #{msg.sid}")
        :ok

      {:error, reason} ->
        # Log the error and return it for further handling
        IO.puts("Failed to send SMS: #{inspect(reason)}")
        {:error, reason}
    end
  end
end
