$regfile = "m16adef.dat"
$crystal = 16000000

Config Lcd = 20 * 4
Config Lcdpin = Pin , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0 , E = Portc. 4 , Rs = Portc.5

Config Timer1 = Pwm , Pwm = 8 , Compare A Pwm = Clear Up , Compare B Pwm = Clear Up , Prescale = 1

Config Clock = soft
Config Date = Dmy , Separator = /

Config Adc = Single , Prescaler = Auto , Reference = Avcc

Config Pina.0 = Output
porta.0 = 0
Config Pina.1 = Output
porta.1 = 0
Config pina.3 = Input
Porta.3 = 0
Config pina.4 = Output
porta.4 = 1
Config pina.5 = Output
porta.5 = 1
Config pina.6 = Output
porta.6 = 1
Config pina.7 = Output
porta.7 = 1
Config PINB.0 = Input
Portb.0 = 1
Config PINB.1 = Input
Portb.1 = 1
Config PINB.2 = Input
Portb.2 = 1
Config pinb.3 = Output
Portb.3 = 1
Config Pinb.4 = Output
Portb.4 = 1
Config Pind.0 = Output
Portd.0 = 0
Config Pind.1 = Output
Portd.1 = 0
Config Pind.2 = Output
Portd.2 = 0
Config Pind.3 = Output
Portd.3 = 0
Config Pind.6 = Output
portd.6 = 1
Config Pind.7 = Output
Portd.7 = 0

Led_r Alias Porta.0
Led_b Alias Porta.1
Czujnik_ruchu Alias Pina.3
Komunikaty_odtworz Alias Porta.4
Komunikaty_nagraj Alias Porta.5
Komunikaty_kasuj Alias Porta.6
Komunikaty_nastepny_komunikat Alias Porta.7
Komunikaty_sygnal_zewnetrzny Alias Portb.3
Komunikaty_regulacja_glosnosci Alias Portb.4
Komunikaty_reset Alias Portd.6
Przycisk_1 Alias Pinb.2
Przycisk_2 Alias Pinb.1
Przycisk_3 Alias Pinb.0

Const Opoznienie_przycisk = 300

Dim Tryb_pracy As Byte
Dim Pomocnicza As Bit
Dim Licznik_1 As Byte
Dim Licznik_2 As Word
Dim Licznik_3 As Word
Dim Licznik_4 As Word
Dim Komunikaty_pomocnicza_1 As Byte
Dim Komunikaty_pomocnicza_2 As Byte
Dim Polecenie As Byte
Dim Polecenie_pomocnicza As Byte
Dim Temperatura_pomocnicza_1 As Word
Dim Temperatura_pomocnicza_2 As Single
Dim Temperatura As Byte
Dim Tryb_ustawien_1 As Byte
Dim Tryb_ustawien_2 As Byte
Dim Budzik_stan As Bit
Dim Budzik_pomocnicza_1 As Bit
Dim Budzik_pomocnicza_2 As Bit
Dim Budzik_godziny As Byte
Dim Budzik_minuty As Byte
Dim Kod_dostepu_stan As Bit
Dim Kod_1 As Byte
Dim Kod_2 As Byte
Dim Kod_3 As Byte
Dim Kod_4 As Byte
Dim Kod_1_pomocnicza As Byte
Dim Kod_2_pomocnicza As Byte
Dim Kod_3_pomocnicza As Byte
Dim Kod_4_pomocnicza As Byte
Dim Tryb_dozorcy_1 As Bit

Pwm1a = 0
Pwm1b = 255

Cursor Off

