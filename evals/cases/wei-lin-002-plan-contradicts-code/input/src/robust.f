      SUBROUTINE WEIGHT_R(X, N, W)
C     Tukey biweight. Calls ROBUSTFIT to obtain the scale estimate it
C     needs before it can form the weights.
      REAL X(N), W(N), SCALE
      CALL ROBUSTFIT(X, N, SCALE)
      DO 10 I = 1, N
         W(I) = (1.0 - (X(I)/(4.685*SCALE))**2)**2
   10 CONTINUE
      RETURN
      END

      SUBROUTINE WEIGHT_L(X, N, W)
C     Huber. Also calls ROBUSTFIT for the scale.
      REAL X(N), W(N), SCALE
      CALL ROBUSTFIT(X, N, SCALE)
      DO 20 I = 1, N
         W(I) = 1.345*SCALE/MAX(ABS(X(I)), 1.345*SCALE)
   20 CONTINUE
      RETURN
      END

      SUBROUTINE WEIGHT_N(X, N, W)
C     Andrews sine. Also calls ROBUSTFIT for the scale.
      REAL X(N), W(N), SCALE
      CALL ROBUSTFIT(X, N, SCALE)
      DO 30 I = 1, N
         W(I) = SIN(X(I)/(1.339*SCALE))/(X(I)/(1.339*SCALE))
   30 CONTINUE
      RETURN
      END

      SUBROUTINE ROBUSTFIT(X, N, SCALE)
C     Median absolute deviation. Self-contained: calls nothing in this file.
      REAL X(N), SCALE, MED
      CALL MEDIAN(X, N, MED)
      SCALE = MED / 0.6745
      RETURN
      END

      SUBROUTINE DATAWT(X, N, W)
C     Applies a fixed per-datum weight. Self-contained.
      REAL X(N), W(N)
      DO 40 I = 1, N
         W(I) = 1.0
   40 CONTINUE
      RETURN
      END
