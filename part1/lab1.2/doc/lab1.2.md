# Лабораторная работа №1.2 Вывод буквы на семисегментный индикатор

**Упражнение 1: Дополните код.**

Отобразите на индикаторе первые буквы своих имени и фамилии.

    assign abcdefgh = ...
    assign digit    = ...

**Упражнение 2: Дополните код.**

Отобразите на индикаторе 4 разные буквы на 4 разных индикатора, например F P G A:

    seven_seg_encoding_e letter;

    always_comb
      case (4' (key))
      4'b1000: letter = F;
      4'b0100: letter = P;
      4'b0010: letter = G;
      4'b0001: letter = A;
      default: letter = space;
      endcase

    assign abcdefgh = letter;
    assign digit    = w_digit' (key);

