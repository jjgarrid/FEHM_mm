      subroutine gradctr(iflg)
!***********************************************************************
!  Copyright, 2004,  The  Regents  of the  University of California.
!  This program was prepared by the Regents of the University of 
!  California at Los Alamos National Laboratory (the University) under  
!  contract No. W-7405-ENG-36 with the U.S. Department of Energy (DOE). 
!  All rights in the program are reserved by the DOE and the University. 
!  Permission is granted to the public to copy and use this software 
!  without charge, provided that this Notice and any statement of 
!  authorship are reproduced on all copies. Neither the U.S. Government 
!  nor the University makes any warranty, express or implied, or 
!  assumes any liability or responsibility for the use of this software.
C***********************************************************************
CD1
CD1  PURPOSE
CD1
CD1  This subroutine manages initization and boundary conditions 
CD1  that involve gradients 
CD1
C***********************************************************************
CD2
CD2 REVISION HISTORY
CD2
CD2 Initial implementation: 19-APR-02, Programmer: George Zyvoloski
CD2 
CD2 $Log:   /pvcs.config/fehm90/src/gradctr.f_a  $
!D2 
!D2    Rev 2.5   06 Jan 2004 10:43:12   pvcs
!D2 FEHM Version 2.21, STN 10086-2.21-00, Qualified October 2003
!D2 
!D2    Rev 2.4   29 Jan 2003 09:07:20   pvcs
!D2 FEHM Version 2.20, STN 10086-2.20-00
CD2
C***********************************************************************
CD3
CD3  REQUIREMENTS TRACEABILITY
CD3
CD3 2.6 Provide Input/Output Data Files
CD3 3.0 INPUT AND OUTPUT REQUIREMENTS                  
CD3
C***********************************************************************
CD4
CD4  SPECIAL COMMENTS AND REFERENCES
CD4
CD4 Requirements from SDN: 10086-RD-2.20-00
CD4   SOFTWARE REQUIREMENTS DOCUMENT (RD) for the 
CD4   FEHM Application Version 2.20
CD4
**********************************************************************

      use comai
      use combi
      use comco2
      use comdi
      use comdti
      use comfi
      use commeth
      implicit none

      integer iflg,icode, izone, inode, idir
      integer mi,neqp1,i,i1,i2,j,jj,ja
      real*8 dist 

c================================================================
      if(igrad.eq.0) return
c================================================================
      if(iflg.eq.0) then
c
c read input  
c cordg : reference coordinate
c idirg : gradient coordinate direction (1 = x,2 = y, 3 = z)    
c igradf=1 : initial pressure is a variable 
c igradf=2 : initial temperature is a variable 
c igradf=3 : initial saturation  is a variable 
c igradf=4 : specified pressure (or head) is a variable
c igradf=5 : specified inflow temperture (or enthalpy) is a variable
c xg1 is x coordinate at reference point
c yg1 is y coordinate at reference point
c zg1 is z coordinate at reference point
c var0 is variable at cordg
c grad1 is the linear gradient
c
         read(inpt,*) ngrad
         if(.not.allocated(izone_grad)) then
            allocate(izone_grad(max(1,ngrad)))
            allocate(igradf(max(1,ngrad)))
            allocate(cordg(max(1,ngrad)))
            allocate(var0(max(1,ngrad)))
            allocate(grad1(max(1,ngrad)))
            allocate(idirg(max(1,ngrad)))
            allocate(izone_grad_nodes(n0))   
         end if

         read(inpt,*) 
     &        (izone_grad(i),cordg(i),idirg(i),
     &        igradf(i),var0(i),grad1(i),i=1,ngrad)
c     Loop over each zone for determining izone_grad array
           
         izone_grad_nodes = 0
         do izone = 1, ngrad
	      if(izone_grad(izone).lt.0) then
             do inode = 1, n0
c if negative set all nodes               
                  izone_grad_nodes(inode) = izone_grad(izone)              
             end do
	      else
             do inode = 1, n0
               if(izonef(inode).eq.izone_grad(izone)) then
                  izone_grad_nodes(inode) = izone_grad(izone)
               end if
             end do
	      endif
         end do

      else if(iflg.eq.1) then
c
c modify initial values and BC's
c
         if(iread.le.0) then
            do izone=1,ngrad
               do inode=1,n0
                  if(izone_grad_nodes(inode).eq.izone_grad(izone)) then
                     idir = idirg(izone)
                     dist = cord(inode,idir)-cordg(izone)
                     if(igradf(izone).eq.1) then
                        pho(inode)=var0(izone) + grad1(izone)*dist
                     else if(igradf(izone).eq.2) then
                        to(inode)=var0(izone) + grad1(izone)*dist
                     else if(igradf(izone).eq.3) then
                        so(inode)=var0(izone) + grad1(izone)*dist
                     else if(igradf(izone).eq.4) then
                        pflow(inode)=var0(izone) + grad1(izone)*dist
                     else if(igradf(izone).eq.5) then
                        esk(inode)=var0(izone) + grad1(izone)*dist
                     else if(igradf(izone).eq.-5) then
                        esk(inode)=-(var0(izone) + grad1(izone)*dist)
                     else if(igradf(izone).eq.6) then
                        phometh(inode)=var0(izone) + grad1(izone)*dist
                     else if(igradf(izone).eq.7) then
                        pflowmeth(inode)=var0(izone) + grad1(izone)*dist
                     else if(igradf(izone).eq.8) then
                        qflux(inode)=var0(izone) + grad1(izone)*dist
c RJP 04/10/07 added the following part for CO2
                     else if(igradf(izone).eq.9) then
                        phoco2(inode)=var0(izone) + grad1(izone)*dist
                     else if(igradf(izone).eq.10) then
                        pflowco2(inode)=var0(izone) + grad1(izone)*dist
                     endif
                  endif
               enddo
            enddo
         else
            do izone=1,ngrad
               do inode=1,n0
                  if(izone_grad_nodes(inode).eq.izone_grad(izone)) then
                     idir = idirg(izone)
                     dist = cord(inode,idir)-cordg(izone)
                     if(igradf(izone).eq.4) then
                        pflow(inode)=var0(izone) + grad1(izone)*dist
                     else if(igradf(izone).eq.5) then
                        esk(inode)=var0(izone) + grad1(izone)*dist
                     else if(igradf(izone).eq.-5) then
                        esk(inode)=-(var0(izone) + grad1(izone)*dist)
                     else if(igradf(izone).eq.7) then
                        pflowmeth(inode)=var0(izone) + grad1(izone)*dist
                     else if(igradf(izone).eq.8) then
                        qflux(inode)=var0(izone) + grad1(izone)*dist
c RJP 04/10/07 added following for CO2
                     else if(igradf(izone).eq.10) then
                        pflowco2(inode)=var0(izone) + grad1(izone)*dist
                     endif
                  endif
               enddo
            enddo
         endif
         if(allocated(izone_grad)) then
            deallocate(izone_grad)
            deallocate(igradf)
            deallocate(var0)
            deallocate(grad1)
            deallocate(cordg)
            deallocate(idirg)
            deallocate(izone_grad_nodes)   
         end if

      else if(iflg.eq.2) then
c


      else if(iflg.eq.3) then
c

      endif
c 
      return
      end                
