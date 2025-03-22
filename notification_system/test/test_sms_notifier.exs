defmodule SmsNotifierTest do
  use ExUnit.Case, async: true
  import Mox

  setup :verify_on_exit!

  test "send_sms/2 returns :ok when message is sent" do
    SmsNotifier.TwilioMock
    |> expect(:create, fn _args ->
      {:ok, %{sid: "12345"}}
    end)

    assert :ok = SmsNotifier.send_sms("+18777804236", "Hello!")
  end

  test "send_sms/2 returns {:error, reason} when message fails" do
    SmsNotifier.TwilioMock
    |> expect(:create, fn _args ->
      {:error, :rate_limited}
    end)

    assert {:error, :rate_limited} = SmsNotifier.send_sms("+18777804236", "Hello!")
  end
end