Deflcdchar 0 , 31 , 16 , 16 , 31 , 16 , 16 , 31 , 1
Deflcdchar 1 , 16 , 16 , 16 , 24 , 16 , 16 , 31 , 32
Deflcdchar 2 , 4 , 14 , 17 , 17 , 17 , 17 , 14 , 32
Deflcdchar 3 , 31 , 32 , 32 , 32 , 32 , 32 , 32 , 32
Deflcdchar 4 , 7 , 5 , 7 , 32 , 32 , 32 , 32 , 32
Deflcdchar 5 , 31 , 31 , 31 , 31 , 31 , 31 , 31 , 31
Deflcdchar 6 , 32 , 32 , 32 , 32 , 31 , 31 , 31 , 31
Deflcdchar 7 , 31 , 31 , 31 , 31 , 32 , 32 , 32 , 32

Start Adc

Enable Interrupts

Cls
Gosub Otwarte_oczy
Komunikaty_pomocnicza_2 = 1
Gosub Komunikaty_glosowe
Wait 5

Licznik_1 = 99

Date$ = "28/11/18"

Do

   If Tryb_pracy = 0 And Budzik_pomocnicza_1 = 0 And Przycisk_2 = 0 Then
   Waitms Opoznienie_przycisk
   Tryb_pracy = 1
   Do
   Loop Until Przycisk_2 = 1
   End If

   If Tryb_pracy = 0 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk

      If Budzik_pomocnicza_1 = 1 Then
      Budzik_pomocnicza_1 = 0
      Budzik_pomocnicza_2 = 1
      Led_b = 0
      Komunikaty_reset = 0
      Waitms 200
      Komunikaty_reset = 1
      Else

         If Kod_dostepu_stan = 1 Then
         Tryb_pracy = 2
         Gosub Otwarte_oczy
         Komunikaty_pomocnicza_2 = 2
         Gosub Komunikaty_glosowe
         Wait 20
         Else
         Cls
         Locate 1 , 1
         Lcd "USTAW KOD DOST" ; Chr(0) ; "PU"
         Wait 3
         End If

      End If

   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_pracy = 0 And Budzik_pomocnicza_1 = 0 And Przycisk_1 = 0 Then
   Waitms Opoznienie_przycisk
   Tryb_pracy = 3
   Do
   Loop Until Przycisk_1 = 1
   End If

   Select Case Tryb_pracy
   Case 0:
   Gosub Tryb_standardowy
   Case 1:
   Gosub Tryb_uspienia
   Case 2:
   Gosub Tryb_dozorcy
   Case 3:
   Gosub Tryb_ustawien
   End Select

   If Polecenie_pomocnicza <> Polecenie Then

      Select Case Polecenie
      Case 0:
      Case 100:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA:"
      Locate 2 , 1
      Lcd "DATA"
      Case 101:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA:"
      Locate 2 , 1
      Lcd "CZAS"
      Case 102:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA:"
      Locate 2 , 1
      Lcd "BUDZIK"
      Case 103:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA:"
      Locate 2 , 1
      Lcd "KOMUNIKATY G" ; Chr(1) ; "OSOWE"
      Case 104:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA:"
      Locate 2 , 1
      Lcd "KOD DOST" ; Chr(0) ; "PU"
      Case 105:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "DATA:"
      Locate 3 , 1
      Lcd Date$
      Locate 4 , 1
      Lcd Chr(3) ; Chr(3)
      Case 106:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "DATA:"
      Locate 3 , 1
      Lcd Date$
      Locate 4 , 4
      Lcd Chr(3) ; Chr(3)
      Case 107:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "DATA:"
      Locate 3 , 1
      Lcd Date$
      Locate 4 , 7
      Lcd Chr(3) ; Chr(3)
      Case 108:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "CZAS:"
      Locate 3 , 1

         If _hour < 10 Then Lcd "0"

      Lcd _hour ; ":"

         If _min < 10 Then Lcd "0"

      Lcd _min
      Locate 4 , 1
      Lcd Chr(3) ; Chr(3)
      Case 109:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "CZAS:"
      Locate 3 , 1

         If _hour < 10 Then Lcd "0"

      Lcd _hour ; ":"

         If _min < 10 Then Lcd "0"

      Lcd _min
      Locate 4 , 4
      Lcd Chr(3) ; Chr(3)
      Case 110:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "BUDZIK:"
      Locate 3 , 1

         If Budzik_godziny < 10 Then Lcd "0"

      Lcd Budzik_godziny ; ":"

         If Budzik_minuty < 10 Then Lcd "0"

      Lcd Budzik_minuty

         If Budzik_stan = 0 Then
         Locate 3 , 7
         Lcd "WY" ; Chr(1) ; "."
         Else
         Locate 3 , 7
         Lcd "W" ; Chr(1) ; "."
         End If

      Locate 4 , 1
      Lcd Chr(3) ; Chr(3)
      Case 111:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "BUDZIK:"
      Locate 3 , 1

         If Budzik_godziny < 10 Then Lcd "0"

      Lcd Budzik_godziny ; ":"

         If Budzik_minuty < 10 Then Lcd "0"

      Lcd Budzik_minuty

         If Budzik_stan = 0 Then
         Locate 3 , 7
         Lcd "WY" ; Chr(1) ; "."
         Else
         Locate 3 , 7
         Lcd "W" ; Chr(1) ; "."
         End If

      Locate 4 , 4
      Lcd Chr(3) ; Chr(3)
      Case 112:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "BUDZIK:"
      Locate 3 , 1

         If Budzik_godziny < 10 Then Lcd "0"

      Lcd Budzik_godziny ; ":"

         If Budzik_minuty < 10 Then Lcd "0"

      Lcd Budzik_minuty

         If Budzik_stan = 0 Then
         Locate 3 , 7
         Lcd "WY" ; Chr(1) ; "."
         Locate 4 , 7
         Lcd Chr(3) ; Chr(3) ; Chr(3) ; Chr(3);
         Else
         Locate 3 , 7
         Lcd "W" ; Chr(1) ; "."
         Locate 4 , 7
         Lcd Chr(3) ; Chr(3) ; Chr(3)
         End If
      Case 113:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "KOMUNIKATY G" ; Chr(1) ; "OSOWE:"
      Locate 3 , 1
      Lcd "RESETUJ"
      Case 114:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "KOMUNIKATY G" ; Chr(1) ; "OSOWE:"
      Locate 3 , 1
      Lcd "NAGRAJ"
      Case 115:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "KOMUNIKATY G" ; Chr(1) ; "OSOWE:"
      Locate 3 , 1
      Lcd "ODTW" ; Chr(2) ; "RZ"
      Case 116:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "KOMUNIKATY G" ; Chr(1) ; "OSOWE:"
      Locate 3 , 1
      Lcd "KASUJ"
      Case 117:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "KOD DOST";chr(0);"PU:"
      Locate 3 , 1
      Lcd Kod_1 ; "***"
      Locate 4 , 1
      Lcd Chr(3)
      Case 118:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "KOD DOST";chr(0);"PU:"
      Locate 3 , 1
      Lcd "*" ; Kod_2 ; "**"
      Locate 4 , 2
      Lcd Chr(3)
      Case 119:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "KOD DOST";chr(0);"PU:"
      Locate 3 , 1
      Lcd "**" ; Kod_3 ; "*"
      Locate 4 , 3
      Lcd Chr(3)
      Case 120:
      Cls
      Locate 1 , 1
      Lcd "USTAWIENIA/"
      Locate 2 , 1
      Lcd "KOD DOST";chr(0);"PU:"
      Locate 3 , 1
      Lcd "***" ; Kod_4
      Locate 4 , 4
      Lcd Chr(3)
      Case 121:
      Cls
      Locate 1 , 1
      Lcd "PODAJ KOD DOST";chr(0);"PU:"
      Locate 2 , 1
      Lcd Kod_1_pomocnicza ; "*** A"
      Locate 3 , 1
      Lcd Chr(3)
      Case 122:
      Cls
      Locate 1 , 1
      Lcd "PODAJ KOD DOST";chr(0);"PU:"
      Locate 2 , 1
      Lcd "*";Kod_2_pomocnicza ; "** A"
      Locate 3 , 2
      Lcd Chr(3)
      Case 123:
      Cls
      Locate 1 , 1
      Lcd "PODAJ KOD DOST";chr(0);"PU:"
      Locate 2 , 1
      Lcd "**";Kod_3_pomocnicza ; "* A"
      Locate 3 , 3
      Lcd Chr(3)
      Case 124:
      Cls
      Locate 1 , 1
      Lcd "PODAJ KOD DOST";chr(0);"PU:"
      Locate 2 , 1
      Lcd "***";Kod_4_pomocnicza ; " A"
      Locate 3 , 4
      Lcd Chr(3)
      Case 125:
      Cls
      Locate 1 , 1
      Lcd "PODAJ KOD DOST";chr(0);"PU:"
      Locate 2 , 1
      Lcd "**** A"
      Locate 3 ,6
      Lcd Chr(3)
      End Select

   End If

   Polecenie_pomocnicza = Polecenie

