extension StringNormalize on String {
  String normalize() {
    const vietnamese = 'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễ'
        'ìíịỉĩòóọỏõôồốộổỗơờớợởỡ'
        'ùúụủũưừứựửữỳýỵỷỹđ'
        'ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ'
        'ÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨ'
        'ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ'
        'ÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ';

    const without = 'aaaaaaaaaaaaaaaaaeeeeeeeeeee'
        'iiiiiooooooooooooooooouuuuuuuuuuuyyyyyd'
        'AAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYD';

    var result = this;
    for (int i = 0; i < vietnamese.length; i++) {
      result = result.replaceAll(vietnamese[i], without[i]);
    }

    return result.toLowerCase();
  }

  bool fuzzyContains(String query) {
    final target = normalize();
    final search = query.normalize();

    if (target.contains(search)) return true;

    final parts = search.split(RegExp(r'\s+'));
    return parts.every((p) => target.contains(p));
  }
}
