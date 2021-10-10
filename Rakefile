require "html/proofer"

task :default => [:test]

task :test do
  sh "bundle exec jekyll build --config _config.yml"

  html_proofer_options = {
    alt_ignore: [/tumblr_files\/tumblr_/],
    check_html: true,
    disable_external: true,
  }
  HTML::Proofer.new("./_site", html_proofer_options).run
end
