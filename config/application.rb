require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pitatto
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # 日時の扱い（db_design.md 意図8、CLAUDE.md「崩してはいけない原則」）
    #
    # 保存は UTC、表示は常に日本時間に固定する。閲覧者のタイムゾーンへは変換しない。
    # 日程調整は全員が同じ盤面を見て会話する共有物であり、人によって日付や時刻が
    # 変わると会話が成立しないため。
    #
    # config.time_zone を Tokyo にすると、Time.zone.now などアプリが扱う時刻が
    # 日本時間になり、データベースへ書き込む瞬間に UTC へ変換される。
    # active_record.default_timezone = :utc が、その保存側を UTC に固定している。
    config.time_zone = "Tokyo"
    config.active_record.default_timezone = :utc

    # config.eager_load_paths << Rails.root.join("extras")
  end
end
