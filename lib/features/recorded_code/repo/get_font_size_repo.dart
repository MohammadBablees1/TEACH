class GetFontSizeRepo {

 double getFontSize(String text) {
    if (text.length > 20) return 6;
    if (text.length > 10) return 8;
    return 10;
  }

}