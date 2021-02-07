PROGRAM gpv_add_delta

! Purpose
!  adding the delta
!
! Version
! LIN NAI CHIEH 2019.07.23

IMPLICIT NONE

INTEGER, PARAMETER :: RECm = 201, RECn = 201
INTEGER, PARAMETER :: INm = 201, INn = 201, INzlevel = 26, INfiles = 24
INTEGER, PARAMETER :: OUTm = 201, OUTn = 201, OUTzlevel = 26, OUTfiles = 24
INTEGER, PARAMETER :: deltam = 201, deltan = 201, deltalev = 26
INTEGER, PARAMETER :: initial_iyr=2017,initial_imo=05,initial_idy=30,initial_ihr=00
INTEGER, PARAMETER :: time_interval=06
INTEGER :: iyr,imo,idy,ihr
CHARACTER(4) :: cyr
CHARACTER(2) :: cmo,cdy,chr
REAL, DIMENSION(201,201) :: var
REAL, DIMENSION(201,201) :: divar
INTEGER :: iREC, ifile
INTEGER :: i, j ,k
CHARACTER (len=50) :: fin0, fin1(INfiles)
CHARACTER (len=50) :: fout0, fout1(OUTfiles)

! INPUT DATA
REAL :: hgtIN(INm, INn, INzlevel), ugrdIN(INm, INn, INzlevel)
REAL :: vgrdIN(INm, INn, INzlevel), presIN(INm, INn, INzlevel)
REAL :: tempIN(INm, INn, INzlevel), rhIN(INm, INn, INzlevel)

! OUTPUT DATA
REAL :: hgtOUT(OUTm, OUTn, OUTzlevel), ugrdOUT(OUTm, OUTn, OUTzlevel)
REAL :: vgrdOUT(OUTm, OUTn, OUTzlevel), presOUT(OUTm, OUTn, OUTzlevel)
REAL :: tempOUT(OUTm, OUTn, OUTzlevel), rhOUT(OUTm, OUTn, OUTzlevel)
REAL :: qOUT(OUTm, OUTn, OUTzlevel)
REAL :: rOUT(OUTm, OUTn, OUTzlevel)
! DELTA DATA
REAL :: dizg(deltam, deltan, deltalev), diua(deltam, deltan, deltalev)
REAL :: diva(deltam, deltan, deltalev)
REAL :: dita(deltam, deltan, deltalev), dihus(deltam, deltan, deltalev)

! Humidity parameter
REAL, PARAMETER :: L = 2.5*1000000
REAL, PARAMETER :: Mv = 0.018015
REAL, PARAMETER :: Rstar = 8.314
REAL :: var_exp, e, q, es, dt, t, r
var_exp = L*Mv/Rstar
!------------1234567890   15   20   25   30   35   40   45   50
DATA fin0  /"./data.gpv??????????00.bin                        "/
DATA fout0 /"../data.gpv??????????00.bin                       "/

!------------------------------------------------
! read delta data
!------------------------------------------------
! READ dizg
OPEN (12, FILE='/work1/summer/naijie/rcp45/5-6_delta/dizg_rcp45_0.25_interp.bin',&
          STATUS='OLD', ACCESS='DIRECT', FORM='UNFORMATTED', RECL=201*201*4) 
irec = 0
DO k = 1, deltalev
  irec = irec + 1
  READ(12, REC=irec) divar
  
  DO i = 1, deltam
    DO j = 1, deltan
      dizg(i,j,k) = divar(i,j)
    END DO
  END DO
END DO
CLOSE(12)

! read diua
OPEN (12, FILE='/work1/summer/naijie/rcp45/5-6_delta/diua_rcp45_0.25_interp.bin',&
          STATUS='OLD', ACCESS='DIRECT', FORM='UNFORMATTED', RECL=201*201*4) 
irec = 0
DO k = 1, deltalev
  irec = irec + 1
  READ(12, REC=irec) divar
  
  DO i = 1, deltam
    DO j = 1, deltan
      diua(i,j,k) = divar(i,j)
    END DO
  END DO
END DO
CLOSE(12)

! read diva
OPEN (12, FILE='/work1/summer/naijie/rcp45/5-6_delta/diva_rcp45_0.25_interp.bin',&
          STATUS='OLD', ACCESS='DIRECT', FORM='UNFORMATTED', RECL=201*201*4) 
irec = 0
DO k = 1, deltalev
  irec = irec + 1
  READ(12, REC=irec) divar
  
  DO i = 1, deltam
    DO j = 1, deltan
      diva(i,j,k) = divar(i,j)
    END DO
  END DO
END DO
CLOSE(12)

! read dita
OPEN (12, FILE='/work1/summer/naijie/rcp45/5-6_delta/dita_rcp45_0.25_interp.bin',&
          STATUS='OLD', ACCESS='DIRECT', FORM='UNFORMATTED', RECL=201*201*4) 
irec = 0
DO k = 1, deltalev
  irec = irec + 1
  READ(12, REC=irec) divar
  
  DO i = 1, deltam
    DO j = 1, deltan
      dita(i,j,k) = divar(i,j)
    END DO
  END DO
