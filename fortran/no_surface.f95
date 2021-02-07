PROGRAM no_surface

! Purpose :
!   write out no suface data

IMPLICIT NONE

INTEGER, PARAMETER :: m = 201, n = 201
INTEGER, PARAMETER :: INxgrid = 201, INygrid = 201, INzlevel = 26
INTEGER, PARAMETER :: OUTxgrid = 201, OUTygrid = 201, OUTzlevel = 25
INTEGER, PARAMETER :: INfiles = 24, OUTfiles = 24
INTEGER, PARAMETER :: initial_yr = 2017, initial_mon = 05, initial_day = 30, initial_hr = 00
INTEGER, PARAMETER :: time_interval = 06
INTEGER :: iyr, imo, idy, ihr
INTEGER :: i, j, k
CHARACTER(len=4) :: cyr
CHARACTER(len=2) :: cmo, cdy, chr
REAL, DIMENSION(m, n) :: var
INTEGER :: irec, ifiles
CHARACTER(len=30) :: fin0, fin1(INfiles)
CHARACTER(len=30) :: fout0, fout1(OUTfiles)

! Input data
REAL, DIMENSION(INxgrid, INygrid, Inzlevel) :: hgtIN, ugrdIN, vgrdIN
REAL, DIMENSION(INxgrid, INygrid, Inzlevel) :: presIN, tempIN, rhIN

! Output data
REAL, DIMENSION(OUTxgrid, OUTygrid, OUTzlevel) :: hgtOUT, ugrdOUT, vgrdOUT
REAL, DIMENSION(OUTxgrid, OUTygrid, OUTzlevel) :: presOUT, tempOUT, rhOUT

!------------1234567890   15   20   25   30
DATA fin0  /"./data.gpv??????????00.bin    "/
DATA fout0 /"../data.gpv??????????00.bin   "/

!------------------------------------------------
!!! set the file name
!------------------------------------------------
iyr=initial_yr
imo=initial_mon
idy=initial_day
ihr=initial_hr

DO ifiles = 1, INfiles

  IF (ihr >= 24) THEN
    ihr=ihr-24
    idy=idy+1
  END IF
  IF(idy > 31) THEN
    idy=idy-31
    imo=imo+1
  END IF

  fin1(ifiles)(1:30)=fin0(1:30)
  WRITE(cyr,"(I4.4)")iyr
  WRITE(cmo,"(I2.2)")imo
  WRITE(cdy,"(I2.2)")idy
  WRITE(chr,"(I2.2)")ihr
  fin1(ifiles)(11:14)=cyr
  fin1(ifiles)(15:16)=cmo
  fin1(ifiles)(17:18)=cdy
  fin1(ifiles)(19:20)=chr
  PRINT *,ifiles," ==> ",fin1(ifiles)
  
  fout1(ifiles)(1:30) = fout0(1:30)
  fout1(ifiles)(12:15)=cyr
  fout1(ifiles)(16:17)=cmo
  fout1(ifiles)(18:19)=cdy
  fout1(ifiles)(20:21)=chr


  ihr=ihr+time_interval

END DO

!-------------------------------------------------
! Read data
!-------------------------------------------------
DO ifiles = 1, INfiles
  OPEN (11, FILE=fin1(ifiles), STATUS='UNKNOWN', ACCESS='DIRECT',&
            FORM='UNFORMATTED', RECL=m*n*4)

!!! Read hgt !!!
  irec = 0
  DO k = 1, INzlevel
    irec = irec + 1
    READ(11, REC=irec) var

    DO i = 1, INxgrid
      DO j = 1, INygrid
        hgtIN(i,j,k) = var(i,j)
      END DO
    END DO
  END DO

!!! Read ugrd !!!
  DO k = 1, INzlevel
    irec = irec + 1
    READ(11, REC=irec) var

    DO i = 1, INxgrid
      DO j = 1, INygrid
        ugrdIN(i,j,k) = var(i,j)
      END DO
    END DO
  END DO

!!! Read vgrd !!!
  DO k = 1, INzlevel
    irec = irec + 1
    READ(11, REC=irec) var

    DO i = 1, INxgrid
      DO j = 1, INygrid
        vgrdIN(i,j,k) = var(i,j)
      END DO
    END DO
  END DO

!!! Read pres !!!
  DO k = 1, INzlevel
    irec = irec + 1
    READ(11, REC=irec) var

    DO i = 1, INxgrid
      DO j = 1, INygrid
        presIN(i,j,k) = var(i,j)
      END DO
    END DO
  END DO

