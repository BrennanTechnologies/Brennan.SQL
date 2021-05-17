#Get public and private function definition files.
$PublicPath = "$PSScriptRoot\Public\*.ps1"
$PrivatePath = "$PSScriptRoot\Private\*.ps1"

# Check & Import Public
If (   $True -eq [Boolean]$(Test-Path -Path $PublicPath -ErrorAction SilentlyContinue)   ) {
    [Array]$Public  = $(Get-ChildItem -Path $PublicPath -ErrorAction SilentlyContinue)
    If ($Null -ne $Public) {
        ForEach($Import in $Public | Sort-Object -Descending -Property Name) {
            Try
            {
                . $Import.FullName #| Out-Null
            }
            Catch
            {
                Write-Warning -Message "(Public Import): Failed to import function $($Import.Fullname): $_"
            }
        }
    }
    Export-ModuleMember -Function $Public.Basename -Alias *
}

# Check & Import Private
If (   $True -eq [Boolean]$(Test-Path -Path $PrivatePath -ErrorAction SilentlyContinue)   ) {
    [Array]$Private = $(Get-ChildItem -Path $PrivatePath -ErrorAction SilentlyContinue)
    If ($Null -ne $Private) {
        ForEach($Import in $Private) {
            Try
            {
                . $Import.FullName | Out-Null
            }
            Catch
            {
                Write-Warning -Message "(Private Import): Failed to import function $($Import.Fullname): $_"
            }
        }
    }
}