Loop
End

Tryb_standardowy:

Incr Licznik_1

If Licznik_1 = 100 Then
Licznik_1 = 0
Temperatura_pomocnicza_1 = Getadc(2)
Temperatura_pomocnicza_2 = Temperatura_pomocnicza_1 * 0.00488
Temperatura_pomocnicza_2 = Temperatura_pomocnicza_2 / 0.010
Temperatura = Round(temperatura_pomocnicza_2)
End If

If Czujnik_ruchu = 1 Then
Licznik_2 = 0
Pomocnicza = 1
End If

If Pomocnicza = 1 And Budzik_pomocnicza_1 = 0 Then
Locate 1 , 1
Lcd "      " ; Date$ ; "      "
Locate 2 , 1
Lcd "      " ; Time$ ; "      "
Locate 3 , 1
Lcd "        " ; Temperatura ; Chr(4) ; "C        "
Locate 4 , 1
Lcd "                    "
End If

Incr Licznik_2

If Licznik_2 = 290 And Pomocnicza = 0 Then Gosub Zamkniete_oczy

If Licznik_2 = 300 Then
Licznik_2 = 0
Pomocnicza = 0
Gosub Otwarte_oczy
End If

Gosub Budzik
Waitms 50

Return

Tryb_uspienia:

Pwm1b = 0
Gosub Zamkniete_oczy

