ImageListID := IL_Create(3)
IL_Add(ImageListID, "icons\MenuItem.bmp")
IL_Add(ImageListID, "icons\Separator.bmp")
IL_Add(ImageListID, "icons\Menu.bmp")
fail:=true
while(fail)  ;Input Menu Name, cancel or close will exit the program
{
	InputBox,MainMenu,Input menu name,Please input the menu name`nor click cancel to quit,,250,140
	fail:=ErrorLevel
	if(fail)
		exitapp
	if(MainMenu=="")
	{
		MsgBox, 4144, Input error, The menu name can't be blank!
		fail:=True
	}
}

;===============================Gui Codes Begin=================================================

gui +alwaysontop
;gui,font,,微软雅黑
Gui, Add, Text, x20 y12 w125 , MenuItem Name:
Gui,add,edit,x130 y10 w95 vName gCheck h22 HwndhName,

Gui, Add, Text, x20 y40  , Select item and insert into the list

Gui, Add, DropDownList, x20 y67 w120 cWhite vItemType  AltSubmit gItemSelect, MenuItem|Separator
Gui, Add, Button, x160 y65 w59 h25  GInsert +Disabled vInsert, Insert

Gui, Add, Button, x230 y105 w30 h30 HwndUp gOnMove vu, 
ILButton(Up,"icons\Up.ico",24,24,"center")

Gui, Add, Button, x230 y145 w30 h30 HwndDown gOnMove vd,
ILButton(Down,"icons\Down.ico",24,24,"center")

Gui, Add, Button, x230 y185 w30 h30 HwndDel gDel vDel, 
ILButton(Del,"icons\Del.ico",24,24,"center")

Gui, Add, TreeView, HwndTree x20 y105 w200 h310 vlist ImageList%ImageListID% gTreeHandle,
;TVX("List", "TreeHandle","EditOnInsert")

;-----------Code Groupbox-----------------
gui,add,GroupBox,x230 y245 w290 h170,Code:
gui,add,edit,x240 y265 w270 h140 vCode, 
gui,add,button,x530 y255 gCode,Gen
gui,add,button,x530 y305 gTest,Test

;-----------Menu tab-----------------
Gui, Add, Tab2, x294 y10 w260 h230 vTab,Menu Property|MenuItem Property
gui,add,text,x304 y50 ,Color:
Gui,add,Edit,vColor x390 y47 w80 h22 +Center,
gui,add,button,x473 y47 h23 w15 gColor ,▼
gui,add,text,x304 y80,Menu Name:
Gui,add,Edit,vMainName x390 y77 w80 h22 +Center,

;-----------MenuItem tab-----------------
Gui, Tab, MenuItem Property

;=============================Menu Item Property Panel Array============================================
ItemPanel:="lbMenuName|MenuItemName|lbLabel|Label|Checked|Enabled|lbIcon|Icon|btIcon|picIcon"
SubMenuPanel:="lbMenuName|MenuItemName|lbSubMenu|SubName"
;=============================ItemPanel=======================================================
Gui,add,text,vlbMenuName x304 y48,MenuItemName:
gui,add,edit,vMenuItemName x405 y46 +Center,

Gui,add,text,vlbLabel x304 y88,Label:
gui,add,edit,vlabel x355 y86 +Center,


gui,add,CheckBox,vChecked x304 y126 gOnChange,Checked
gui,add,CheckBox,vEnabled x400 y126 gOnChange,Enabled

gui,add,text,x304 y160 vlbIcon,Icon:
Gui,add,Edit,vIcon x345 y156 w140 h22,
gui,add,button,x495 y156 h23 w25 gIcon vbtIcon,…

gui,add,pic,x304 y190 h36 w36 vpicIcon ,

;=============================SubMenuPanel======================================================================

gui,add,text,x304 y88 vlbSubMenu,SubMenu Name:
gui,add,edit,x410 y86 vSubName +Center,

OnMessage(0x101,"KeyEnter")
Gui, Show, w580 h425,Context Menu Builder


;===========================Gui Codes End===================================================

;===========================================================================================
GuiControl, Choose, ItemType, 1
;~ root:=
TV_Modify(root:=TV_Add(MainMenu,"","Icon3"),"Select")
GuiControl,,MainName,%MainMenu%
;===========================================================================================

;Menu Property
ItemProperty:=ComObjArray(0xc,8)
ItemProperty[0]:="" ;MenuItem Name
ItemProperty[1]:="" ;Parent
ItemProperty[2]:=false ;Is SubMenu
ItemProperty[3]:=false ;Is Seperator
ItemProperty[4]:="" ;Menu Label Text or SubMenu
ItemProperty[5]:=false ;Checked
ItemProperty[6]:=True ;Enabled
ItemProperty[7]:="" ;Icon

ItemsProperty:=ComObjArray(0xc,0)  ;This array store MenuItem array
return

TreeHandle:
;~ if(root!=TV_GetSelection())
	;~ GuiControl,choose,Tab,2
;~ else
	;~ GuiControl,choose,Tab,1
if(TV_GetChild(TV_GetSelection())==0 and TV_GetSelection()!=root and TVX_GetText(TV_GetSelection())!="")
{
	i:=FindItem(ItemsProperty,TVX_GetText(TV_GetSelection()),it)
	tp:=GetProperty(it,"Checked")
	guicontrol,,Checked,%tp%
	tp:=GetProperty(it,"Enabled")
	GuiControl,,Enabled,%tp%
	tp:=GetProperty(it,"Icon")
	GuiControl,,Icon,%tp%
	loop,parse,tp,`:
	{
		if(!File)
			File:=A_LoopField
		else
			Index:=A_LoopField
	}
	Guicontrol,,picIcon,*Icon%Index% %File%
	tp:=TVX_GetText(TV_GetSelection())
	Guicontrol,,MenuItemName,%tp%
	PanelControl("SubMenuPanel","Hide")
	PanelControl("ItemPanel","Show")
	
}
else if(TV_GetChild(TV_GetSelection())!=0 and TV_GetSelection()!=root and TVX_GetText(TV_GetSelection())!="")
{
	TV_GetText(txt,TV_GetSelection())
	PanelControl("ItemPanel","Hide")
	PanelControl("SubMenuPanel","Show")
	GuiControl,,SubName,%txt%
	
}
else
{
	PanelControl("ItemPanel","Hide")
	PanelControl("SubMenuPanel","Hide")
}
if(TV_GetSelection()!=root)
	gosub,OnChange
