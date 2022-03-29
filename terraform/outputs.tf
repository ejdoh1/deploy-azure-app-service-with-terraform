output "api_url" {
  value = "https://${azurerm_windows_web_app.main.default_hostname}/weatherforecast"
}
