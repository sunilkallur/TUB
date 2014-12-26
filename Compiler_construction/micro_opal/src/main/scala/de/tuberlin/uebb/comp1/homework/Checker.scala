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
import scala.language.implicitConversions
import scala.language.postfixOps
import scala.collection.immutable.{HashMap}


/** The μ-Opal context checker */
object Checker {

  /**
    * Starts context check for μ-Opal 
    * @param input List of definitions [[Def]]
    * @param opts [[Options]] given as arguments to comiler
    * @return A list of error messages
    * */

     case class TypeResult(t: Type, err: List[String] = List())

     case class Context(m: Map[String, Type]) {
    	  def apply(s: String, src: Position): TypeResult =
          if (!m.contains(s)) TypeResult(TyUnknown,List(msg("undefined name " + s, src)))
          else TypeResult(m(s))
          def +(tu: (String, Type)): Context = Context(m + (tu))
    }

/**-----------------------------------------------------------------------------------------------------------------------------------------------
        
	List of Primitive functions with their return types and argument types

-----------------------------------------------------------------------------------------------------------------------------------------------**/
   
    val initCtx: Context = new Context(new HashMap[String,Type]() ++ List(
    ("add",TyFun(TyNat,TyFun(TyNat,TyNat))),
    ("sub",TyFun(TyNat,TyFun(TyNat,TyNat))),
    ("mul",TyFun(TyNat,TyFun(TyNat,TyNat))),
    ("div",TyFun(TyNat,TyFun(TyNat,TyNat))),
    ("eq",TyFun(TyBool,TyFun(TyNat,TyNat))),
    ("lt",TyFun(TyBool,TyFun(TyNat,TyNat))),
    ("and",TyFun(TyBool,TyFun(TyBool,TyBool))),
    ("not",TyFun(TyBool,TyBool)),
    ("or",TyFun(TyBool,TyFun(TyBool,TyBool)))))

/**-----------------------------------------------------------------------------------------------------------------------------------------------
        
	idstr : To store the list of lhs parameters of a function definition to get the types if required in expr stage. 

-----------------------------------------------------------------------------------------------------------------------------------------------**/


    val  idstr:Context = new Context(new HashMap[String,Type]() ++ List ())

//-------------------------------------------------------------------------------------------------------------------------------------------------

