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

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
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
 */

package de.tuberlin.uebb.comp1.homework
import scala.util.parsing._
import scala.language.implicitConversions
//import Position._



/**
  * Represents a definition, hole program is a list of definitions
  * */

//abstract class Def(val src: Range){}

abstract class Def{}

/**
   * Simple data structure representing the position (line and column) in a source file.
   */
 
case class tupdefs(def1:Def,def2:Def,src:Source) extends Def              //Node 1
case class defn(Lhs:Def,Expr:Def,src:Source) extends Def 		  //Node 2
case class LhsMain(typen : Def,src:Source) extends Def 			  //Node 3
case class Lhsidn(id:Def,tupid: Def,typen : Def,src:Source) extends Def   //Node 4
case class Natn(src:Source) extends Def					  //Node 5
case class Booln(src:Source) extends Def				  //Node 6
case class Idn(value:String,src:Source) extends Def 			  //Node 7
case class idT(id: Def,typ: Def,src:Source) extends Def			  //Node 8
case class TupidT(idT1: Def,idT2: Def,src:Source) extends Def 		  //Node 9
case class idexpr(id: Def, tupexpr: Def,src:Source) extends Def		  //Node 10
case class Tupexpr(expr1:Def,expr2:Def,src:Source) extends Def   	  //Node 11
case class exprIF(cond:Def,thn:Def,elsen:Def,src:Source) extends Def	  //Node 12
case class Numn(value:Int,src:Source) extends Def          		  //Node 13
case class TrueTn(src:Source)  extends Def                                //Node 14
case class FalseTn(src:Source)  extends Def  				  //Node 15
case class Eof(src:Source) extends Def                			  //Node 16
case class none(src:Source) extends Def					  //Node 17



abstract class Type {

    def &=(t2: Type): Boolean = (this, t2) match {
      case (TyUnknown, _) => true
      case (_, TyUnknown) => true
      case (x, y) => x == y
    }
  }




case object TyNat extends Type
case object TyBool extends Type
case object TyUnknown extends Type



case class TyFun(arg: Type, res: Type) extends Type{
    override def toString() = "(" ++ arg.toString ++ ") -> (" ++ res.toString ++ ")" 
  }

case class TyidT(id: String, types: Type) extends Type{
    override def toString() = "(" ++ id ++ ") -> (" ++ types.toString ++ ")"
  }

case class TyTupidT(types: Type) extends Type{
  }


// for interpreter