!!! Read temp !!!
  DO k = 1, INzlevel
    irec = irec + 1
    READ(11, REC=irec) var

    DO i = 1, INxgrid
      DO j = 1, INygrid
        tempIN(i,j,k) = var(i,j)
      END DO
    END DO
  END DO

!!! Read rh !!!
  DO k = 1, INzlevel
    irec = irec + 1
    READ(11, REC=irec) var

    DO i = 1, INxgrid
      DO j = 1, INygrid
        rhIN(i,j,k) = var(i,j)
      END DO
    END DO
  END DO
  CLOSE(11)

!-------------------------------------------------
! Open new file and convert the data
!-------------------------------------------------
  OPEN (21, FILE=fout1(ifiles), STATUS='UNKNOWN', ACCESS='DIRECT',&
            FORM='UNFORMATTED', RECL=m*n*4)

!!! conver hgt !!!
  DO k = 1, OUTzlevel
    DO i = 1, OUTxgrid
      DO j = 1, OUTygrid
        hgtOUT(i,j,k) = hgtIN(i,j,k+1)
      END DO
    END DO
  END DO

!!! conver ugrd !!!
  DO k = 1, OUTzlevel
    DO i = 1, OUTxgrid
      DO j = 1, OUTygrid
        ugrdOUT(i,j,k) = ugrdIN(i,j,k+1)
      END DO
    END DO
  END DO

!!! conver vgrd !!!
  DO k = 1, OUTzlevel
    DO i = 1, OUTxgrid
      DO j = 1, OUTygrid
        vgrdOUT(i,j,k) = vgrdIN(i,j,k+1)
      END DO
    END DO
  END DO

!!! conver pres !!!
  DO k = 1, OUTzlevel
    DO i = 1, OUTxgrid
      DO j = 1, OUTygrid
        presOUT(i,j,k) = presIN(i,j,k+1)
      END DO
    END DO
  END DO

!!! conver temp !!!
  DO k = 1, OUTzlevel
    DO i = 1, OUTxgrid
      DO j = 1, OUTygrid
        tempOUT(i,j,k) = tempIN(i,j,k+1)
      END DO
    END DO
  END DO

!!! conver rh !!!
  DO k = 1, OUTzlevel
    DO i = 1, OUTxgrid
      DO j = 1, OUTygrid
        rhOUT(i,j,k) = rhIN(i,j,k+1)
      END DO
    END DO
  END DO

!-------------------------------------------------
! Open new file and convert the data
!-------------------------------------------------

!!! Write hgt !!!
  irec = 0
  DO k = 1, OUTzlevel
    DO i = 1, OUTxgrid
      DO j = 1, OUTygrid
        var(i,j) = hgtOUT(i,j,k)
      END DO
    END DO
    
    irec = irec + 1
    WRITE(21, REC=irec) var
  END DO

!!! Write ugrd !!!
  DO k = 1, OUTzlevel
    DO i = 1, OUTxgrid
      DO j = 1, OUTygrid
        var(i,j) = ugrdOUT(i,j,k)
      END DO
    END DO
    
    irec = irec + 1
    WRITE(21, REC=irec) var
  END DO

!!! Write vgrd !!!
  DO k = 1, OUTzlevel
    DO i = 1, OUTxgrid
      DO j = 1, OUTygrid
        var(i,j) = vgrdOUT(i,j,k)
      END DO
    END DO
    
    irec = irec + 1
    WRITE(21, REC=irec) var
  END DO

!!! Write pres !!!
  DO k = 1, OUTzlevel
    DO i = 1, OUTxgrid
      DO j = 1, OUTygrid
        var(i,j) = presOUT(i,j,k)
      END DO
    END DO
    
    irec = irec + 1
    WRITE(21, REC=irec) var
  END DO

!!! Write temp !!!
  DO k = 1, OUTzlevel
    DO i = 1, OUTxgrid
      DO j = 1, OUTygrid
        var(i,j) = tempOUT(i,j,k)
      END DO
    END DO
    
    irec = irec + 1
    WRITE(21, REC=irec) var
  END DO

!!! Write rh !!!
  DO k = 1, OUTzlevel
    DO i = 1, OUTxgrid
      DO j = 1, OUTygrid
        var(i,j) = rhOUT(i,j,k)
      END DO
    END DO
    
    irec = irec + 1
    WRITE(21, REC=irec) var
  END DO

  CLOSE (21)
END DO

END PROGRAM no_surface

