return




Check:
gui,submit,nohide
if(Name!="" or ItemType==2)
	GuiControl,Enable,Insert
else
	GuiControl,Disable,Insert
return

ItemSelect:
gui,submit,nohide
if(ItemType==2)
{
	GuiControl,Disable,Name
	GuiControl,,Name,
	GuiControl,Enable,Insert
}
else
	GuiControl,Enable,Name
return

Insert:
gui,submit,nohide
TV_Modify(Parent:=TV_GetParent(MenuItemID:=TV_Add(Name,TV_GetSelection(),"Icon"+ItemType)),"Expand")
if(Parent!=root)
{
	FindItem(ItemsProperty,TVX_GetText(TV_GetSelection()),it)
	SetProperty(it,"IsSubMenu",true)
	PanelControl("ItemPanel","Hide")
	PanelControl("SubMenuPanel","Show")
	TV_GetText(txt,TV_GetSelection())
	SetProperty(it,"SubMenuName",txt)
	GuiControl,,SubName,%txt%	
}
ArrayExt_Insert(ItemsProperty,ItemsProperty.MaxIndex(),ItemProperty)
ItemsProperty[ItemsProperty.MaxIndex()][0]:=Name
DefaultProperty(ItemsProperty[ItemsProperty.MaxIndex()])
GuiControl,,Name,
return


Del:
if(TV_GetSelection()==root)
{
	MsgBox, 262192, Warning, Can't delete the root menu
	return
}
Gosub,DelChildren
ArrayExt_Del(ItemsProperty,FindItem(ItemsProperty,TVX_GetText(TV_GetSelection()),it))
TV_Delete(TV_GetSelection())
TV_Modify(Root,"Expand")
return

