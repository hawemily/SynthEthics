
// Class for maintaining string operations that are not native to dart
class StringOperator {

  static String capitalise(String string) {
    // Assume given string is in all lowercase, saves on computation on lowering
    // the tail of the string
    try {
      return "${string[0].toUpperCase()}${string.substring(1)}";
    } catch (e) {
      return "";
    }
  }

  static String capitaliseClear(String string) {
    //  Does not assume the string is in lowercase
    try {
      return "${string[0].toUpperCase()}${string.substring(1).toLowerCase()}";
    } catch (e) {
      return "";
    }
  }
}