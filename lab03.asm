TITLE	febsavings
; Programmer:	Marcus Ross
; Due:		7 Mar,  2014
; Description:	This program uses hardcoded monetary values concerning the user's finances--specifically, income and expenses--to determine how much they are able to stow as savings.

	.MODEL SMALL
	.386
	.STACK 64
;==========================
	.DATA
hrsTot	DW	52	; total hours worked
hrsReg	DW	40	; regular hours
wage	DW	14	; hourly rate
overtime	DW	2	; overtime factor
taxFed	DW	85	; federal taxes
taxState	DW	60	; state taxes
tsa	DW	75	; TSA contribution
cable	DW	82	; cable bill
phone	DW	80	; phone bill
utils	DW	302	; utility bill
rent	DW	230	; rent
savings	DW	290	; savings from previous month
grossPay	DW	?	; gross pay
netPay	DW	?	; new pay
;==========================
	.CODE
Main	PROC	NEAR
	mov	ax, @data	; init data
	mov	ds, ax		; segment register

	call	GetGross
	call	GetNet
	call	Getsavs

	mov	ax, 4c00h	; return code 0
	int	21h

Main	ENDP
;==========================
GetGross	PROC	NEAR
	mov	ax, hrsReg	; prep to multiply regular hours
	mov	bx, hrsTot	; prep to subtract from total hours
	sub	bx, ax		; total hours - reg hours = overtime hours
	imul	bx, overtime	; overtime hours * overtime factor = effective overtime hours
	add	ax, bx		; regular hours + overtime hours = effective total hours
	imul	wage		; effective hours * wage = gross pay
	mov	grossPay, ax	; put gross pay in memory so I can circle it
	ret
	ENDP
;==========================
GetNet	PROC	NEAR
	sub	ax, taxFed	; subtract federal tax from gross pay, still in ax
	sub	ax, taxState	; subtract state tax
	sub	ax, tsa		; subtract TSA amount and now, ax = net pay
	mov	netPay, ax	; put net pay in memory so I can circle it
	ret
	ENDP
;==========================
GetSavs	PROC	NEAR
	sub	ax, cable	; subtract cable from net pay, still in ax
	sub	ax, phone	; subtract phone bill
	sub	ax, utils	; subtract utility bill
	sub	ax, rent		; subtract rent
	add	ax, savings	; add initial savings to month savings
	mov	savings, ax	; replace initial savings in memory
	ret
	ENDP
;==========================
	END	Main