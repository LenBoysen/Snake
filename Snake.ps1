# Simple Snake Game in PowerShell

$Width = 20
$Height = 10
$Snake = @((0,0))
$Food = @{}
$Direction = "Right"
$Score = 0
$GameOver = $false

function Clear-Console {
    Clear-Host
}

function Draw-Game {
    Clear-Console
    for ($y = 0; $y -lt $Height; $y++) {
        for ($x = 0; $x -lt $Width; $x++) {
            if ($Snake -contains ($x, $y)) {
                Write-Host -NoNewline "O"
            }
            elseif ($Food.ContainsKey("$x,$y")) {
                Write-Host -NoNewline "*"
            }
            else {
                Write-Host -NoNewline " "
            }
        }
        Write-Host ""
    }
    Write-Host "Score: $Score"
}

function Spawn-Food {
    $x = Get-Random -Minimum 0 -Maximum $Width
    $y = Get-Random -Minimum 0 -Maximum $Height
    $Food["$x,$y"] = $true
}

function Update-Snake {
    $headX, $headY = $Snake[0]
    switch ($Direction) {
        "Up" { $headY-- }
        "Down" { $headY++ }
        "Left" { $headX-- }
        "Right" { $headX++ }
    }

    if ($headX -lt 0 -or $headX -ge $Width -or $headY -lt 0 -or $headY -ge $Height) {
        $GameOver = $true
        return
    }

    $newHead = $headX, $headY
    if ($Food.ContainsKey("$headX,$headY")) {
        $Score++
        Spawn-Food
    }
    else {
        $Snake = $Snake[0..($Snake.Count - 2)]
    }

    $Snake = $newHead + $Snake
}

Spawn-Food
Draw-Game

while (-not $GameOver) {
    if (Console.KeyAvailable) {
        $Key = [System.Console]::ReadKey($true).Key
        switch ($Key) {
            "UpArrow" {
                if ($Direction -ne "Down") {
                    $Direction = "Up"
                }
            }
            "DownArrow" {
                if ($Direction -ne "Up") {
                    $Direction = "Down"
                }
            }
            "LeftArrow" {
                if ($Direction -ne "Right") {
                    $Direction = "Left"
                }
            }
            "RightArrow" {
                if ($Direction -ne "Left") {
                    $Direction = "Right"
                }
            }
        }
    }
    
    Update-Snake
    Draw-Game
    Start-Sleep -Milliseconds 100
}

Write-Host "Game Over. Your Score: $Score"
