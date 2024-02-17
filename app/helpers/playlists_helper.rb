module PlaylistsHelper
  def mood_radio_color(mood_name)
    case mood_name
    when '選択しない'
      'checked:bg-slate-800'
    when '都会的'
      'checked:bg-violet-800'
    when '気分を上げる'
      'checked:bg-green-500'
    when 'リラックス'
      'checked:bg-blue-500'
    when '懐かしい'
      'checked:bg-red-500'
    else
      'checked:bg-gray-500'
    end
  end
end
