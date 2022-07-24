#NoEnv
#SingleInstance Force 

class Commands 
{
	static logPath := A_WorkingDir . "\fg-command.log.ini"
	static logEnabled := false
	; 로그 
	
	static down := " down" 
	static up := " up"
	; 위/아래
	
	static list := Array()
	static arrow5 := ""
	; 중립 방향이므로 설정하지 말것 
	
	static map := Object()
	;

	static arrow2 := "s"
	static arrow4 := "a"
	static arrow6 := "d"
	static arrow8 := "w"
	; 기본 방향 설정 

	static buttonL := "u"
	static buttonM := "i"
	static buttonH := "o"
	static buttonU := "j"
	static buttonAB := "p"
	static buttonG := ";"
	; 버튼 설정 

	static timer := 0
	; 타이머 
	
	init() 
	{
		Commands.map["arrow4down"] := "{" . Commands.arrow4 . " down}" 
		Commands.map["arrow4up"] := "{" . Commands.arrow4 . " up}" 
		Commands.map["arrow6down"] := "{" . Commands.arrow6 . " down}" 
		Commands.map["arrow6up"] := "{" . Commands.arrow6 . " up}" 
		Commands.map["arrow2down"] := "{" . Commands.arrow2 . " down}" 
		Commands.log("Commands.map['arrow2down'] is " . Commands.map["arrow2down"], "init")
		Commands.map.arrow2up := "{" . Commands.arrow2 . " up}" 
		Commands.map["arrow8down"] := "{" . Commands.arrow8 . " down}" 
		Commands.map["arrow8up"] := "{" . Commands.arrow8 . " up}" 
		Commands.log("4방향 설정", "init")
		
		Commands.map["arrow1down"] := Commands.map["arrow4down"] . Commands.map["arrow2down"]
		Commands.map["arrow1up"] := Commands.map["arrow4up"] . Commands.map["arrow2up"]
		Commands.map["arrow3down"] := Commands.map["arrow6down"] . Commands.map["arrow2down"]
		Commands.map["arrow3up"] := Commands.map["arrow6up"] . Commands.map["arrow2up"]
		Commands.map["arrow7down"] := Commands.map["arrow4down"] . Commands.map["arrow8down"]
		Commands.map["arrow7up"] := Commands.map["arrow4up"] . Commands.map["arrow8up"]
		Commands.map["arrow9down"] := Commands.map["arrow9down"] . Commands.map["arrow8down"]
		Commands.map["arrow9up"] := Commands.map["arrow9up"] . Commands.map["arrow8up"]
		Commands.log("대각 설정", "init")
		
		Commands.map["buttonLdown"] := "{" . Commands.buttonL . " down}" 
		Commands.map["buttonLup"] := "{" . Commands.buttonL . " up}" 
		Commands.map["buttonMdown"] := "{" . Commands.buttonM . " down}" 
		Commands.map["buttonMup"] := "{" . Commands.buttonM . " up}" 
		Commands.map["buttonHdown"] := "{" . Commands.buttonH . " down}" 
		Commands.map["buttonHup"] := "{" . Commands.buttonH . " up}" 
		Commands.map["buttonUdown"] := "{" . Commands.buttonU . " down}" 
		Commands.map["buttonUup"] := "{" . Commands.buttonU . " up}" 
		Commands.map["buttonABdown"] := "{" . Commands.buttonAB . " down}" 
		Commands.map["buttonABup"] := "{" . Commands.buttonAB . " up}" 
		Commands.map["buttonGdown"] := "{" . Commands.buttonG . " down}" 
		Commands.map["buttonGup"] := "{" . Commands.buttonG . " up}" 
		Commands.log("버튼 설정", "init")
		
		Commands.list.Push(Commands.arrow4)
		Commands.list.Push(Commands.arrow6)
		; 좌우 먼저 
		Commands.log("arrow2 is " . arrow2, "init")
		Commands.log("Commands.arrow2 is " Commands.arrow2, "init")
		pushed := Commands.list.Push(Commands.arrow2)
		Commands.log("pushed is " pushed, "init")
		Commands.log("Commands.list[1] is " . Commands.list[1], "init")
		Commands.list.Push(Commands.arrow8)
		;Commands.list.Push(Commands.arrow1)
		;Commands.list.Push(Commands.arrow3)
		;Commands.list.Push(Commands.arrow7)
		;Commands.list.Push(Commands.arrow9)
		Commands.list.Push(Commands.buttonL)
		Commands.list.Push(Commands.buttonM)
		Commands.list.Push(Commands.buttonH)
		Commands.list.Push(Commands.buttonU)
		Commands.list.Push(Commands.buttonAB)
		Commands.list.Push(Commands.buttonG)
		
		Commands.log("run in for each", "init")
		For idx, each in Commands.list 
		{
			Commands.log(idx . "-th command is " . each, "init")
		}
		
	}
	
