; Conversion of smooth.c file to assembly
; 
;

              .data

N_COEFFS:     .word 3
coeff:        .double 0.5,1.0,0.5
N_SAMPLES:    .word 5
sample:      .double 1.0,2.0,1.0,2.0,1.0
result:      .double 0.0,0.0,0.0,0.0,0.0

             .text
			 daddi r2,r0,coeff      ; starting address of coefficients
             
             l.d f3,0(r2)           ; first coefficient value
			 l.d f4,0x08(r2)        ; Second coefficint value
			 l.d f5,0x10(r2)        ; Third coefficient value
			  
   			 c.lt.d f3,f0           ; set floating point flag if first coefficient is less than zero
			 bc1f go1
			 mov.d f6,f3
			 sub.d f6,f0,f3         ; store |coeff(0)| in f6
	 
go1:         c.lt.d f4,f0           ; set floating point flag if second coefficient is less than zero
             
			 bc1f go2
			 mov.d f7,f4
             sub.d f7,f0,f4         ;store |coeff(1)| in f7
              
			  
go2:         c.lt.d f5,f0           ;set floating point flag if third coefficient is less than zero
             
			 bc1f go3
			 mov.d f8,f5
             sub.d f8,f0,f5         ;store |coeff(2)| in f8
			  
go3:         daddi r1,r0,1          ;value of '1' for counter decrements
             add.d f1,f7,f8         ;
			 daddi r3,r0,N_SAMPLES  ;base address of  "N_SAMPLES"
			 add.d f6,f6,f1         ;sum of all |coeff| in f6 
			 
             ld r7,0(r3)            ; No of samples
			 div.d f3,f3,f6         ; Normalise the first coefficient
			 
			 daddi r4,r0,result     ; base address of array "result"
			 daddi r2,r0,sample     ; base address of array "sample"
			 
             dsub r7,r7,r1          ; (No of samples-1)
			 dsll r5,r7,3           ; multiply number of samples by 8 to know the address of last but one element of "sample" array
			 dadd r8,r5,r2          ; address of last but one element of sample array			 

; copy last element of sample into result 	 

             l.d f17,0(r8)	        ;  load last sample
             div.d f4,f4,f6         ;  normalise the second coefficient			 
			  
			 l.d f10,0(r2)          ; load first sample
			 
			 dadd r9,r5,r4          ;last address of "result" array
			 
			 
			 s.d f17,0(r9)          ;storing last sample in "result" 	 
			 l.d f7,0x00(r2)        ; first sample in the loop 
             l.d f8,0x08(r2)        ;Second sample in the loop
			 div.d f5,f5,f6         ;normalise the third coefficient 
			
for_loop1:   mul.d f11,f4,f8        ;dot product
			 s.d  f10,0(r4)         ;store the result
             l.d f9,0x10(r2)        ; Third sample in the loop
			 
			 mul.d f10,f3,f7        ;dot product
			 mov.d f7,f8            ;rotate the sample
			 daddi r2,r2,0x08       ;increment sample array base address
			 daddi r4,r4,0x08       ;increment result array base address  
			 
			 add.d f13,f10,f11     ;intermediate sum of 2 dot product
			 mul.d f12,f5,f9       ;dot product 
			 
			 mov.d f8,f9           ;rotate the sample
			 bne r4,r9,for_loop1   ;all samples are done
			 add.d f10,f12,f13     ; sum of dot product
			
			 
     		 
finish:     halt                   ; End of program
			 
             	
             
			
		 
			 
			 
			  
			  