defmodule ChatSnek.ChatSpeaker.State do
  defstruct [enabled: false]

  alias __MODULE__

  def new do
    %State{}
  end

  def enable(%State{} = state) do
    %State{state | enabled: true}
  end

  def disable(%State{} = state) do
    %State{state | enabled: false}
  end

  def enabled?(%State{enabled: enabled}), do: enabled
end
