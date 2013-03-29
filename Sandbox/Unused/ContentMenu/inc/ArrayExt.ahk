ArrayExt_Del(ByRef Array,Index)
{
   IsObj:=IsObject(Array[0])
   i:=0
   j:=0
   ret:=ComObjArray(0xc,Array.MaxIndex())
   while(i<Array.MaxIndex() and Array.MaxIndex()!=0)
   {
      if(j==Index)
      {
         j++
         continue
      }
      ret[i]:= IsObj? Array[j].Clone():StrGet(&tp:=Array[j])
      i++
      j++
   }
   Array:=ret.Clone()
}

ArrayExt_Swap(ByRef Array,Index1,Index2)
{
   IsObj:=IsObject(Array[0])   
   ret:=ComObjArray(0xc,Array.MaxIndex()+1)
   i:=0
   while(i<Array.MaxIndex()+1)
   {
      if(i==Index1)
         ret[i]:= IsObj? Array[Index2].Clone():StrGet(&tp:=Array[Index2])
      else if(i==Index2)
         ret[i]:= IsObj? Array[Index1].Clone():StrGet(&tp:=Array[Index1])
      else
         ret[i]:= IsObj? Array[i].Clone():StrGet(&tp:=Array[i])
      i++
   }
   Array:=ret.Clone()
}

ArrayExt_Insert(ByRef Array, Index, Object, Behind=true)
{
   IsObj:=IsObject(Object)
   i:=0
   j:=0
   ret:=ComObjArray(0xc,Array.MaxIndex()+2)
   if(Array.MaxIndex()==-1)
   {
      ret[0]:=IsObj? Object.Clone():Object
      Array:=ret.Clone()   
      return
   }
   while(i<Array.MaxIndex()+2)
   {
      if(Behind and i==Index+1)
      {
         ret[i]:=IsObj? Object.Clone():Object
         i++
         continue
      }
      else if(!Behind and i==Index)
      {
         ret[i]:=IsObj? Object.Clone():Object
         i++
         continue
      }
      ret[i]:= IsObj? Array[j].Clone():StrGet(&tp:=Array[j])
      i++
      j++
   }
   Array:=ret.Clone()   
}