  def check(input:List[Def],opts:Options):Option[List[String]] = input match {
      case List(defn(lhsidn,expr,src1),Eof(src)) => 
                                         { val (ctx1,e1,s1) = typeOf(initCtx, defn(lhsidn,expr,src1),idstr)
                                        //  println(ctx1) 
                                 	   e1 match{
                                              case TypeResult(TyUnknown,err1) => Some(msg("Atleast one Main Definition required",Global)::err1)
                                    	      case TypeResult(t1,err1)  =>  if (err1.isEmpty){ None} else{ Some(err1)}
                                            
                                                   }
                                         }

                                                      
      case List(tupdefs(def1,def2,src1),Eof(src)) => 
                                         { 

                                          val(ctx_def,e_def) = typectxupdate(initCtx,tupdefs(def1,def2,src1)) //update the context before type checking with list of definitions          
                                             //println("Hello \n")
                                             //println(ctx_def)
                                             //println("\n")
                                            // println(e_def)
                                           val (ctx2,e1,s1) = typeOf(ctx_def,tupdefs(def1,def2,src1),idstr)
                                             //println("\n")
                                            // println(ctx2)
                                            // println(e1)
                                          (e_def,e1) match{

            case (TypeResult(TyUnknown,err1),TypeResult(TyUnknown,err2)) =>  Some(msg("Atleast one Main Definition required",Global)::(err1:::err2))
            case (TypeResult(TyUnknown,err1),TypeResult(t2,err2)) => Some(msg("Atleast one Main Definition required",Global)::(err1:::err2))   
            case (TypeResult(t1,err1),TypeResult(TyUnknown,err2)) => Some(msg("Atleast one Main Definition required",Global)::(err1:::err2))   	        
            case (TypeResult(t1,err1),TypeResult(t2,err2))=> if (err1.isEmpty && err2.isEmpty){None} else{ Some(err1:::err2)}


                                                   } //end of match
                                         }

      case List(Eof(src1)) => { val e = TypeResult(TyUnknown,List(msg("Atleast one Main Definition required",src1)))
                                Some(e.err) 
                              }
      }

//-------------------------------------------------------------------------------------------------------------------------------------------------


/**-----------------------------------------------------------------------------------------------------------------------------------------------
        
	typeOf : Function is called recursively based on the parser input Def
        input param @ ctx : contains primitive functions  and store user defined funcitons name and return types and argument types respectively
                       e  : List of Def from Parser Output
                       s  : Map to store the List of arguments in user defined function definition (Mapping id name to its type) 

        outputparam @ Context    : Updated ctx
                      TypeResult : Contains the return type and List of error messages
                      Context    : updated Map s


	typectxupdate : Function is called recursively to build the context with all the definitions
        input param @ ctx : contains primitive functions  and store user defined funcitons name and return types and argument types respectively
                       e  : List of Def from Parser Output

        outputparam @ Context    : Updated ctx
                      TypeResult : Contains the return type and List of error messages




-----------------------------------------------------------------------------------------------------------------------------------------------**/

                                             
  private def typectxupdate(ctx: Context, e: Def): (Context,TypeResult)  = e match { 


   case tupdefs(def1,def2,src) => { val (ctx1,e1) = typectxupdate(ctx,def1)
                                    val (ctx2,e2) = typectxupdate(ctx1,def2)

                       (e1,e2) match{
                       case (TypeResult(TyUnknown,err1),TypeResult(TyUnknown,err2))  => (ctx2,TypeResult(TyUnknown,err1:::err2))
                       case (TypeResult(TyUnknown,err1),TypeResult(t2,err2)) => (ctx2,TypeResult(t2,err1:::err2))
                       case (TypeResult(t1,err1),TypeResult(TyUnknown,err2)) => (ctx2,TypeResult(t1,err1:::err2))
   		       case (TypeResult(t1,err1),TypeResult(t2,err2)) => {(ctx2,TypeResult(t1,err1:::err2)) }
                                 }//end of match
                              } //end of case


   case defn(lhs,expr,src) =>{ 
                             val (ctx1,e1) = typectxupdate(ctx,lhs)

                             val (t1) = (e1) match{
                                     		   case (TypeResult(TyFun(t1,t2),err1)) => (t1)
                                                   case (TypeResult(t1,err1)) => (t1)
							}

                             lhs match{
                                   case LhsMain(types,src1) =>  (ctx1,TypeResult(e1.t,e1.err))
                                   case Lhsidn(id,tupid,idtype,src2) => (ctx1,TypeResult(TyUnknown,e1.err))
                                        }
                              
                           }


     case LhsMain(types,src) =>   if (!ctx.m.contains("MAIN"))
			       { val (ctx1,e) =typectxupdate(ctx,types)
                                 val (ctx2,e1) =typectxupdate(ctx1 +("MAIN",e.t),types) //add to the context
                                 (ctx2,e1)
                               }else
                               {  val (ctx1,e1) = typectxupdate(ctx,types)
				  (ctx,TypeResult(e1.t,List(msg("Multiple Main Definitions found",src))))
                               }       



     case Lhsidn(id,tupid,idtype,src) =>  val primt =  List("add","or","not","eq","lt","and","mul","div","sub")
					id match{
                                     	        case Idn(name,src2) => 
                                                {  val (ctx1,e) = typectxupdate(ctx,idtype) //check for type
						  if (!ctx.m.contains(name))
                                          	      {   
                                                        // ((ctx1+(name,e.t)),e) // add to the context
                                                           val (ctx2,e1) = typectxupdate(ctx1,tupid)
                                                
						          if(e1.err == List())
                                                          {
                                                          val (typ) = e1 match{
                                                                          case TypeResult(TyTupidT(listidTypes),e.err) =>(listidTypes)
                                                                          case TypeResult(TyidT(name,typen),e.err) => (typen)
									  case TypeResult(TyUnknown,e.err) => TyUnknown
                                                                              } 
                                                                    if(typ != TyUnknown){   
                    				                                  val e2 = TyFun(e.t,typ)
								                  typectxupdate(ctx2 +(name,e2),idtype) 
                                                                 
                                                                            }else{ 
                                                                                 val e2 = e.t
                                                                                  typectxupdate(ctx2 +(name,e2),idtype) 
                                                                                 }
						
                                                          }else{
                                                                 (ctx1,TypeResult(e.t,e1.err))
							  }                                                   
				           
                                                   }else if(primt.contains(name)){
                                                    
				 (ctx1,TypeResult(e.t,(msg("'"+ name + "' is a primitive function and redefinition is not allowed",src)::e.err)))

					           }else{
						   (ctx1,TypeResult(e.t,(msg("Multiple definition of function '"+ name + "'",src)::e.err)))
					           }
                                                }
                                               }

   
    case TupidT(idT1,idT2,src) =>  { val (ctx1,e1) = typectxupdate(ctx,idT1)
                                     val (idT1str,idT1typ) = e1 match{
						                case TypeResult(TyTupidT(listidTypes),err) => (("notvalid"),listidTypes) 
   				  		                case TypeResult(TyidT(id1: String, types1: Type),err) => (id1,types1)
     								     }
                                     val (ctx2,e2) = typectxupdate(ctx1,idT2)   
                                     //println(e2)

				      if(e2.t != TyUnknown)
                                     {                   
                                     val (idT2str,idT2typ) = e2 match{
                                                            	case TypeResult(TyidT(id2: String, types2: Type),err) => (id2,(types2))
                                                              //  case TypeResult(TyUnknown,err) => (TyUnknown,TyUnknown)
                                                                     }
				    
			             val listidTypes = TyFun(idT1typ,idT2typ)
                                     (ctx2,TypeResult(TyTupidT(listidTypes),e1.err ::: e2.err)) 
				     }else{
                                     (ctx2,TypeResult(TyTupidT(idT1typ),e1.err ::: e2.err))
                                     }


			           }

    case idT(id,types,src) => id match{
                                 case Idn(name,src1) => {  val (ctx1,typen) = typectxupdate(ctx,types)
                                                            (ctx1,TypeResult(TyidT(name,typen.t),typen.err))
                                                        }
                                      }


      case Natn(src) => (ctx,TypeResult(TyNat))

      case Booln(src) =>  (ctx,TypeResult(TyBool))     

      case none(src) => (ctx,TypeResult(TyUnknown))


  } //end of match case

/*-----------------------------------------------------------------------------------------------------------------------------------------------**/

                                                         
   private def typeOf(ctx: Context, e: Def, s : Context): (Context,TypeResult,Context)  = e match {

   case tupdefs(def1,def2,src) => { val (ctx1,e1,s1) = typeOf(ctx,def1,s)
                                    val (ctx2,e2,s2) = typeOf(ctx1,def2,s)

                       (e1,e2) match{
                       case (TypeResult(TyUnknown,err1),TypeResult(TyUnknown,err2))  => (ctx2,TypeResult(TyUnknown,err1:::err2),s2)
                       case (TypeResult(TyUnknown,err1),TypeResult(t2,err2)) => (ctx2,TypeResult(t2,err1:::err2),s2)
                       case (TypeResult(t1,err1),TypeResult(TyUnknown,err2)) => (ctx2,TypeResult(t1,err1:::err2),s2)
   		       case (TypeResult(t1,err1),TypeResult(t2,err2)) => {
						(ctx2,TypeResult(t1,err1:::err2),s2)
                                                                         }
                                 }
                              }

//-------------------------------------------------------------------------------------------------------------------------------------------------

   case defn(lhs,expr,src) =>{ 
                             val (ctx1,e1,s1) = typeOf(ctx,lhs,s)
                             val (ctx2,e2,s2) = typeOf(ctx1,expr,s1)

                             //println(e2)
                             
                             val (t1,t2) = (e1,e2) match{
                                     		   case (TypeResult(TyFun(t1,t2),err1),TypeResult(TyFun(t3,t4),err2)) => (t1,t3)
                                                   case (TypeResult(TyFun(t1,t2),err1),TypeResult(t3,err2)) => (t1,t3)
                                                   case (TypeResult(t1,err1),TypeResult(TyFun(t2,t3),err2)) => (t1,t2)
                                                   case (TypeResult(t1,err1),TypeResult(t2,err2)) => (t1,t2)
							}

			     if(e1.t == e2.t) // check for return and declared type mismatch
                             { lhs match{
                                   case LhsMain(types,src1) =>  (ctx2,TypeResult(e1.t,e1.err:::e2.err),s2)
                                   case Lhsidn(id,tupid,idtype,src2) => (ctx2,TypeResult(TyUnknown,e1.err:::e2.err),s2)
                                        }
                             }else if(t1 == t2) // Check for argument type mismatch
			       {lhs match{
                                    case LhsMain(types,src1) =>  
					(ctx2,TypeResult(e1.t,msg("Argument mismatch",src)::e1.err:::e2.err),s2)
                                    case Lhsidn(id,tupid,idtype,src2) => 
					(ctx2,TypeResult(TyUnknown,msg("Argument mismatch",src)::e1.err:::e2.err),s2)
                                        }
                                       
			    }else{ 
                (ctx2,TypeResult(TyUnknown,(msg("Declared type and return type are different in function definition",src) :: e1.err:::e2.err)),s2)
                             }
                           }

//-------------------------------------------------------------------------------------------------------------------------------------------------
   
/*LhsMain context update removed*/
  
   
   case LhsMain(types,src) =>   
			       { val (ctx1,e,s1) =typeOf(ctx,types,s)
                                 //val (ctx2,e1,s2) =typeOf(ctx1 +("MAIN",e.t),types,s1)
                                 (ctx1,e,s1)
                               }


//-------------------------------------------------------------------------------------------------------------------------------------------------

   case Idn(value,src)   =>  {  if(ctx.m.contains(value))
                                   (ctx,TypeResult(ctx.m(value)),s)
                                else if(s.m.contains(value))
				   (ctx,TypeResult(s.m(value)),s)
				else
                                   (ctx,TypeResult(TyUnknown,List(msg("Type of variable '" + value + "' is unknown",src))),s)
                             }
 
//-------------------------------------------------------------------------------------------------------------------------------------------------

   case Lhsidn(id,tupid,idtype,src) =>  val primt =  List("add","or","not","eq","lt","and","mul","div","sub")
					id match{
                                     	        case Idn(name,src2) => 
                                                {  val (ctx1,e,s1) = typeOf(ctx,idtype,s) 
                                                          val (ctx2,e1,s2) = typeOf(ctx1,tupid,s1)
                                                          //println(e1.err == List())
						          if(e1.err == List())
                                                          {
                                                          val (typ) = e1 match{
                                                                          case TypeResult(TyTupidT(listidTypes),e.err) =>(listidTypes)
                                                                          case TypeResult(TyidT(name,typen),e.err) => (typen)
									  case TypeResult(TyUnknown,e.err) => TyUnknown
                                                                              } 
                                                          if(typ != TyUnknown){   
                    				                 val e2 = TyFun(e.t,typ)
								 typeOf(ctx2 +(name,e2),idtype,s2) 
                                                                 
                                                          }else{ 
                                                                 val e2 = e.t
                                                                 typeOf(ctx2 +(name,e2),idtype,s2) 
                                                          }
							  //println(e2)
                                                          }else{
                                                     (ctx1,TypeResult(e.t,e1.err),s)
							  }
                                                            

                                                }//end of case
                                               } //end of match
   
//------------------------------------------------------------------------------------------------------------------------------------------------ 

    case TupidT(idT1,idT2,src) =>  { val (ctx1,e1,s1) = typeOf(ctx,idT1,s)
                                     val (idT1str,idT1typ) = e1 match{
						                case TypeResult(TyTupidT(listidTypes),err) => (("notvalid"),listidTypes) 
   				  		                case TypeResult(TyidT(id1: String, types1: Type),err) => (id1,types1)
     								     }
                                     val (ctx2,e2,s2) = typeOf(ctx1,idT2,s1 + (idT1str,idT1typ))   
                                     //println(e2)

				      if(e2.t != TyUnknown)
                                     {                   
                                     val (idT2str,idT2typ) = e2 match{
                                                            	case TypeResult(TyidT(id2: String, types2: Type),err) => (id2,(types2))
                                                              //  case TypeResult(TyUnknown,err) => (TyUnknown,TyUnknown)
                                                                     }
				    
			             val listidTypes = TyFun(idT1typ,idT2typ)
                                     (ctx2,TypeResult(TyTupidT(listidTypes),e1.err ::: e2.err),(s2 + (idT2str,idT2typ))) 
				     }else{
                                     (ctx2,TypeResult(TyTupidT(idT1typ),e1.err ::: e2.err),s2)
                                     }


			           }

//------------------------------------------------------------------------------------------------------------------------------------------------ 

    case idT(id,types,src) => id match{
                                 case Idn(name,src1) => { 
                                                          if(!s.m.contains(name))
							  { val (ctx1,typen,s1) = typeOf(ctx,types,s)
                                                            (ctx1,TypeResult(TyidT(name,typen.t),typen.err),(s1 + (name,typen.t)))
                                                          }else{
                                                            (ctx,TypeResult(TyUnknown,List(msg("Parameter'" + name + "' is duplicated",src))),s)
                                                          }
                                                        }
                                      }

//------------------------------------------------------------------------------------------------------------------------------------------------ 

    case idexpr(id,expr,src) => id match{
                                     case Idn(name,src1) => { 
						            if (ctx.m.contains(name))
			      		                    { 
							      val e1 = TypeResult(ctx.m(name))

				 	                      val (e2,e3) = e1 match{
 					 		      case TypeResult(TyFun(t11,t12),err) => (TypeResult(t11),TypeResult(t12))
							      case TypeResult(typen,err) => (TypeResult(typen),TypeResult(TyUnknown))
										    }  
   
				                              val (ctx1,e4,s1) = typeOf(ctx,expr,s)

                                      			      if(e3.t == e4.t)
                                                              {  (ctx1,e2,s1)
                                                              } else{
                                          (ctx1,TypeResult(e2.t,(("function '" + name + "'  arguments are not w.r.t its defn") :: e4.err)),s1)
				                                    }
                 
                                                              }else if(s.m.contains(name))
                                                                 {
					                            (ctx,TypeResult(s.m(name)),s)
				                              }else{ 

                                                                    
                                                                 (ctx,TypeResult(TyUnknown,List(msg("No function with name " + name,src))),s)
				                                   }
                               		  
				                              }
                                         }

//------------------------------------------------------------------------------------------------------------------------------------------------

    case Tupexpr(expr1,expr2,src) => { val (ctx1,e1,s1) = typeOf(ctx,expr1,s)
                                       val (ctx2,e2,s2) = typeOf(ctx1,expr2,s1)
                                       val e3 = TyFun(e1.t,e2.t)
                                           (ctx2,TypeResult(e3,e1.err ::: e2.err),s2)
				     }

//------------------------------------------------------------------------------------------------------------------------------------------------

    case Numn(numbr,src) => (ctx,TypeResult(TyNat),s)

//------------------------------------------------------------------------------------------------------------------------------------------------

    case Natn(src) => (ctx,TypeResult(TyNat),s)

//------------------------------------------------------------------------------------------------------------------------------------------------

    case TrueTn(src) => (ctx,TypeResult(TyBool),s)

//------------------------------------------------------------------------------------------------------------------------------------------------

    case FalseTn(src) => (ctx,TypeResult(TyBool),s)

//------------------------------------------------------------------------------------------------------------------------------------------------

    case Booln(src) =>  (ctx,TypeResult(TyBool),s)

//------------------------------------------------------------------------------------------------------------------------------------------------

    case none(src) => (ctx,TypeResult(TyUnknown),s)

//------------------------------------------------------------------------------------------------------------------------------------------------
  
    case exprIF(c,t,e,src) => {
                                val (ctx1,trC,s1) = typeOf(ctx,c,s)
      				val (ctx2,trT,s2) = typeOf(ctx1,t,s1)
      				val (ctx3,trE,s3) = typeOf(ctx2,e,s2)
				val errCond:List[String] = if(trC.t &= TyBool){
									        trC.err
     									      }else{
        									(msg("Condition must be a boolean!",src) :: trC.err) 
   									      }

      				(trT,trE) match {
       				 case (TypeResult(TyUnknown,errT),TypeResult(tElse,errE)) => (ctx3,TypeResult(tElse,errCond++errT++errE),s3)
       				 case (TypeResult(tThen,errT),TypeResult(TyUnknown,errE)) => (ctx3,TypeResult(tThen,errCond++errT++errE),s3)
      			         case (TypeResult(tThen,errT),TypeResult(tElse,errE)) => if(tThen&=tElse){
          										     (ctx3,TypeResult(tThen,errCond++errT++errE),s3)
        										 }else{
          			(ctx3,TypeResult(TyUnknown,(msg("then and else must have same type",src)::errCond++errT++errE)),s3)
        										      }
      						}
     			      } 

//------------------------------------------------------------------------------------------------------------------------------------------------
  
     case _ => (ctx,TypeResult(TyUnknown,List(msg("Checker not yet implemented ", Global))),s)

//------------------------------------------------------------------------------------------------------------------------------------------------

 }
    private def msg(s: String, pos: Position) = s + " at " + pos
}
