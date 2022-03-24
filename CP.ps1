$filepath = "C:\Links\urls.txt"

$http = [System.Net.HttpListener]::new()
$http.Prefixes.Add("http://+:80/")
$http.Start()

while($http.IsListening){

    $context = $http.GetContext()
    $url = $context.Request.RawUrl
    $method = $context.Request.HttpMethod
    
    if($method -eq "GET" -and $url -eq "/urls.txt"){
        $content = Get-Content -Encoding Byte -Path ($filePath)
        $Context.Response.ContentType="application/octet-stream"
        $Context.Response.ContentEncoding=[System.Text.Encoding]::Default
        $Context.Response.ContentLength64=$Content.Length
        $Context.Response.KeepAlive=$false
        $Context.Response.StatusCode=200
        $Context.Response.StatusDescription="OK"
        $Context.Response.OutputStream.Write($Content, 0, $Content.Length)
        $Context.Response.OutputStream.Close()
        $Context.Response.Close()
    } elseif($method -eq "GET" -and $url -eq "/stop"){
    
        [string]$html = "Stopped!"
        $context.Response.StatusCode = 200
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close()
        $http.Stop()
    
    }

}