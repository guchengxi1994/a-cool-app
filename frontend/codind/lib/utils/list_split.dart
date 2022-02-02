/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-02 22:34:08
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-02 22:35:13
 */
List<List<T>> splitList<T>(List<T> list, int len) {
  if (len <= 1) {
    return [list];
  }

  List<List<T>> result = [];

  int index = 1;

  while (true) {
    if (index * len < list.length) {
      List<T> temp = list.skip((index - 1) * len).take(len).toList();

      result.add(temp);

      index++;

      continue;
    }

    List<T> temp = list.skip((index - 1) * len).toList();

    result.add(temp);

    break;
  }

  return result;
}