END DO
CLOSE(12)

! read dihus
OPEN (12, FILE='/work1/summer/naijie/rcp45/5-6_delta/dihus_rcp45_0.25_interp.bin',&
          STATUS='OLD', ACCESS='DIRECT', FORM='UNFORMATTED', RECL=201*201*4) 
irec = 0
DO k = 1, deltalev
  irec = irec + 1
  READ(12, REC=irec) divar
  
  DO i = 1, deltam
    DO j = 1, deltan
      dihus(i,j,k) = divar(i,j)
    END DO
  END DO
END DO
CLOSE(12)

!------------------------------------------------
!!! set the file name
!------------------------------------------------
iyr=initial_iyr
imo=initial_imo
idy=initial_idy
ihr=initial_ihr

DO ifile = 1, INfiles

  IF (ihr >= 24) THEN
    ihr=ihr-24
    idy=idy+1
  END IF
  IF(idy > 31) THEN
    idy=idy-31
    imo=imo+1
  END IF

  fin1(ifile)(1:50)=fin0(1:50)
  WRITE(cyr,"(I4.4)")iyr
  WRITE(cmo,"(I2.2)")imo
  WRITE(cdy,"(I2.2)")idy
  WRITE(chr,"(I2.2)")ihr
  fin1(ifile)(11:14)=cyr
  fin1(ifile)(15:16)=cmo
  fin1(ifile)(17:18)=cdy
  fin1(ifile)(19:20)=chr
  PRINT *,ifile," ==> ",fin1(ifile)
  
  fout1(ifile)(1:50) = fout0(1:50)
  fout1(ifile)(12:15)=cyr
  fout1(ifile)(16:17)=cmo
  fout1(ifile)(18:19)=cdy
  fout1(ifile)(20:21)=chr


  ihr=ihr+time_interval

END DO
!------------------------------------------------
! read initial data

DO ifile = 1, INfiles
  OPEN (11, FILE=fin1(ifile), STATUS='UNKNOWN', ACCESS='DIRECT',&
            FORM='UNFORMATTED', RECL=recm*recn*4)

!======== read hgt ===========
  irec = 0
  DO k = 1, INzlevel            
    irec = irec + 1
    READ(11, REC=irec)var

    DO i = 1, INm
      DO j = 1, INn
        hgtIN(i,j,k) = var(i,j)
      END DO
    END DO
  END DO

!======== read u =============
  DO k = 1, INzlevel            
    irec = irec + 1
    READ(11, REC=irec)var

    DO i = 1, INm
      DO j = 1, INn
        ugrdIN(i,j,k) = var(i,j)
      END DO 
    END DO
  END DO

!======== read v =============
  DO k = 1, INzlevel           
    irec = irec + 1
    READ(11,REC=irec) var

    DO i = 1, INm
      DO j = 1, INn
        vgrdIN(i,j,k) = var(i,j)
      END DO
    END DO
  END DO

!======== read pres ==========
  DO k = 1, INzlevel          
    irec = irec + 1
    READ(11, REC=irec)var

    DO i = 1, INm
      DO j = 1, INn
        presIN(i,j,k) = var(i,j)
      END DO
    END DO
  END DO

!======== read temp ==========
  DO k = 1, INzlevel          
    irec = irec + 1
    READ(11, REC=irec)var

    DO i = 1, INm
      DO j = 1, INn
        tempIN(i,j,k) = var(i,j)
      END DO
    END DO
  END DO

!======== read RH ===========
  DO k = 1, INzlevel
    irec = irec + 1
    READ(11, REC=irec) var

    DO i = 1, INm
      DO j = 1, INn
        rhIN(i,j,k) = var(i,j)
      END DO
    END DO
  END DO
  CLOSE (11)
!------------------------------------------------
! Add the delta 
!------------------------------------------------
  OPEN (21, FILE=fout1(ifile), STATUS='UNKNOWN', ACCESS='DIRECT', &
            FORM='UNFORMATTED', RECL=recm*recn*4)
! Add dizg
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        IF ((hgtIN(i,j,k) /= -1.E35) .AND. (dizg(i,j,k) /= -1.E35)) THEN
          hgtOUT(i,j,k) = hgtIN(i,j,k) + dizg(i,j,k)
        ELSE
          hgtOUT(i,j,k) = -1.E35
        END IF
      END DO
    END DO
  END DO

! add diua
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        IF ((ugrdIN(i,j,k) /= -1.E35) .AND. (diua(i,j,k) /= -1.E35)) THEN
          ugrdOUT(i,j,k) = ugrdIN(i,j,k) + diua(i,j,k)
        ELSE
          ugrdOUT(i,j,k) = -1.E35
        END IF
      END DO
    END DO
  END DO
  
! add diva
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        IF ((vgrdIN(i,j,k) /= -1.E35) .AND. (diva(i,j,k) /= -1.E35)) THEN
          vgrdOUT(i,j,k) = vgrdIN(i,j,k) + diva(i,j,k)
        ELSE
          vgrdOUT(i,j,k) = -1.E35
        END IF
      END DO
    END DO
  END DO

