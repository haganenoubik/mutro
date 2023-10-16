module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
  ],
  daisyui: {
    themes: ["bumblebee"],
  },
  plugins: [require("daisyui")]
}
