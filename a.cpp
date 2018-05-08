while (1) {
        j = 0;
        parse(buffer, &j, result);
        lcd.cls();
        ctTime = time(NULL) - 180000;
        lcd.printf("%s", ctime(&ctTime));
        printf("%s\n\r", ctime(&ctTime));
        wait(1);
        j = 23;
        parse(buffer, &j, city);
        j = 47;
        parse(buffer, &j, zipcode);
        lcd.cls();
        lcd.printf("%s, %s", country, city);
        printf("%s, %s\n\r", country, city);
        wait(2);
}


time_t ctTime;
char result [4] = {0};
char country[60] = {0};
char zipcode[10] = {0};
char buffer[256] = {0};
int j=0;