If Przycisk_2 = 0 Then
Waitms Opoznienie_przycisk
Pwm1b = 255
Cls
Gosub Otwarte_oczy
Komunikaty_pomocnicza_2 = 1
Gosub Komunikaty_glosowe
Wait 5
Tryb_pracy = 0
Do
Loop Until Przycisk_2 = 1
End If

Gosub Budzik

Return

Tryb_dozorcy:

If Czujnik_ruchu = 1 And Tryb_dozorcy_1 = 0 Then
Tryb_dozorcy_1 = 1
Komunikaty_pomocnicza_2 = 3
Gosub Komunikaty_glosowe
Wait 10
End If

Incr Licznik_2

If Licznik_2 = 290 And Tryb_dozorcy_1 = 0 Then Gosub Zamkniete_oczy

If Licznik_2 = 300 And Tryb_dozorcy_1 = 0 Then
Licznik_2 = 0
Gosub Otwarte_oczy
End If

If Tryb_dozorcy_1 = 1 Then
Gosub Kod_dostepu
Incr Licznik_3

   If Licznik_3 = 200 Then
   Led_r = 1
   Pwm1a = 255
   End If

Incr Licznik_4

   If Licznik_4 = 1200 Then
   Polecenie = 0
   Tryb_dozorcy_1 = 0
   Tryb_ustawien_2 = 0
   Kod_1_pomocnicza = 0
   Kod_2_pomocnicza = 0
   Kod_3_pomocnicza = 0
   Kod_4_pomocnicza = 0
   Licznik_2 = 0
   Licznik_3 = 0
   Licznik_4 = 0
   Led_r = 0
   Pwm1a = 0
   Gosub Otwarte_oczy
   End If