	log(ByRef message, ByRef name) 
	{
		if (Commands.logEnabled) 
		{
			IniWrite, % message, % Commands.logPath, % name, % name "-" A_TickCount
			Sleep 1
		}
	}

	resetTimer() 
	{
		Commands.timer := A_TickCount
		; 타이머 리셋
	}

	get_ms(ByRef frames) 
	{
		return frames * 1000 / 60 
		; frame - ms 변환 
	}

	command(ByRef arrows, ByRef buttons, ByRef frames := 0)
	{
		Commands.log("arrows is " . arrows, "command")
		Commands.resetTimer()
		
		composed := arrows . buttons 
		Commands.log(composed, "command")
		SendInput %composed%
		; 커맨드 입력 
		remain := Commands.get_ms(frames) - (A_TickCount - Commands.timer)
		if remain < 0
		{
			Commands.log("process too long ", "command")
			remain := -1
		}
		Commands.log("remain is " . remain, "command")
		Sleep Floor(remain)
		; 남은 시간만큼 대기 
		; 특정 프레임만큼 커맨드 입력 
	}
	
	resetCommand() 
	{
		releases := ""
		For key, downed in Object(Commands.buttonL, Commands.buttonLdowned, Commands.buttonM, Commands.buttonMdowned, Commands.buttonH, Commands.buttonHdowned, Commands.buttonU, Commands.buttonUdowned, Commands.buttonAB, Commands.buttonABdowned, Commands.buttonG, Commands.buttonGdowned)
		{
			if (GetKeyState(key)) 
			{
				;Commands.command("", "{" . key . Commands.up . "}", 0) 
				releases := releases . "{" . key . Commands.up . "}"
			}
		}
		; 버튼 떼기 
		For key, downed in Object(Commands.arrow4, Commands.arrow4downed, Commands.arrow6, Commands.arrow6downed, Commands.arrow2, Commands.arrow2downed, Commands.arrow8, Commands.arrow8downed)
		{
			if (GetKeyState(key)) 
			{
				;Commands.command( "{" . key . Commands.up . "}", "", 0) 
				releases := releases . "{" . key . Commands.up . "}"
			}
		}
		SendInput %releases% 
		; 방향 떼기 
	}
	
	crunch1sec()
	{
		Commands.command(Commands.map.arrow2down, "", 60) 
		Commands.log("60프레임 동안 앉기", "F1")
		Commands.command(Commands.map.arrow2up, "", 1) 
		Commands.log("1프레임 동안 앉기 취소", "F1")
	}
	
	testResetCommands() 
	{
		Commands.command(Commands.map.arrow2down, "", 60) 
		Commands.log("60프레임 동안 앉기", "F1")
		Commands.resetCommand()
		Commands.log("리셋", "F1")
	}
	
	highJump()
	{
		Commands.command(Commands.map.arrow2down, "", 1) 
		Commands.command(Commands.map.arrow2up, "", 1) 
		Commands.command(Commands.map.arrow8down, "", 1) 
		Commands.resetCommand()
	}
	
	dash() 
	{
		Commands.log("N6N6", "dash")
		Commands.command(Commands.arrow5, "", 1) 
		Commands.command(Commands.map.arrow6down, "", 1) 
		Commands.resetCommand()
		Commands.command(Commands.arrow5, "", 7) 
		Commands.command(Commands.map.arrow6down, Commands.map.buttonMdown, 2) 
		;Commands.command("", Commands.map.buttonMdown, 2) 
	}
	