! Fill pres
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        IF (presIN(i,j,k) /= -1.E35) THEN
          presOUT(i,j,k) = presIN(i,j,k)
        ELSE
          presOUT(i,j,k) = -1.E35
        END IF
      END DO
    END DO
  END DO

! add dita
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        IF ((tempIN(i,j,k) /= -1.E35) .AND. (dita(i,j,k) /= -1.E35)) THEN
          tempOUT(i,j,k) = tempIN(i,j,k) + dita(i,j,k)
        ELSE
          tempOUT(i,j,k) = -1.E35
        END IF
      END DO
    END DO
  END DO

! Convert RH to HUS and add dihus and convert hus to RH
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        IF((rhIN(i,j,k)/=-1.E35).AND.(dihus(i,j,k)/=-1.E35).AND.(tempIN(i,j,k)/=-1.E35).AND.(presIN(i,j,k)/=-1.E35))THEN
          t = 1./273.
          dt = (t - 1./tempIN(i,j,k))
          q = (0.622*rhIN(i,j,k)*6.11*EXP(var_exp*dt))/presIN(i,j,k)
          q = q + dihus(i,j,k)
          e = (q*(presIN(i,j,k)/100.))/0.622
          es = 6.11*EXP(var_exp*dt)
          rhOUT(i,j,k) = e/es*100.
          IF(rhOUT(i,j,k) > 100.0) THEN
            rhOUT(i,j,k) = 100.0
          ENDIF
        ELSE
          rhOUT(i,j,k) = -1.E35
        END IF
      END DO
    END DO
  END DO

! Convert RH to q and add delta q (optional)
!  DO k = 1, OUTzlevel
!    DO i = 1, OUTm
!      DO j = 1, OUTn
!        IF((rhIN(i,j,k)/=-1.E35).AND.(dihus(i,j,k)/=-1.E35).AND.(tempIN(i,j,k)/=-1.E35).AND.(presIN(i,j,k)/=-1.E35))THEN
!          t = 1./273.
!          dt = (t - 1./tempIN(i,j,k))
!          q = (0.622*rhIN(i,j,k)*6.11*EXP(var_exp*dt))/presIN(i,j,k)
!          q = q + dihus(i,j,k)
!          qOUT(i,j,k) = q 
!        ELSE
!          qOUT(i,j,k) = -1.E35
!        END IF
!      END DO
!    END DO
!  END DO

! Convert RH to q and add delta q and convert to r (optional)
!  DO k = 1, OUTzlevel
!    DO i = 1, OUTm
!      DO j = 1, OUTn
!        IF((rhIN(i,j,k)/=-1.E35).AND.(dihus(i,j,k)/=-1.E35).AND.(tempIN(i,j,k)/=-1.E35).AND.(presIN(i,j,k)/=-1.E35))THEN
!          t = 1./273.
!          dt = (t - 1./tempIN(i,j,k))
!          q = (0.622*rhIN(i,j,k)*6.11*EXP(var_exp*dt))/presIN(i,j,k)
!          q = q + dihus(i,j,k)
!          r = q / (1.-q)
!          rOUT(i,j,k) = r 
!        ELSE
!          rOUT(i,j,k) = -1.E35
!        END IF
!      END DO
!    END DO
!  END DO
!------------------------------------------------
!------------------------------------------------
!WRITE OUT THE DATA
!________________________________________________
! Write hgt 
  irec = 0
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        var(i,j) = hgtOUT(i,j,k)
      END DO
    END DO
    irec = irec + 1
    WRITE(21, REC=irec) var
  END DO

! Write U
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        var(i,j) = ugrdOUT(i,j,k)
      END DO
    END DO
    irec = irec + 1
    WRITE(21, REC=irec) var
  END DO

! Write v
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        var(i,j) = vgrdOUT(i,j,k)
      END DO
    END DO
    irec = irec + 1
    WRITE(21, REC=irec) var
  END DO

! Write pres
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        var(i,j) = presOUT(i,j,k)
      END DO
    END DO
    irec = irec + 1
    WRITE(21, REC=irec) var
  END DO

! Write temp
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        var(i,j) = tempOUT(i,j,k)
      END DO
    END DO
    irec = irec + 1
    WRITE(21, REC=irec) var
  END DO

! Write rh
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        var(i,j) = rhOUT(i,j,k)
      END DO
    END DO
    irec = irec + 1
    WRITE(21, REC=irec) var
  END DO

! Write q (optional)
!  DO k = 1, OUTzlevel
!    DO i = 1, OUTm
!      DO j = 1, OUTn
!        var(i,j) = qOUT(i,j,k)
!      END DO
!    END DO
!    irec = irec + 1
!    WRITE(21, REC=irec) var
!  END DO

! Write r (optional)
!  DO k = 1, OUTzlevel
!    DO i = 1, OUTm
!      DO j = 1, OUTn
!        var(i,j) = rOUT(i,j,k)
!      END DO
!    END DO
!    irec = irec + 1
!    WRITE(21, REC=irec) var
!  END DO

  CLOSE(21)
END DO

END PROGRAM gpv_add_delta