End If

Waitms 50

Return

Tryb_ustawien:

If Kod_dostepu_stan = 1 Then
Gosub Kod_dostepu
Else

   If Tryb_ustawien_1 = 0 Then

      If Przycisk_1 = 0 Then
      Waitms Opoznienie_przycisk
      Incr Tryb_ustawien_2
      Do
      Loop Until Przycisk_1 = 1
      End If

      If Tryb_ustawien_2 = 5 Then Tryb_ustawien_2 = 0

      Select Case Tryb_ustawien_2
      Case 0:
      Polecenie = 100
      Case 1:
      Polecenie = 101
      Case 2:
      Polecenie = 102
      Case 3:
      Polecenie = 103
      Case 4:
      Polecenie = 104
      End Select

   End If

   If Tryb_ustawien_1 = 0 And Tryb_ustawien_2 = 0 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Tryb_ustawien_1 = 1
   Tryb_ustawien_2 = 0
   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 1 Then

      If Przycisk_1 = 0 Then
      Waitms Opoznienie_przycisk
      Incr Tryb_ustawien_2
      Do
      Loop Until Przycisk_1 = 1
      End If

      If Tryb_ustawien_2 = 3 Then Tryb_ustawien_2 = 0

      Select Case Tryb_ustawien_2
      Case 0:
      Polecenie = 105
      Case 1:
      Polecenie = 106
      Case 2:
      Polecenie = 107
      End Select

   End If

   If Tryb_ustawien_1 = 1 And Tryb_ustawien_2 = 0 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Polecenie = 0
   Incr _day
   Do
   Loop Until Przycisk_3 = 1
   End If

   If _month = 2 Then

      If _year = 20 Or _year = 24 Or _year = 28 Or _year = 32 Or _year = 36 Or _year = 40 Or _year = 44 Or _year = 48 Or _year = 52 Or _year = 56 Or _year = 60 Or _year = 64 Or _year = 68 Or _year = 72 Or _year = 76 Or _year = 80 Or _year = 84 Or _year = 88 Or _year = 92 Or _year = 96 Then

         If _day = 30 Then _day = 1

      Else

         If _day = 29 Then _day = 1

      End If

   End If

   If _month = 4 Or _month = 6 Or _month = 9 Or _month = 11 Then

      If _day = 31 Then _day = 1

   End If

   If _month = 1 Or _month = 3 Or _month = 5 Or _month = 7 Or _month = 8 Or _month = 10 Or _month = 12 Then

      If _day = 32 Then _day = 1

   End If

   If Tryb_ustawien_1 = 1 And Tryb_ustawien_2 = 1 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Polecenie = 0
   Incr _month

      If _month = 13 Then _month = 1

   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 1 And Tryb_ustawien_2 = 2 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Polecenie = 0
   Incr _year

      If _year = 100 Then _year = 0

   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 1 And Przycisk_2 = 0 Then
   Waitms Opoznienie_przycisk
   Tryb_ustawien_1 = 0
   Tryb_ustawien_2 = 0
   Do
   Loop Until Przycisk_2 = 1
   End If

   If Tryb_ustawien_1 = 0 And Tryb_ustawien_2 = 1 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Tryb_ustawien_1 = 2
   Tryb_ustawien_2 = 0
   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 2 Then

      If Przycisk_1 = 0 Then
      Waitms Opoznienie_przycisk
      Incr Tryb_ustawien_2
      Do
      Loop Until Przycisk_1 = 1
      End If

      If Tryb_ustawien_2 = 2 Then Tryb_ustawien_2 = 0

      Select Case Tryb_ustawien_2
      Case 0:
      Polecenie = 108
      Case 1:
      Polecenie = 109
      End Select

   End If

   If Tryb_ustawien_1 = 2 And Tryb_ustawien_2 = 0 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Polecenie = 0
   _sec = 0
   Incr _hour

      If _hour = 24 Then _hour = 0

   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 2 And Tryb_ustawien_2 = 1 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Polecenie = 0
   _sec = 0
   Incr _min

      If _min = 60 Then _min = 0

   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 2 And Przycisk_2 = 0 Then
   Waitms Opoznienie_przycisk
   _sec = 0
   Tryb_ustawien_1 = 0
   Tryb_ustawien_2 = 1
   Do
   Loop Until Przycisk_2 = 1
   End If

   If Tryb_ustawien_1 = 0 And Tryb_ustawien_2 = 2 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Tryb_ustawien_1 = 3
   Tryb_ustawien_2 = 0
   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 3 Then

      If Przycisk_1 = 0 Then
      Waitms Opoznienie_przycisk
      Incr Tryb_ustawien_2
      Do
      Loop Until Przycisk_1 = 1
      End If

      If Tryb_ustawien_2 = 3 Then Tryb_ustawien_2 = 0

      Select Case Tryb_ustawien_2
      Case 0:
      Polecenie = 110
      Case 1:
      Polecenie = 111
      Case 2:
      Polecenie = 112
      End Select

   End If

   If Tryb_ustawien_1 = 3 And Tryb_ustawien_2 = 0 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Polecenie = 0
   Incr Budzik_godziny

      If Budzik_godziny = 24 Then Budzik_godziny = 0

   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 3 And Tryb_ustawien_2 = 1 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Polecenie = 0
   Incr Budzik_minuty

      If Budzik_minuty = 60 Then Budzik_minuty = 0

   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 3 And Tryb_ustawien_2 = 2 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Polecenie = 0
   Toggle Budzik_stan
   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 3 And Przycisk_2 = 0 Then
   Waitms Opoznienie_przycisk
   Tryb_ustawien_1 = 0
   Tryb_ustawien_2 = 2
   Do
   Loop Until Przycisk_2 = 1
   End If

   If Tryb_ustawien_1 = 0 And Tryb_ustawien_2 = 3 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Tryb_ustawien_1 = 4
   Tryb_ustawien_2 = 0
   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 4 Then

      If Przycisk_1 = 0 Then
      Waitms Opoznienie_przycisk
      Incr Tryb_ustawien_2
      Do
      Loop Until Przycisk_1 = 1
      End If

      If Tryb_ustawien_2 = 4 Then Tryb_ustawien_2 = 0

      Select Case Tryb_ustawien_2
      Case 0:
      Polecenie = 113
      Case 1:
      Komunikaty_sygnal_zewnetrzny = 1
      Komunikaty_nagraj = 1
      Polecenie = 114
      Case 2:
      Komunikaty_odtworz = 1
      Polecenie = 115
      Case 3:
      Komunikaty_kasuj = 1
      Polecenie = 116
      End Select

   End If

   If Tryb_ustawien_1 = 4 And Tryb_ustawien_2 = 0 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Komunikaty_reset = 0
   Waitms 200
   Komunikaty_reset = 1
   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 4 And Tryb_ustawien_2 = 1 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Komunikaty_sygnal_zewnetrzny = 0
   Komunikaty_nagraj = 0
   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 4 And Tryb_ustawien_2 = 2 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Komunikaty_reset = 0
   Waitms 200
   Komunikaty_reset = 1
   Waitms 200
   Komunikaty_odtworz = 0
   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 4 And Tryb_ustawien_2 = 3 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Komunikaty_kasuj = 0
   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 4 And Przycisk_2 = 0 Then
   Waitms Opoznienie_przycisk
   Tryb_ustawien_1 = 0
   Tryb_ustawien_2 = 3
   Do
   Loop Until Przycisk_2 = 1
   End If

   If Tryb_ustawien_1 = 0 And Tryb_ustawien_2 = 4 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Tryb_ustawien_1 = 5
   Tryb_ustawien_2 = 0
   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 5 Then

      If Przycisk_1 = 0 Then
      Waitms Opoznienie_przycisk
      Incr Tryb_ustawien_2
      Do
      Loop Until Przycisk_1 = 1
      End If

      If Tryb_ustawien_2 = 4 Then Tryb_ustawien_2 = 0

      Select Case Tryb_ustawien_2
      Case 0:
      Polecenie = 117
      Case 1:
      Polecenie = 118
      Case 2:
      Polecenie = 119
      Case 3:
      Polecenie = 120
      End Select

   End If

   If Tryb_ustawien_1 = 5 And Tryb_ustawien_2 = 0 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Polecenie = 0
   Incr Kod_1

      If Kod_1 = 10 Then Kod_1 = 0

   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 5 And Tryb_ustawien_2 = 1 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Polecenie = 0
   Incr Kod_2

      If Kod_2 = 10 Then Kod_2 = 0

   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 5 And Tryb_ustawien_2 = 2 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Polecenie = 0
   Incr Kod_3

      If Kod_3 = 10 Then Kod_3 = 0

   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 5 And Tryb_ustawien_2 = 3 And Przycisk_3 = 0 Then
   Waitms Opoznienie_przycisk
   Polecenie = 0
   Incr Kod_4

      If Kod_4 = 10 Then Kod_4 = 0

   Do
   Loop Until Przycisk_3 = 1
   End If

   If Tryb_ustawien_1 = 5 And Przycisk_2 = 0 Then
   Waitms Opoznienie_przycisk
   Tryb_ustawien_1 = 0
   Tryb_ustawien_2 = 4
   Do
   Loop Until Przycisk_2 = 1
   End If

