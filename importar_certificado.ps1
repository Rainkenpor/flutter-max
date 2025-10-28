# Script para importar el certificado corporativo a Java
# Este script debe ejecutarse como ADMINISTRADOR

Write-Host "=== Importando Certificado Corporativo a Java ===" -ForegroundColor Cyan
Write-Host ""

# Exportar el certificado de Netskope desde el almacen de Windows
Write-Host "1. Exportando certificado de Netskope..." -ForegroundColor Yellow
$cert = Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object { $_.Subject -like "*Netskope*" }
$certPath = "$env:TEMP\netskope_cert.cer"
Export-Certificate -Cert $cert -FilePath $certPath -Type CERT | Out-Null

if (Test-Path $certPath) {
    Write-Host "   Certificado exportado a: $certPath" -ForegroundColor Green
} else {
    Write-Host "   Error al exportar certificado" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Importar al keystore de Java de Android Studio
Write-Host "2. Importando certificado a Java keystore..." -ForegroundColor Yellow
$javaKeystorePath = "C:\Program Files\Android\Android Studio\jbr\lib\security\cacerts"
$keytoolPath = "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe"

if (-not (Test-Path $keytoolPath)) {
    Write-Host "   No se encuentra keytool en: $keytoolPath" -ForegroundColor Red
    exit 1
}

# Verificar si ya existe el alias
Write-Host "   Verificando si el certificado ya existe..." -ForegroundColor Gray
$existingCert = & $keytoolPath -list -keystore $javaKeystorePath -storepass changeit -alias netskope_cert 2>&1

if ($existingCert -notlike "*does not exist*" -and $existingCert -notlike "*no existe*") {
    Write-Host "   El certificado ya existe. Eliminando..." -ForegroundColor Yellow
    & $keytoolPath -delete -alias netskope_cert -keystore $javaKeystorePath -storepass changeit 2>&1 | Out-Null
}

# Importar el certificado
Write-Host "   Importando certificado..." -ForegroundColor Gray
$importResult = & $keytoolPath -import -trustcacerts -alias netskope_cert -file $certPath -keystore $javaKeystorePath -storepass changeit -noprompt 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "   Certificado importado correctamente" -ForegroundColor Green
} else {
    Write-Host "   Error al importar certificado:" -ForegroundColor Red
    Write-Host "   $importResult" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Tambien importar al JDK de Microsoft si existe
$msJdkPath = "C:\Program Files\Microsoft\jdk-21.0.6.7-hotspot\lib\security\cacerts"
if (Test-Path "C:\Program Files\Microsoft\jdk-21.0.6.7-hotspot\bin\keytool.exe") {
    Write-Host "3. Importando certificado a Microsoft JDK..." -ForegroundColor Yellow
    $msKeytool = "C:\Program Files\Microsoft\jdk-21.0.6.7-hotspot\bin\keytool.exe"
    
    # Verificar si ya existe
    $existingCertMs = & $msKeytool -list -keystore $msJdkPath -storepass changeit -alias netskope_cert 2>&1
    if ($existingCertMs -notlike "*does not exist*" -and $existingCertMs -notlike "*no existe*") {
        & $msKeytool -delete -alias netskope_cert -keystore $msJdkPath -storepass changeit 2>&1 | Out-Null
    }
    
    $importResultMs = & $msKeytool -import -trustcacerts -alias netskope_cert -file $certPath -keystore $msJdkPath -storepass changeit -noprompt 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   Certificado importado correctamente a Microsoft JDK" -ForegroundColor Green
    } else {
        Write-Host "   No se pudo importar a Microsoft JDK (puede no ser necesario)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=== Proceso Completado ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ahora puedes ejecutar: flutter clean; flutter run" -ForegroundColor Green
Write-Host ""
Read-Host "Presiona Enter para salir"
