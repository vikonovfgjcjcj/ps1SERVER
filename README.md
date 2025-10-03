Для создания локального веб-сервера с собственным доменом на Windows, выполните следующие шаги:

### Шаг 1: Создание PS1-скрипта

1. Откройте **Блокнот**
2. Вставьте следующий код:

```powershell
# Настройка порта и директории
$Port = 8080
$StaticDir = "./public"

# Создание HTTP-слушателя
$Listener = New-Object System.Net.HttpListener
$Listener.Prefixes.Add("http://localhost:$Port/")
$Listener.Start()

# Проверка запуска
If ($Listener.IsListening) {
    Write-Host "Сервер запущен на порту $Port"
} Else {
    Write-Host "Ошибка при запуске сервера"
}

# Функция для отправки ответов
Function Reply {
    Param(
        [System.Net.HttpListenerResponse]$Response,
        [int]$StatusCode,
        [string]$Content
    )
    $Buffer = [System.Text.Encoding]::UTF8.GetBytes($Content)
    $Response.StatusCode = $StatusCode
    $Response.ContentLength64 = $Buffer.Length
    $Response.OutputStream.Write($Buffer, 0, $Buffer.Length)
    $Response.OutputStream.Close()
