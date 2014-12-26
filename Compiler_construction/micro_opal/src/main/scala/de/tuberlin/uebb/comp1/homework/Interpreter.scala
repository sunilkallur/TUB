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

/**-----------------------------------------------------------------------------------------------------------------------------------------------

	Include the Libraries

-----------------------------------------------------------------------------------------------------------------------------------------------**/

package de.tuberlin.uebb.comp1.homework
import scala.language.implicitConversions
import scala.language.postfixOps
import scala.collection.immutable.{HashMap}

/**-----------------------------------------------------------------------------------------------------------------------------------------------

	Object definition for μ-Opal interpreter
	Interprets the given list of definitions [[Def]] starting with main function
	@param input List of definitions representing the context checked program
	@param opts [[Options]] given as arguments to comiler 
	@return Either an error message [[Diag]] or a [[Value]]

-----------------------------------------------------------------------------------------------------------------------------------------------**/

object Interpreter{

  case class ValueResult(v: Value, err: List[String] = List())

  case class Context(m: Map[String, Value]) {
  	def +(tu: (String, Value)): Context = Context(m + (tu))
					    }

  val initCtx: Context = new Context(new HashMap[String,Value]() ++ List ())

  val s1: Map[Value,Value] = Map[Value,Value]() ++ List()

  def interpret(input:List[Def],opts:Options):Either[Diag,Value] = {
    //Left(Diag("Interpreter not yet implemented",Global))

	val defs = input match{
                          case List(x,_) => x
			      }
         //println(defs)
        val e1 = eval(eval1(initCtx,defs),defs,s1)
	//println(e1)

	if(e1.err.isEmpty)
        	 Right(e1.v)
	else{
		val err = e1.err match{
				 case List(x) => x}
		 Left(Diag(err,Global))
	    }
}

/**-----------------------------------------------------------------------------------------------------------------------------------------------

	Definition to create a Map of ids to values
        @input : x : tuple of ids
	@input : y : tuple of input values
	@output: Map : Map with tuple ids to values 
 
-----------------------------------------------------------------------------------------------------------------------------------------------**/

  def toMap(x: Value, y: Value): Map[Value, Value] = {
       rec(x,y,Map.empty[Value, Value])
						     }

  def rec(x: Value, y: Value, map: Map[Value, Value]): Map[Value, Value] ={
      x match{
	case TupIdnV(e1,e2,src1) => e1 match{
				  case TupIdnV(e11,e21,src2) => {y match{
							      case tupexprV(ipval1,ipval2,src3) => rec(e1,ipval1,map ++ Map(e2 -> ipval2))
							      case _ => rec(x,y,map)
							       	   }
							   }

				  case _ => y match{
					      case tupexprV(ipval1,ipval2,src3) => map ++ Map(e1 -> ipval1) ++ Map(e2 -> ipval2)  
					      case _ => rec(x,y,map)
						   }
								
				
				       }
       case _ => map ++ Map(x -> y)
	    }
    
}

//-------------------------------------------------------------------------------------------------------------------------------------------------

/**-----------------------------------------------------------------------------------------------------------------------------------------------

	Definition to create an init map of function name to its ids and expr
	@input : ctx : init ctx
	@input : e   : List of Definition from Parser after Context check
	@output: Context : Map 
 
-----------------------------------------------------------------------------------------------------------------------------------------------**/
 
  def eval1(ctx:Context,e:Def) : Context = e match  { 
					     case defn(lhs,expr,src1) => {lhs match {
                                             				case Lhsidn(id,tupid,idtype,src2) => 
											{val tupid1 = eval(ctx,tupid,s1)
										 	 val idexpr = idTexprV(tupid1.v,expr,src2)
											 id match{ 
										   	    case Idn(name,_) => eval1(ctx +(name,idexpr),idtype)
											  	 }
										  	}
					     				 case _ => (ctx)		         
				           					     }
                                            				  }

  		
                                               
  					     case tupdefs(def1,def2,src1) => { val ctx1 = eval1(ctx,def1)
                                    					       val ctx2 = eval1(ctx1,def2)
				    						//println(ctx2)		
						 				(ctx2)  
                                  					     }
  					     case _ => ctx
  
  						    }

//-------------------------------------------------------------------------------------------------------------------------------------------------

/**-----------------------------------------------------------------------------------------------------------------------------------------------

	Definition for converting the type Value to type Def required when id[expr] evaluation
	@input : inp : List of Value of type Value
	@output : Def : List of Def of type Def
 
-----------------------------------------------------------------------------------------------------------------------------------------------**/