DelChildren:
Parent:=TV_GetSelection()
While(TV_GetChild(Parent))
{
	ArrayExt_Del(ItemsProperty,FindItem(ItemsProperty,TVX_GetText(TV_GetChild(Parent)),it))
	TV_Delete(TV_GetChild(Parent))	
}
return



OnMove:
i:=0
if(TV_GetChild(TV_GetParent(TV_GetSelection()))==TV_GetSelection() and A_GuiControl=="u")
{
	MsgBox, 262192, Warning, Can't move to the top!
	return
}
else if(TV_GetNext(TV_GetSelection())==0 and A_GuiControl=="d")
{
	MsgBox, 262192, Warning, Bottom Item can't move down!
	return
}
FindItem(ItemsProperty,TVX_GetText(TV_GetSelection()),it)
if(A_GuiControl=="u")
{
	TV_Modify(TV_GetPrev(TV_GetSelection()))
	TVX_Move(TV_GetSelection(),"d")
	tvit:=TV_GetNext(TV_GetSelection())
}
else
{
	TVX_Move(TV_GetSelection(),A_GuiControl)
	TV_Select("Down",1)
	tvit:=TV_GetSelection()	
}
if(TVX_GetText(tvit)=="")
	TV_Modify(tvit,"Icon2")
else
	TV_Modify(tvit,"Icon1")	

return



Code:
gui,-AlwaysOnTop
str:=""
labelRegion:=";----------labels-----------`n"
TVX_Walk(root,"Walk",Event,Item)
TV_GetText(rootName,root)
str:=SubStr(str,2)
if(Color!="")
	str=%str%`nMenu,%rootName%,Color,%Color%`n
str=%str%`nMenu,%rootName%,show`nreturn
guicontrol,,Code,%str%`n%labelRegion%


return

Walk:
TV_GetText(txt, Item)
if(Event=="I")
{
	if(TV_GetParent(Item)!=root)
	{
		FindItem(ItemsProperty,TVX_GetText(TV_GetParent(Item)),it)
		Menu:=GetProperty(it,"SubMenuName")
	}
	else
		Menu:=TVX_GetText(TV_GetParent(Item))
	FindItem(ItemsProperty,txt,it)
	if((tp:=GetProperty(it,"Label"))!="")
	{
		tp2=%txt%,%tp%
		labelRegion=%labelRegion%%tp%:`nreturn`n
	}
	else 
	{
		tp2=%txt%
		labelRegion=%labelRegion%%txt%:`nreturn`n
	}
	str=%str%`nMenu,%Menu%,Add,%tp2%	
	if(GetProperty(it,"Checked"))
		str=%str%`nMenu,%Menu%,Check,%txt%
	else if((Icon:=GetProperty(it,"Icon"))!="")
		str=%str%`nMenu,%Menu%,Icon,%txt%,%Icon%
	if(!GetProperty(it,"Enabled"))
		str=%str%`nMenu,%Menu%,Disable,%txt%
	
}
else if(Event=="E")
{
	Menu:=TVX_GetText(TV_GetParent(Item))
	FindItem(ItemsProperty,txt,it)
	SubMenu:=GetProperty(it,"SubMenuName")
	str=%str%`nMenu,%Menu%,Add,%txt%,:%SubMenu%
}
return

Test:
GuiControlGet,Code
if(Code!="")
	DynaRun(Code)
return


return




Color:
Menu,ColorMenu,Add,System
Menu,ColorMenu,Add,Web
Menu,ColorMenu,add,Customize
menu,ColorMenu,show
return
System:


return

Web:
return

Customize:
gui -alwaysontop
if(Dlg_Color(Color,WinExist(A)))
{
	GuiControl,,Color,%Color%
	Gui,Font,c%Color%
	GuiControl,Font,Color
}
gui +alwaysontop




return



Icon:
gui -alwaysontop
if(Dlg_Icon(IconFile,Index,WinExist(A)))
{
	GuiControl,,Icon,%IconFile%,%Index%
	GuiControlGet,Icon
	FindItem(ItemsProperty,TVX_GetText(TV_GetSelection()),it)
	SetProperty(it,"Icon",Icon)
	GuiControl,,picIcon,*Icon%Index% %IconFile%
}
gui +alwaysontop
return


return



