# ��������� ����� � ����������
$Port = 8080
$StaticDir = "./public"

# �������� HTTP-���������
$Listener = New-Object System.Net.HttpListener
$Listener.Prefixes.Add("http://localhost:$Port/")
$Listener.Start()

# �������� �������
If ($Listener.IsListening) {
    Write-Host "������ ������� �� ����� $Port"
} Else {
    Write-Host "������ ��� ������� �������"
}

# ������� ��� �������� �������
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
    $Response.Close()
}

# �������� ���� ��������� ��������
While ($Listener.IsListening) {
    $Context = $Listener.GetContext()
    $Request = $Context.Request
    $Response = $Context.Response
    
    # ������������ ������
    $FilePath = $Request.Url.LocalPath
    
    # ���������� ��� �����
    $Extension = [System.IO.Path]::GetExtension($FilePath)
    Switch ($Extension) {
        ".html" {$MimeType = "text/html"}
        ".css" {$MimeType = "text/css"}
        ".js" {$MimeType = "text/javascript"}
        ".png" {$MimeType = "image/png"}
        ".jpg" {$MimeType = "image/jpg"}
        ".gif" {$MimeType = "image/gif"}
        Default {$MimeType = "application/octet-stream"}
    }
    
    Try {
        $FileStream = [System.IO.File]::OpenRead("$StaticDir$FilePath")
        $Response.ContentLength64 = $FileStream.Length
        $Response.ContentType = $MimeType
        $FileStream.CopyTo($Response.OutputStream)
    } Catch {
        Reply $Response 404 "�������� �� �������"
    }
    $Response.Close()
}
