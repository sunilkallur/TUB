/*
 * Copyright (c) 2013, TU Berlin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *   * Neither the name of the TU Berlin nor the
 *     names of its contributors may be used to endorse or promote products
 *     derived from this software without specific prior written permission.

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS """AS IS""" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL TU Berlin BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * */

package de.tuberlin.uebb.comp1.homework

//import  Token._
//import  Syntax._


/** Parser for μ-Opal-Compiler*/
object Parser extends Token{

  /** The input element of this parser is a list of [[Token]]*/
  type InputElem = Token

  /** Starts the parser
    * 
    * @param inp the token sequence (result of scanner)
    * @param opts [[Options]] given as arguments to compiler
    * @return either an error message [[Diag]] or a list of definitions [[Def]]  
    **/
 

//Starting Parser Definition

def parse(inp: List[InputElem],opts:Options): Either[Diag,List[Def]] ={

       val (e1) = parseprog(inp)
       
       Right(e1)
}


//     Prog == Def Def1 
def parseprog(inp: List[InputElem]):List[Def]={
      val src = Source(inp.head.pos.line,inp.head.pos.column)
      //println("parseprog")
      if(inp.head.isEof){
         List(Eof(src))
      }else{
        
      val (def1,inp1) = parsedef(inp)   
      val defs = parsedef1(def1,inp1)
      List(defs,Eof(src))
     }
    
}


//  Def1 == Def Node1 Def1 | Empty

def parsedef1(defs:Def,toks:List[Token]):(Def) ={
      //println(toks)
      if(toks.head.isEof){
       (defs)
      }
      else{
      val src = Source(toks.head.pos.line,toks.head.pos.column)
      val (def1,toks1) = parsedef(toks)
      val def2 = tupdefs(defs,def1,src)      //Node 1 
      parsedef1(def2,toks1)
      }    
}


// Def = DEF Lhs == Expr

def parsedef(toks:List[InputElem]):(Def,List[InputElem])={
      val toks1 = skip(toks.head.isDef,toks)
      val (e,toks2) = parseLhs(toks1)  
      val toks3 = skip(toks2.head.isDefAs,toks2)
      val (e1,toks4) = parseExpr(toks3)
      val src = Source(toks.head.pos.line,toks.head.pos.column)
      val def1 = defn(e,e1,src)            //Node 2
      (def1,toks4)
}
      

// Lhs = MAIN:Type | id(Lhs1 

def parseLhs(toks:List[Token]):(Def,List[Token])={
   val src = Source(toks.head.pos.line,toks.head.pos.column)
   if((toks.head.isMain)){
      
      val toks1 = skip(toks.head.isMain,toks)
      val toks2 = skip(toks1.head.isColon,toks1)  
      val (e1,toks3) =  parsetype(toks2)
      val defs = LhsMain(e1,src)            //Node 3 
       (defs,toks3)  
       
    }
    else
    {
       
	toks.head match 
      {
	case VarT(n) => 
	{ 
	   val e = Idn(n,src)
	   val toks1 = skip(toks.head.isVar,toks)
      	   val toks2 = skip(toks1.head.isOpen,toks1)
           val (defs,toks3) = parseLhsn1(toks2) 
           val toks4 = skip(toks3.head.isClose,toks3)
           val toks5 = skip(toks4.head.isColon,toks4)
           val (def2,toks6) = parsetype(toks5)
           ( Lhsidn( e, defs, def2,src),toks6)    //Node 4 
   
        }
      }
   }
}

   
//Type = nat | bool

def parsetype(toks:List[Token]):(Def,List[Token])={
      val src = Source(toks.head.pos.line,toks.head.pos.column)
      toks.head match{
      case NatT() => (Natn(src),toks.tail)          //Node 5
      case BoolT() => (Booln(src),toks.tail)	    //Node 6

      }
}



//Lhs1 = ):Type | Lhs2

def parseLhsn1(toks:List[Token]):(Def,List[Token]) =
{
 val src = Source(toks.head.pos.line,toks.head.pos.column)
 if(toks.head.isClose)
 {
   (none(src),toks)			                     //Node 17
 }
 else 
 {
 toks.head match 
  {
	case VarT(n) => 
	{ 
		val e = Idn(n,src)			     //Node 7
      		val toks1 = skip(toks.head.isVar,toks)
      		val toks2 = skip(toks1.head.isColon,toks1)
      		val (defs,toks3) = parsetype(toks2)
		val src1 = Source(toks3.head.pos.line,toks3.head.pos.column)
      		val def2 = idT(e,defs,src1)		     //Node 8
      		parseLhsn2(def2,toks3)
	}
  }

 }

}


def parseLhsn2(defs:Def,toks:List[Token]):(Def,List[Token])=
{  
 
 if(toks.head.isClose)
 {
   (defs,toks)
 }
 else 
 {
      val toks1 = skip(toks.head.isComma,toks)
 toks1.head match
 {      
	case VarT(n) => 
	{       val src = Source(toks1.head.pos.line,toks1.head.pos.column)
		val e = Idn(n,src)
	        val toks2 = skip(toks1.head.isVar,toks1)
      		val toks3 = skip(toks2.head.isColon,toks2)
      		val (def2,toks4) = parsetype(toks3)
                val src1 = Source(toks4.head.pos.line,toks4.head.pos.column)
      		val def3 = idT(e,def2,src1)
      		parseLhsn2(TupidT(defs,def3,src1),toks4)
        }
 }
 }

}

// Expr = num | true | false | id Expr1 | IF Expr THEN Expr T

def parseExpr(toks:List[Token]):(Def,List[Token])={
     val src = Source(toks.head.pos.line,toks.head.pos.column)
     toks.head match
      {
	case NumT(n) => (Numn(n,src),toks.tail) 
	case TrueT() => (TrueTn(src),toks.tail)       
	case FalseT() => (FalseTn(src),toks.tail)      
	case VarT(n) =>
	 {
	   val e1 = Idn(n,src)
           val toks1 = skip(toks.head.isVar,toks) 
           parseExpr1(e1,toks1)
	 }
	case _ =>
	 { 

	  val toks1 = skip(toks.head.isIf,toks)
	  val (e2,toksn) = parseExpr(toks1)

          val toks3 = skip(toksn.head.isThen,toksn)

          val (e3,toks4) = parseExpr(toks3)

          val (e4,toks5) = parseT(toks4)
          (exprIF(e2,e3,e4,src),toks5)
	 }
          
      }

      
} 
  

// Expr1 = (Expr2 | Empty

def parseExpr1(e:Def,toks:List[Token]):(Def,List[Token])={
   
    if(((toks.head.isEof))  || ((toks.head.isDef) || (toks.head.isComma) || (toks.head.isClose))||(toks.head.isFi)) 
     {
       (e,toks) 
     }
    else
     {
       val toks1 = skip(toks.head.isOpen,toks)
       parseExpr2(e,toks1)
     }
}

// Expr2 = ) | Expr3

def parseExpr2(e:Def,toks:List[Token]):(Def,List[Token])={ 
      if((toks.head.isClose)){
	 val toks1 = skip(toks.head.isClose,toks)
         (e,toks1)
      }else{
         parseExpr3(e,toks)
       }
}

//Expr3 = Expr Expr4

def parseExpr3(e:Def,toks:List[Token]):(Def,List[Token])={
       	val (e1,toks1) = parseExpr(toks)
        val (e2,toks2) = parseExpr4(e1,toks1)
        val src = Source(toks.head.pos.line,toks.head.pos.column)
        (idexpr(e,e2,src),toks2)
}


// Expr4 = ) | ,Expr Node10 Expr5)

def parseExpr4(e:Def,toks:List[Token]):(Def,List[Token])={
      if((toks.head.isClose)){
	 val toks1 = skip(toks.head.isClose,toks)
         (e,toks1)
      }else{
         val toks2 = skip(toks.head.isComma,toks)
         val (e1,toks3) = parseExpr(toks2)
         val src = Source(toks2.head.pos.line,toks2.head.pos.column)
         val en = Tupexpr(e,e1,src)          
         val (e2,toks4) = parseExpr5(en,toks3)
         val toks5 = skip(toks4.head.isClose,toks4)
         (e2,toks5)
      }
}


// ,Expr Expr5 | Empty

def parseExpr5(e:Def,toks:List[Token]):(Def,List[Token])={
        if((toks.head.isClose)){
           (e,toks)
        }else{
 
	 val toks1 = skip(toks.head.isComma,toks)
         val (e1,toks2) = parseExpr(toks1)
         val src = Source(toks1.head.pos.line,toks1.head.pos.column)
         val e3 = Tupexpr(e,e1,src)
         parseExpr5(e3,toks2)
         }
}


//T = ELSE Expr FI | FI

def parseT(toks:List[Token]):(Def,List[Token])={
        val src = Source(toks.head.pos.line,toks.head.pos.column)
        
        if((toks.head.isFi)){
           
           (none(src),toks.tail)

        }else{  
         val toks1 = skip(toks.head.isElse,toks)
         val (e1,toks2) = parseExpr(toks1)
         val toks3 = skip(toks2.head.isFi,toks2)  
         (e1,toks3)
        }
}

def skip(pred:Boolean,toks:List[Token]):List[Token]={   
    if(pred){
      toks.tail
    }else{
      print("Wrong token")
      throw new Exception("Wrong token: " + toks.head + ", at" +toks.head.pos)
    }
}

def shift(pred:Boolean,toks:List[Token]):(Token,List[Token])={
    if(pred){
      (toks.head,toks.tail)
    }else{
      throw new Exception("Wrong token: " + toks.head + ", at" +toks.head.pos)
    }
  }

}