End If

If Tryb_ustawien_1 = 0 And Przycisk_2 = 0 Then
Waitms Opoznienie_przycisk
Polecenie = 0
Tryb_ustawien_2 = 0
Kod_1_pomocnicza = 0
Kod_2_pomocnicza = 0
Kod_3_pomocnicza = 0
Kod_4_pomocnicza = 0
Tryb_pracy = 0

   If Kod_1 <> 0 Or Kod_2 <> 0 Or Kod_3 <> 0 Or Kod_4 <> 0 Then Kod_dostepu_stan = 1 Else Kod_dostepu_stan = 0

Do
Loop Until Przycisk_2 = 1
End If

Return

Komunikaty_glosowe:

Komunikaty_reset = 0
Waitms 200
Komunikaty_reset = 1
Waitms 200

For Komunikaty_pomocnicza_1 = 0 To Komunikaty_pomocnicza_2
Komunikaty_nastepny_komunikat = 0
Waitms 200
Komunikaty_nastepny_komunikat = 1
Waitms 400
Next Komunikaty_pomocnicza_1

Komunikaty_odtworz = 0
Waitms 200
Komunikaty_odtworz = 1

Return

Otwarte_oczy:

Locate 1 , 1
Lcd Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; "        " ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5)
Locate 2 , 1
Lcd Chr(5) ; " " ; Chr(6) ; Chr(6) ; " " ; Chr(5) ; "        " ; Chr(5) ; " " ; Chr(6) ; Chr(6) ; " " ; Chr(5)
Locate 3 , 1
Lcd Chr(5) ; " " ; Chr(7) ; Chr(7) ; " " ; Chr(5) ; "        " ; Chr(5) ; " " ; Chr(7) ; Chr(7) ; " " ; Chr(5)
Locate 4 , 1
Lcd Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; "        " ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5)

