program grib2_to_binary
implicit none

integer, parameter :: m=51,n=51,zlev=25
real :: dat,p
dimension :: dat(m,n),p(zlev)
integer :: i,j,k,irec,icnt
character(50) :: finlist,fin,fout0,fout1,fsst
!!!===     1    2    3    4    5    6    7    8    9   10   
data p /1000, 975, 950, 925, 900, 850, 800, 750, 700, 650,&
         600, 550, 500, 450, 400, 350, 300, 250, 200, 150,&
         100,  70,  50,  30,  20/ !!!,  10/
!!!!!!!!!!!!!1234567890   15   20   25   30   35   40   45   50
data fout0 /"data.gpv????????????.bin                          "/
!data fsst  /"data.sst????????????.bin                          "/
!fnl_20120610_00_00.grib2
read(*,11)fin
11 format(A50)
print *,fin
fout1(1:50)=fout0(1:50)
fout1(9:20)=fin(1:12)

open(12,file=fin,status="old",form="unformatted",access="direct",recl=m*n*4)
open(13,file=fout1,status="unknown",form="unformatted",access="direct",recl=m*n*4)
!open(14,file=fsst,status="unknown",form="unformatted",access="direct",recl=m*n*4)

irec=0
icnt=0

!!! get HGT*zlev, UGRD*zlev, VGRD*zelv, and PRES*1(surface)
do k=1,zlev*3
  irec=irec+1
  read(12,rec=irec)dat
  icnt=icnt+1
  write(13,rec=icnt)dat
enddo

!!! fill presure at each air level (unit: Pa)
do k=1,zlev
  do i=1,m
    do j=1,n
      dat(i,j)=p(k)*100.
    enddo
  enddo
  icnt=icnt+1
  write(13,rec=icnt)dat
enddo

!!! get TMP*zlev
do k=1,zlev
  irec=irec+1
  read(12,rec=irec)dat
  icnt=icnt+1
  write(13,rec=icnt)dat
enddo

!!! get RH*zlev
do k=1,zlev-4
  irec=irec+1
  read(12,rec=irec)dat
  do i=1,m
    do j=1,n
      if(dat(i,j) > 100.0)then
        dat(i,j)=100.0
      else
        dat(i,j)=dat(i,j)
      end if
    end do
  end do
  icnt=icnt+1
  write(13,rec=icnt)dat
enddo

  do k=1,4
    read(12,rec=irec)dat
    do i=1,m
      do j=1,n
        if(dat(i,j) > 100.0)then
          dat(i,j)=100.0
        else
          dat(i,j)=dat(i,j)
        end if
      end do
    end do
    icnt=icnt+1
    write(13,rec=icnt)dat
  enddo


!close(14)
close(13)
close(12)

print *,"!!!FORTRAN THE END!!!"
end program grib2_to_binary
