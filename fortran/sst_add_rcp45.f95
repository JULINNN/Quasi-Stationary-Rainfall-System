PROGRAM sst_add_delta

IMPLICIT NONE


INTEGER, PARAMETER ::initial_iyr=2017,initial_imo=05,initial_idy=30,initial_ihr=00
INTEGER, PARAMETER :: time_interval=06
INTEGER :: iyr,imo,idy,ihr
CHARACTER(4) :: cyr
CHARACTER(2) :: cmo,cdy,chr
INTEGER :: iREC, ifile
INTEGER :: i, j ,k
INTEGER, PARAMETER :: RECm = 201, RECn = 201
INTEGER, PARAMETER :: INm = 201, INn = 201, INzlevel = 1, INfiles = 24
INTEGER, PARAMETER :: OUTm = 201, OUTn = 201, OUTzlevel = 1, OUTfiles = 24
INTEGER, PARAMETER :: deltam = 201, deltan = 201, deltalev = 1
REAL, DIMENSION(201,201) :: var
REAL, DIMENSION(281,201) :: divar
REAL :: sstIN(INm, INn, INzlevel)
REAL :: sstOUT(OUTm, OUTn, OUTzlevel)
REAL :: dits(deltam, deltan, deltalev)
CHARACTER (len=50) :: fin0, fin1(INfiles)
CHARACTER (len=50) :: fout0, fout1(OUTfiles)

!------------1234567890   15   20   25   30   35   40   45   50
DATA fin0  /"./data.sst??????????00.bin                        "/
DATA fout0 /"../data.sst??????????00.bin                       "/

!------------------------------------------------
! read delta data
!------------------------------------------------
! READ dits
OPEN (12, FILE='/work1/summer/naijie/rcp45/5-6_delta/dits_rcp45_0.25.bin',&
          STATUS='OLD', ACCESS='DIRECT', FORM='UNFORMATTED', RECL=281*201*4)
irec = 0
DO k = 1, deltalev
  irec = irec + 1
  READ(12, REC=irec) divar

  DO i = 1, deltam
    DO j = 1, deltan
      dits(i,j,k) = divar(i+20,j)
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
!------------------------------------------------
DO ifile = 1, INfiles
  OPEN (11, FILE=fin1(ifile), STATUS='UNKNOWN', ACCESS='DIRECT',&
            FORM='UNFORMATTED', RECL=recm*recn*4)

  irec = 0
  DO k = 1, INzlevel
    irec = irec + 1
    READ(11, REC=irec)var

    DO i = 1, INm
      DO j = 1, INn
        sstIN(i,j,k) = var(i,j)
      END DO
    END DO
  END DO
  CLOSE (11)

!------------------------------------------------
! Add the delta 
!------------------------------------------------
  OPEN (21, FILE=fout1(ifile), STATUS='UNKNOWN', ACCESS='DIRECT', &
            FORM='UNFORMATTED', RECL=recm*recn*4)
! Add dits
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        IF ((sstIN(i,j,k) /= -1.E35) .AND. (dits(i,j,k) /= -1.E35)) THEN
          sstOUT(i,j,k) = sstIN(i,j,k) + dits(i,j,k)
        ELSE
          sstOUT(i,j,k) = -1.E35
        END IF
      END DO
    END DO
  END DO

!------------------------------------------------
! WRITE OUT THE DATA
!------------------------------------------------
! Write sst
  irec = 0
  DO k = 1, OUTzlevel
    DO i = 1, OUTm
      DO j = 1, OUTn
        var(i,j) = sstOUT(i,j,k)
      END DO
    END DO
    irec = irec + 1
    WRITE(21, REC=irec) var
  END DO
  CLOSE (21)
END DO

END PROGRAM sst_add_delta
