# Script para obtener la clave de activación de Windows
function Get-WindowsProductKey {
    $Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    $DigitalProductId = (Get-ItemProperty -Path $Path).DigitalProductId

    # Conversión de la clave de producto
    $Key = ""
    $Chars = "BCDFGHJKMPQRTVWXY2346789"
    $IsN = ($DigitalProductId[66] / 6) -bor 1
    $KeyPart1 = 0
    $KeyPart2 = 24
    for ($i = 24; $i -ge 0; $i--) {
        $KeyPart1 = 0
        for ($j = 14; $j -ge 0; $j--) {
            $KeyPart1 = ($KeyPart1 * 256) -bxor $DigitalProductId[$j + 52]
            $DigitalProductId[$j + 52] = [math]::Floor($KeyPart1 / 24)
            $KeyPart1 = $KeyPart1 % 24
        }
        $Key = $Chars[$KeyPart1] + $Key
        if (($i % 5 -eq 0) -and ($i -ne 0)) {
            $Key = "-" + $Key
        }
    }
    return $Key
}

# Llamar a la función y mostrar la clave
$key = Get-WindowsProductKey
Write-Output "La clave de activacion de Windows es: $key"
