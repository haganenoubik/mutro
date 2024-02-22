module ApplicationHelper
  def default_meta_tags
    {
      site: 'Mutro',
      title: 'プレイリスト作成・シェアサービス',
      reverse: true,
      charset: 'utf-8',
      description: 'Mutroはプレイリストを作成・シェア・視聴できるサービスです。',
      keywords: 'Spotify,プレイリスト,音楽,シェア,視聴',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('mutro_ogp.png'),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@',
        image: image_url('mutro_ogp.png')
      }
    }
  end
end
