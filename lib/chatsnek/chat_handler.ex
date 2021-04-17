defmodule ChatSnek.ChatHandler do
  use TMI.Handler

  alias ChatSnek.ChatSpeaker
  alias ChatSnek.DebugLogger
  alias ChatSnek.VoteManager

  @chat_disable_command "off"
  @chat_enable_command "on"
  @direct_command_keyword "chatsnek"
  @directions ["up", "down", "left", "right"]

  @impl true
  def handle_message("!" <> message, sender, chat) do
    handle_message(message, sender, chat)
  end

  @impl true
  def handle_message(message, sender, chat) do
    message
    |> String.trim
    |> String.downcase
    |> handle_command(sender, chat)
  end

  def handle_command(@direct_command_keyword <> " " <> message, sender, chat) do
    message
    |> String.trim
    |> String.downcase
    |> handle_direct_command(sender, chat)
  end

  def handle_command(direction, sender, _chat) when direction in @directions do
    DebugLogger.handle_vote_cast(direction, sender)
    VoteManager.cast_vote(direction, sender)
  end

  def handle_command("u", sender, chat), do: handle_command("up", sender, chat)
  def handle_command("d", sender, chat), do: handle_command("down", sender, chat)
  def handle_command("l", sender, chat), do: handle_command("left", sender, chat)
  def handle_command("r", sender, chat), do: handle_command("right", sender, chat)

  # "I want that chatbot to react to WTF" -- BattlesnakeOfficial
  def handle_command("wtf", _sender, _chat) do
    ChatSpeaker.handle_wtf
  end

  # Ignore anything that isn't a valid command
  def handle_command(_command, _sender, _chat), do: nil

  def handle_direct_command(@chat_enable_command, sender, _chat) do
    if admin?(sender) do
      DebugLogger.handle_chat_speaker_enabled(sender)
      ChatSpeaker.enable()
    end
  end

  def handle_direct_command(@chat_disable_command, sender, _chat) do
    if admin?(sender) do
      DebugLogger.handle_chat_speaker_disabled(sender)
      ChatSpeaker.disable()
    end
  end

  # Ignore anything that isn't a valid direct command
  def handle_direct_command(_command, _sender, _chat), do: nil

  defp admin?(chat_user) do
    Application.get_env(:chatsnek, :twitch)
    |> Keyword.fetch!(:admins)
    |> MapSet.member?(String.downcase(chat_user))
  end
end
