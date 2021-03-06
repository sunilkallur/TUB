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

import scala.util.parsing.input.Positional



/**
 * Token of μ-Opal
 * */
abstract class Token() extends Positional{
  /** generates a [[Position]] for this [[Token]]
    * */
  def getPosition:Position={
    Source(this.pos.line,this.pos.column)
  }
  
  /** Checks whether this token is a variable [[VarT]] */
  def isVar = this match {case VarT(_) => true;case _ => false}
  /** Checks whether this token is a number [[NumT]] */
  def isNum = this match {case NumT(_) => true;case _ => false}
  /** Checks whether this token is a number [[DefT]] */
  def isDef = this match {case DefT()=> true;case _ => false}
  /** Checks whether this token is a number [[MainT]] */
  def isMain = this match {case MainT()=> true;case _ => false}
  /** Checks whether this token is a number [[ColonT]] */
  def isColon = this match {case ColonT()=> true;case _ => false}
  /** Checks whether this token is a number [[NatT]] */
  def isNat = this match {case NatT()=> true;case _ => false}
  /** Checks whether this token is  [[==]] */
  def isDefAs = this match {case DefAsT() => true;case _ => false}
   /** Checks whether this token is  [[EofT]] */
  def isEof = this match {case EofT() => true;case _ => false}
   /** Checks whether this token is  [[OpenT]] */
  def isOpen = this match {case OpenT() => true;case _ => false}
  /** Checks whether this token is  [[CloseT]] */
  def isClose = this match {case CloseT() => true;case _ => false}
  /** Checks whether this token is  [[IfT]] */
  def isIf = this match {case IfT() => true;case _ => false}
  /** Checks whether this token is  [[CommaT]] */
  def isComma = this match {case CommaT() => true;case _ => false}
  /** Checks whether this token is  [[ElseT]] */
  def isElse = this match {case ElseT() => true;case _ => false}
  /** Checks whether this token is  [[ThenT]] */
  def isThen = this match {case ThenT() => true;case _ => false}
  /** Checks whether this token is  [[FiT]] */
  def isFi = this match {case FiT() => true;case _ => false}
  /** Checks whether this token is  [[BoolT]] */
  def isBool = this match {case BoolT() => true;case _ => false}

  

  
}

/** Represents "(" */
case class OpenT() extends Token{
  override def toString():String = "\"(\""
}

/** Represents ")" */
case class CloseT() extends Token{
  override def toString():String = "\")\""
}

/** Represents "," */
case class CommaT() extends Token{
  override def toString():String = "\",\""
}

/** Represents ":" */
case class ColonT() extends Token{
  override def toString():String = "\":\""
}

/** Represents "==" */
case class DefAsT() extends Token{
  override def toString():String = "==" 
}

/** Represents "MAIN" */
case class MainT () extends Token{
  override def toString():String = "MAIN" 
}

/** Represents "DEF" */
case class DefT () extends Token{
  override def toString():String = "DEF"
}

/** Represents end of file */
case class EofT() extends Token{
  override def toString():String = "EOF"
}

/** Represents "IF" */
case class IfT  () extends Token{
  override def toString():String = "IF"
}

/** Represents "THEN" */
case class ThenT() extends Token{
  override def toString():String = "THEN"
}

/** Represents "ELSE" */
case class ElseT() extends Token{
  override def toString():String = "ELSE"
}

/** Represents "FI" */
case class FiT  () extends Token{
  override def toString():String = "FI"
}


// Values
/** Represents a variable
  * @param name The name of this variable
  *  */
case class VarT(name:String)  extends Token{
  override def toString():String = name 
}

/** Represents a number 
  * @param value The integer value of this number
  * */
case class NumT(value:Int) extends Token{
  override def toString():String = value.toString
}

/** Represents "true" */
case class TrueT           () extends Token{
  override def toString():String = "true"
}

/** Represents "false" */
case class FalseT          () extends Token{
  override def toString():String = "false"
}


// Type names
/** Represents "bool" */
case class BoolT() extends Token{
  override def toString():String = "bool"
}

/** Represents "nat" */
case class NatT () extends Token{
  override def toString():String = "nat"
}