Return

Zamkniete_oczy:

Locate 1 , 1
Lcd "                    "
Locate 2 , 1
Lcd Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; "        " ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5)
Locate 3 , 1
Lcd Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; "        " ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5) ; Chr(5)
Locate 4 , 1
Lcd "                    "

Return

Budzik:

If Budzik_stan = 1 And Budzik_pomocnicza_1 = 0 And Budzik_pomocnicza_2 = 0 And Budzik_godziny = _hour And Budzik_minuty = _min Then
Budzik_pomocnicza_1 = 1
Led_b = 1
Pwm1b = 255
Gosub Otwarte_oczy
Komunikaty_pomocnicza_2 = 4
Gosub Komunikaty_glosowe
Tryb_pracy = 0
End If

If Budzik_minuty <> _min Then
Budzik_pomocnicza_1 = 0
Budzik_pomocnicza_2 = 0
Led_b = 0
End If

Return

Kod_dostepu:

If Przycisk_1 = 0 Then
Waitms Opoznienie_przycisk
Incr Tryb_ustawien_2
Do
Loop Until Przycisk_1 = 1
End If

If Tryb_ustawien_2 = 5 Then Tryb_ustawien_2 = 0

Select Case Tryb_ustawien_2
Case 0:
Polecenie = 121
Case 1:
Polecenie = 122
Case 2:
Polecenie = 123
Case 3:
Polecenie = 124
Case 4:
Polecenie = 125
End Select