OnChange:
gui,submit,nohide
FindItem(ItemsProperty,TVX_GetText(TV_GetSelection()),it)
SetProperty(it,"Checked",Checked)
if(checked)
{
	GuiControl,Disable,Icon
	GuiControl,Disable,btIcon
}
else
{
	GuiControl,Enable,Icon
	GuiControl,Enable,btIcon
}
SetProperty(it,"Enabled",Enabled)



return


GuiClose:
exitapp

GetProperty(Array,strProperty)
{
	MenuItemName:=0
	Parent:=1
	IsSubMenu:=2
	IsSeperator:=3
	label:=4
	SubMenuName:=4
	Checked:=5
	Enabled:=6
	Icon:=7
	ret:=%strProperty%
	return Array[ret]	
}

SetProperty(ByRef Array, strProperty,Value)
{
	MenuItemName:=0
	Parent:=1
	IsSubMenu:=2
	IsSeperator:=3
	label:=4
	SubMenuName:=4
	Checked:=5
	Enabled:=6
	Icon:=7
	ret:=%strProperty%
	Array[ret]:=Value
}

DefaultProperty(ByRef Item)
{
	SetProperty(Item,"Parent",TV_GetSelection())
	SetProperty(Item,"IsSeperator",GetProperty(Item,"MenuItemName")=="")	
}

FindItem(Array,strName,ByRef ItemRef)
{
	i:=Array.MinIndex()
	while(i<Array.MaxIndex()+1 and Array.MaxIndex()!=-1)
	{
		ItemRef:=Array[i]
		if(ItemRef[0]==strName)
			return i
		i++		
	}
	return -1	
}

KeyEnter(wParam, lParam, msg, hwnd)
{
	global ItemsProperty
	if(wParam==13)
	{
		if(A_GuiControl=="Name")
		{
			GuiControlGet,Name
			if(Name!="")
				gosub,Insert
		}
		else if(A_GuiControl=="MainName")
		{
			GuiControlGet,MainName
			if(MainName!="")
			{
				global root
				TV_Modify(root,"",MainName)
			}
		}
		else if(A_Guicontrol=="MenuItemName")
		{
			GuiControlGet,MenuItemName
			if(MenuItemName!="")
			{
				n:=FindItem(ItemsProperty,TVX_GetText(TV_GetSelection()),it)
				SetProperty(it,"MenuItemName",MenuItemName)
				TV_Modify(TV_GetSelection(),"",MenuItemName)
			}
		}
		else if(A_Guicontrol=="label")
		{
			GuiControlGet,label
			if(label!="")
			{
				FindItem(ItemsProperty,TVX_GetText(TV_GetSelection()),it)
				SetProperty(it,"label",label)
			}			
		}
		else if(A_Guicontrol=="SubName")
		{
			GuiControlGet,SubName
			if(SubName!="")
			{
				FindItem(ItemsProperty,TVX_GetText(TV_GetSelection()),it)
				SetProperty(it,"SubMenuName",SubName)
			}			
			
			
		}
	}
	return
}


TVX_GetText(TVItem)
{
	TV_GetText(str,TVItem)
	return str
}

InsertStr(ByRef str,pos,value)
{
	ret:=""
	if(pos==0)
	{	str=%value%%str%
		return
	}
	i:=1
	if(pos>StrLen(str))
		pos:=StrLen(str)
	Loop,parse,str,`
	{	
		if(i==pos)
			ret=%value%%ret%
		ret=%ret%%A_LoopField%
		i++
	}
	str:=ret	
}

PanelControl(Name,Mode)
{
	
	loop,parse,%Name%,`|
		guicontrol,%mode%,%A_LoopField%	
}

TV_Select(Direction,n)
{
	if(Direction=="Up")
		loop,%n%
		{
			Item:=TV_GetPrev(TV_GetSelection())
			TV_Modify(Item)
		}
	else
		loop,%n%
		{
			Item:=TV_GetNext(TV_GetSelection())
			TV_Modify(Item)
		}
	
}

#include inc\_Forms.ahk
#include inc\DynaRun.ahk
#include inc\TVX.ahk
#include inc\ILButton.ahk
#include inc\ArrayExt.ahk
#include inc\Dlg.ahk