  def convert(inp : Value) : Def = { 
				inp match{

  				    case tupexprV(ipval1,ipval2,src) => { val expr1 = convert(ipval1)
				    				          val expr2 = convert(ipval2)
				    				          Tupexpr(expr1,expr2,src)
				  				    }

  				    case  NumV(v,src) => Numn(v,src)
 				    case BoolV(true,src)  => TrueTn(src)
  				    case BoolV(false,src) => FalseTn(src)
					 }
				   }

//-------------------------------------------------------------------------------------------------------------------------------------------------

/**-----------------------------------------------------------------------------------------------------------------------------------------------

	Definition for evaluating the List of Def using init ctx and map with ids to values for functions calling functions
	@input : env          : init ctx which contains all the user defined functions with id -> Tuple(arguments,expr)
	@input : e            : List of Definition from Parser after context checking
	@input : s1           : Dynamically created map for each function calling another function
	@output: ValueResult  : Result with value and list of error strings
 
-----------------------------------------------------------------------------------------------------------------------------------------------**/

  def eval(env:Context, e : Def,s1:Map[Value,Value]) : ValueResult = e match {

  case tupdefs(def1,def2,src) => { val e1 = eval(env,def1,s1)
                                   val e2 = eval(env,def2,s1)

				   if(e1.v == Inone()) 
					{ValueResult(e2.v,e2.err)} 
				   else 
					{ValueResult(e1.v,e1.err)}
				}

//-------------------------------------------------------------------------------------------------------------------------------------------------
  
  case defn(lhs,expr,src) => { lhs match{
 					case Lhsidn(id,tupid,idtype,src2) =>  ValueResult(Inone(),List(msg("No return value include else clause", src)))
					case LhsMain(types,_) => (eval(env, expr,s1)) 
				        }
			     } 

//-------------------------------------------------------------------------------------------------------------------------------------------------

  case Idn(n,src) => { if(env.m.contains(n))        
		       { val out = (env.m(n))
				out match{
				    case idTexprV(Inone(),expr,src2) => eval(env, expr,s1)
				    case _ => ValueResult(out)
					 }
				
		       }
		     else //if(s1.contains(IdnV(n)))
		       {
 			 ValueResult(s1(IdnV(n)))
		       }
		     }

//-------------------------------------------------------------------------------------------------------------------------------------------------

  case Numn(v,src) => ValueResult(NumV(v,src))

//-------------------------------------------------------------------------------------------------------------------------------------------------

  case TrueTn(src)  => ValueResult(BoolV(true,src))

//-------------------------------------------------------------------------------------------------------------------------------------------------

  case FalseTn(src) => ValueResult(BoolV(false,src))

//-------------------------------------------------------------------------------------------------------------------------------------------------

  case Tupexpr(expr1,expr2,src) => {  val ipval1 = eval(env,expr1,s1)
   				      val ipval2 = eval(env,expr2,s1)
					ValueResult(tupexprV(ipval1.v,ipval2.v,src),ipval1.err ::: ipval2.err)
				   }

//-------------------------------------------------------------------------------------------------------------------------------------------------

  case idexpr(id,ipvalues,src) => {val s = List("add","sub","mul","div","and","or","not","eq","lt")
				// println(ipvalues)
				   id match{ 
                                      case Idn(name,_) => if(!s.contains(name)) 
						         { val idexpr1 = env.m(name)
                                                       		     idexpr1 match
								             {case  idTexprV(tupid,expr,src11) =>
										 {val ips = eval(env,ipvalues,s1)
										
										  val smap = toMap( tupid,ips.v)
										  //println(expr)

										     expr match{
										      	  case idexpr(name2,tupexpr1,src1) =>
										                 {//println(tupexpr1)
											           val newipval = eval(env,tupexpr1,smap)
											           //println(newipval)
											           val Defipval = convert(newipval.v) 
												   //println(Defipval)
											           eval(env,idexpr(name2,Defipval,src1),s1) 
										                  }
											    case _ => eval(env,expr,smap)
											        }

										  
										     }
										case _ => eval(env,id,s1)
										
										}
									


  							  }else 
                                                            { name match{
                                                               	   case "add" =>{ ipvalues match{
                                                                                   	   case Tupexpr(expr1,expr2,_) =>{
                                                                                                      val e1 =  eval(env,expr1,s1)
												      
												      val e2 = e1.v match{
                                                                                                                    case NumV(v1,src1) => v1 
														    case _ => 0}//dummy case
													//println(e2)
											 
											               val e3 =  eval(env,expr2,s1)
												       	
											               val e4 = e3.v match{
                                                                                                                     case NumV(v2,src2) => v2
														     case _ => 0}//dummy case
													//println(e4)

                                                                                                        val e5 = e2.toLong + e4.toLong                    
                                                                                                        if (  e2 < 0 || e4 < 0 || e5 < 0 ||e5 > Int.MaxValue) {
                                                                                            ValueResult(NumV(e2 + e4,src),List(msg("Overflow at", src)))}
                                                                                                        else{ ValueResult(NumV(e2 + e4,src)) }
											  	}
									  	 } }

							      	   case  "sub" =>{ ipvalues match{
                                                                                   	    case Tupexpr(expr1,expr2,_) =>{
                                                                                        		val e1 =  eval(env,expr1,s1)
													val e2 = e1.v match{
                                                                                                    		      case NumV(v1,src1) => v1
														      case _ => 0}

											 
													val e3 =  eval(env,expr2,s1)
													val e4 = e3.v match{
                                                                                                        	      case NumV(v2,src2) => v2 
														      case _ => 0}
												 
                                                                                                        if ( e2 < 0 || e4 < 0 || ((e2-e4)<0)) {
                                                                                            ValueResult(NumV(e2-e4,src),List(msg("Underflow at", src)))}
                                                                                                        else{ ValueResult(NumV(e2 - e4,src)) }
                                                                                                                             }
												  }
									  	 }
 
							      	   case  "mul" =>{ ipvalues match{
                                                                                    	    case Tupexpr(expr1,expr2,_) =>{
                                                                                        		val e1 =  eval(env,expr1,s1)
													val e2 = e1.v match{
                                                                                                    		      case NumV(v1,src1) => v1
														      case _ => 0 }

											 
													val e3 =  eval(env,expr2,s1)
													val e4 = e3.v match{
                                                                                                        	      case NumV(v2,src2) => v2 
														      case _ => 0}
												

                                                                                                        val e5 = e2.toLong * e4.toLong                    
                                                                                                        if (  e2 < 0 || e4 < 0 || e5 < 0 || e5 > Int.MaxValue) {
                                                                                         ValueResult(NumV(-2147483648,src),List(msg("Overflow at", src)))}
                                                                                                        else{ValueResult(NumV(e2 * e4,src))  }


                                                                                                                                }


											 	 }
									   	} 

							     	    case  "div" =>{ ipvalues match{
                                                                                    	     case Tupexpr(expr1,expr2,_) =>{
                                                                                        		val e1 =  eval(env,expr1,s1)
													val e2 = e1.v match{
                                                                                                   		      case NumV(v1,src1) => v1 
														      case _ => 0}

											 
													val e3 =  eval(env,expr2,s1)
													val e4 = e3.v match{
                                                                                                        	      case NumV(v2,src2) => v2 
														      case _ => 0}
												if(e4 == 0){
									ValueResult(NumV(0,src),List(msg("Division by zero error", src)))}
												else{

                                                                                                   if (e2<0 || e4<0 || ((e2/e4)<0)){
									ValueResult(NumV(e2 / e4,src),List(msg("Overflow at", src)))}
                                                                                                   else {ValueResult(NumV(e2 / e4,src))}
                                                                                                    
                                                                                                     }

                                                                                                     }
											 	 }
									  	 } 

							      	    case  "eq" =>{ ipvalues match{
                                                                                  	    case Tupexpr(expr1,expr2,_) =>{
                                                                                      		       val e1 =  eval(env,expr1,s1)
												       val e2 = e1.v match{
                                                                                                    		      case NumV(v1,src1) => v1
														      case _ => 0 }

											 
												       val e3 =  eval(env,expr2,s1)
												       val e4 = e3.v match{
                                                                                                  		     case NumV(v2,src2) => v2
 														     case _ => 0 }
												
											       
													if(e2 == e4) 
														ValueResult(BoolV(true,src)) 
													else 
														ValueResult(BoolV(false,src))
															   }
											   	 }
									    	 }
									    

							      	     case  "lt" =>{ ipvalues match{
                                                                                    	    case Tupexpr(expr1,expr2,_) =>{
                                                                                       		  val e1 =  eval(env,expr1,s1)
												  val e2 = e1.v match{
                                                                                                   	        case NumV(v1,src1) => v1 
														case _ => 0}

											 
												  val e3 =  eval(env,expr2,s1)
												  val e4 = e3.v match{
                                                                                                    		case NumV(v2,src2) => v2 
														case _ => 0}
												
											       
												  if(e2 < e4)
													 ValueResult(BoolV(true,src)) 
												  else 
													 ValueResult(BoolV(false,src))}
											   	    }
									  	 } 
					
							              case  "and" =>{ ipvalues match{
                                                                                    	       case Tupexpr(expr1,expr2,_) =>{
                                                                                        		val res = eval(env,expr1,s1)
													val e1 =  res.v match{
                                                                                                        		case BoolV(x,src1) => x
															case _ => false   }

													val res2 = eval(env,expr2,s1)
											 		val e2 = res2.v match{
                                                                                                        		case BoolV(x,src2) => x
															case _ => false}

													if(e1 == true && e2 == true)
														 ValueResult(BoolV(true,src)) 
										         		else 
														 ValueResult(BoolV(false,src)) }
											 	      }
									  	     }

								       case  "or" =>{ ipvalues match{
                                                                                    		case Tupexpr(expr1,expr2,_) =>{
                                                                                        		val res = eval(env,expr1,s1)
													val e1 =  res.v match{
                                                                                                        		case BoolV(x,src1) => x
															case _ => false }
											 		val res2 = eval(env,expr2,s1)
													val e2 = res2.v match{
                                                                                                        		case BoolV(x,src2) => x
															case _ => false}

													if(e1 == false && e2 == false) 
														ValueResult(BoolV(false,src)) 
										        		else 
														 ValueResult(BoolV(true,src)) }
											 	     }
									  	    }

								        case  "not" =>{ ipvalues match{
                                                                                   		 case expr =>{
                                                                                       			 val res = eval(env,expr,s1)
													 val e1 =  res.v match{
                                                                                                        		case BoolV(x,src1) => x
															case _ => true }

											 		if(e1 == false)  
													 	ValueResult(BoolV(true,src)) 
										        		 else  
														ValueResult(BoolV(false,src)) }
											  		 }
									   	      }
								 }

 							 }
						}
				}

//-------------------------------------------------------------------------------------------------------------------------------------------------

  case TupidT(idT1,idT2,src) => {val e1 = eval(env,idT1,s1)
                                 val e2 = eval(env,idT2,s1)
				 ValueResult(TupIdnV(e1.v,e2.v,src))
				}

  case none(src) => ValueResult(Inone(),List(msg("No return value include else clause", src)))

//-------------------------------------------------------------------------------------------------------------------------------------------------

   case idT(id,typ,src) => {id match{
                               case Idn(name,src1) => ValueResult(IdnV(name))
			             }
		       	   }

//-------------------------------------------------------------------------------------------------------------------------------------------------

  case exprIF(c,i,e,src) => {
      			      val cc = eval(env,c,s1)
      			      cc.v match {
        			   case BoolV(true,src1) => {  
                                                                eval(env,i,s1)
                                                              
                                                                       }
        			   case BoolV(false,src2) => { 
    
                                                               eval(env,e,s1)
               				 }

                                 }
        		    }

//-------------------------------------------------------------------------------------------------------------------------------------------------

}

  private def msg(s: String, pos: Position) = s + " at " + pos

}