If Tryb_ustawien_2 = 0 And Przycisk_3 = 0 Then
Waitms Opoznienie_przycisk
Polecenie = 0
Incr Kod_1_pomocnicza

   If Kod_1_pomocnicza = 10 Then Kod_1_pomocnicza = 0

Do
Loop Until Przycisk_3 = 1
End If

If Tryb_ustawien_2 = 1 And Przycisk_3 = 0 Then
Waitms Opoznienie_przycisk
Polecenie = 0
Incr Kod_2_pomocnicza

   If Kod_2_pomocnicza = 10 Then Kod_2_pomocnicza = 0

Do
Loop Until Przycisk_3 = 1
End If

If Tryb_ustawien_2 = 2 And Przycisk_3 = 0 Then
Waitms Opoznienie_przycisk
Polecenie = 0
Incr Kod_3_pomocnicza

   If Kod_3_pomocnicza = 10 Then Kod_3_pomocnicza = 0

Do
Loop Until Przycisk_3 = 1
End If

If Tryb_ustawien_2 = 3 And Przycisk_3 = 0 Then
Waitms Opoznienie_przycisk
Polecenie = 0
Incr Kod_4_pomocnicza

   If Kod_4_pomocnicza = 10 Then Kod_4_pomocnicza = 0

Do
Loop Until Przycisk_3 = 1
End If

If Tryb_ustawien_2 = 4 And Przycisk_3 = 0 Then
Waitms Opoznienie_przycisk

   If Kod_1 = Kod_1_pomocnicza and Kod_2 = Kod_2_pomocnicza and Kod_3 = Kod_3_pomocnicza and Kod_4 = Kod_4_pomocnicza Then
   Tryb_ustawien_2 = 0
   Kod_1_pomocnicza = 0
   Kod_2_pomocnicza = 0
   Kod_3_pomocnicza = 0
   Kod_4_pomocnicza = 0
   Licznik_3 = 0
   Licznik_4 = 0
   Led_r = 0
   Pwm1a = 0
   Kod_dostepu_stan = 0
   Tryb_dozorcy_1 = 0
   Cls
   Locate 1 , 1
   Lcd "KOD PRAWID" ; Chr(1) ; "OWY"
   Wait 3

      If Tryb_pracy = 2 Then
      Gosub Otwarte_oczy
      Wait 5
      Tryb_pracy = 0
      Kod_dostepu_stan = 1
      End If

   Else
   Tryb_ustawien_2 = 0
   Kod_1_pomocnicza = 0
   Kod_2_pomocnicza = 0
   Kod_3_pomocnicza = 0
   Kod_4_pomocnicza = 0
   Cls
   Locate 1 , 1
   Lcd "KOD NIEPRAWID" ; Chr(1) ; "OWY"
   Wait 3
   End If

Do
Loop Until Przycisk_3 = 1

End If

Return