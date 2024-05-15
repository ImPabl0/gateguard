enum Role {
  morador,
  sindico,
  porteiro;

  factory Role.fromName(String name) {
    switch (name) {
      case 'morador':
        return Role.morador;
      case 'sindico':
        return Role.sindico;
      case 'porteiro':
        return Role.porteiro;
      default:
        return Role.morador;
    }
  }
}
