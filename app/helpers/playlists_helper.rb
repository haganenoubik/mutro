module PlaylistsHelper
  def mood_radio_color(mood_name)
    case mood_name
    when '選択しない'
      'checked:bg-slate-300'
    when '都会的'
      'checked:bg-violet-300'
    when '気分を上げる'
      'checked:bg-red-300'
    when 'リラックス'
      'checked:bg-emerald-300'
    when '懐かしい'
      'checked:bg-yellow-300'
    else
      'checked:bg-gray-300'
    end
  end
end
