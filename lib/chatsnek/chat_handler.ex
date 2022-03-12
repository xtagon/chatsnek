defmodule ChatSnek.ChatHandler do
  use TMI

  alias ChatSnek.ChatSpeaker
  alias ChatSnek.DebugLogger
  alias ChatSnek.VoteManager

  @chat_disable_command "off"
  @chat_enable_command "on"
  @direct_command_keyword "chatsnek"
  @directions ["up", "down", "left", "right"]

  @impl true
  def handle_message("!" <> message, sender, channel) do
    handle_message(message, sender, channel)
  end

  def handle_message(message, sender, channel) do
    message
    |> String.trim
    |> String.downcase
    |> handle_command(sender, channel)
  end

  def handle_command(@direct_command_keyword <> " " <> message, sender, channel) do
    message
    |> String.trim
    |> String.downcase
    |> handle_direct_command(sender, channel)
  end

  def handle_command(direction, sender, _channel) when direction in @directions do
    DebugLogger.handle_vote_cast(direction, sender)
    VoteManager.cast_vote(direction, sender)
  end

  def handle_command("u", sender, channel), do: handle_command("up", sender, channel)
  def handle_command("d", sender, channel), do: handle_command("down", sender, channel)
  def handle_command("l", sender, channel), do: handle_command("left", sender, channel)
  def handle_command("r", sender, channel), do: handle_command("right", sender, channel)

  # "I want that chatbot to react to WTF" -- BattlesnakeOfficial
  def handle_command("wtf", _sender, _channel) do
    ChatSpeaker.handle_wtf
  end

  # Ignore anything that isn't a valid command
  def handle_command(_command, _sender, _channel), do: nil

  def handle_direct_command(@chat_enable_command, sender, _channel) do
    if admin?(sender) do
      DebugLogger.handle_chat_speaker_enabled(sender)
      ChatSpeaker.enable()
    end
  end

  def handle_direct_command(@chat_disable_command, sender, _channel) do
    if admin?(sender) do
      DebugLogger.handle_chat_speaker_disabled(sender)
      ChatSpeaker.disable()
    end
  end

  # Ignore anything that isn't a valid direct command
  def handle_direct_command(_command, _sender, _channel), do: nil

  def say(message) do
    Application.get_env(:chatsnek, :twitch)
    |> Keyword.fetch!(:channel)
    |> say(message)
  end

  defp admin?(chat_user) do
    Application.get_env(:chatsnek, :twitch)
    |> Keyword.fetch!(:admins)
    |> MapSet.member?(String.downcase(chat_user))
  end
end
