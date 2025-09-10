param(
  [string]$Url = $env:APP_URL
)
if (-not $Url) { $Url = "http://localhost:8080/HIT_GroupApp/index.jsp" }
try {
  $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 10
  if ($response.StatusCode -eq 200) {
    Write-Output "OK: $Url"
    exit 0
  } else {
    Write-Error "DOWN: $Url status=$($response.StatusCode)"
    exit 1
  }
} catch {
  Write-Error "ERROR reaching $Url : $($_.Exception.Message)"
  exit 1
}