	hadou() 
	{
		Commands.resetCommand()
		Commands.command(Commands.map.arrow2down, "", 1) 
		Commands.command(Commands.map.arrow3down, "", 8) 
		Commands.command(Commands.map.arrow2up, Commands.map.buttonLdown, 1) 
		;Commands.command(Commands.arrow6, 1) 
		Commands.resetCommand()
		; 10프레임 이내 236 입력
	}
	
	c22() 
	{
		Commands.command(Commands.map.arrow2down, "", 1) 
		Commands.resetCommand()
		Commands.command("", "", 7) 
		Commands.command(Commands.map.arrow2down, "", 7) 
		Commands.command("", Commands.map.buttonLdown, 2) 
	}
	
	shoryu() 
	{
		Commands.resetCommand()
		Commands.command(Commands.map.arrow6down, "", 1) 
		Commands.resetCommand()
		Commands.command(Commands.map.arrow2down, "", 12) 
		Commands.command(Commands.map.arrow6down, Commands.map.buttonLdown, 1) 
		;Commands.command(Commands.map.arrow3down, Commands.map.buttonLdown, 1) 
		Commands.resetCommand()
		; ?프레임 이내 623 입력
	}
	
	c2369() 
	{
		Commands.resetCommand()
		Commands.command(Commands.map.arrow1down, "", 2) 
		Commands.command(Commands.map.arrow4up, "", 1) 
		; Commands.command(Commands.map.arrow2down, "", 1) 
		Commands.command(Commands.map.arrow3down, "", 1) 
		Commands.command(Commands.map.arrow2up, "", 1) 
		Commands.command(Commands.map.arrow8down, "", 6) 
		Commands.command("", Commands.map.buttonLdown, 2) 
		Commands.resetCommand()
	}
	
	c9236() 
	{
		Commands.command(Commands.map.arrow8down, "", 5) 
		Commands.resetCommand()
		Commands.command(Commands.map.arrow2down, "", 1) 
		Commands.command(Commands.map.arrow3down, "", 8) 
		Commands.command(Commands.map.arrow2up, Commands.map.buttonLdown, 2) 
	}
	
	c41236()
	{
		Commands.command(Commands.map.arrow1down, "", 1) 
		;Commands.command(Commands.map.arrow2down, "", 1) 
		Commands.command(Commands.map.arrow4up, "", 1) 
		Commands.command(Commands.map.arrow6down, "", 8) 
		Commands.command(Commands.map.arrow2up, Commands.map.buttonUdown, 2) 
	}
	
	c360() 
	{
		Commands.command(Commands.map.arrow4down, "", 2) 
		Commands.command(Commands.map.arrow2down, "", 1) 
		Commands.command(Commands.map.arrow4up, "", 1) 
		Commands.command(Commands.map.arrow6down, "", 1) 
		Commands.command(Commands.map.arrow2up, "", 8) 
		Commands.command(Commands.map.arrow8down, Commands.map.buttonLdown, 2) 
	}
	
	c4hold6() 
	{
		Commands.command(Commands.map.arrow4down, "", 53) 
		Commands.resetCommand()
		Commands.command(Commands.map.arrow6down, Commands.map.buttonLdown, 2) 
	}
	
	c2hold8() 
	{
		Commands.command(Commands.map.arrow2down, "", 52) 
		Commands.resetCommand()
		Commands.command(Commands.map.arrow8down, Commands.map.buttonLdown, 2) 
	}
	
	blockInputAndRelease(ByRef name)
	{
		BlockInput, On
		Commands.resetCommand()
		Commands.log(name, "blockInputAndRelease")
		Commands[name]()
		Commands.resetCommand()
		BlockInput, Off
	}
}

; executes 
Commands.init()

; key maps
*F1 Up::
{
	;Commands.log(Commands.dash.Name, "F1")
	Commands.blockInputAndRelease("c2hold8")
}
return 

*F2 Up::
{
	Commands.testResetCommands()
}
return 

; 확인 패턴 
;	29 
;	66 
;	236
;	623
;	214
;	22 
;	632146
;	236236
;	2369
;	9236
;	229 
;	360 
;	2362369
;	720

*F7 Up::
{
	Send {d down}{w down}
	Sleep 1000 
	Send {w up}{d up} 
}
return 

F8::d

F10::Pause

F11::Suspend

F12::Reload

Pause::ExitApp

