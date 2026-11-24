class Celda:
    def __init__(self, fila, columna):
        self.fila = fila
        self.columna = columna
        self.tiene_mina = False
        self.tiene_bandera = False
        self.esta_revelada = False
        self.minas_adyacentes = 0

    def revelar(self):
        if self.esta_revelada or self.tiene_bandera:
            return False
        self.esta_revelada = True
        return True

    def alternar_bandera(self):
        if not self.esta_revelada:
            self.tiene_bandera = not self.tiene_bandera


class Tablero:
    def __init__(self, filas, columnas, minas):
        self.filas = filas
        self.columnas = columnas
        self._matriz = [
            [Celda(fila, columna) for columna in range(columnas)]
            for fila in range(filas)
        ]

        for fila, columna in minas:
            self.celda_en(fila, columna).tiene_mina = True

        for fila in self._matriz:
            for celda in fila:
                celda.minas_adyacentes = sum(
                    vecina.tiene_mina for vecina in self.calcular_vecinos(celda)
                )

    def esta_dentro(self, fila, columna):
        return (type(fila) is int and type(columna) is int
                and 0 <= fila < self.filas and 0 <= columna < self.columnas)

    def celda_en(self, fila, columna):
        if not self.esta_dentro(fila, columna):
            raise ValueError("Coordenadas fuera del tablero")
        return self._matriz[fila][columna]

    def calcular_vecinos(self, celda):
        vecinos = []
        for fila in range(celda.fila - 1, celda.fila + 2):
            for columna in range(celda.columna - 1, celda.columna + 2):
                if self.esta_dentro(fila, columna):
                    vecina = self.celda_en(fila, columna)
                    if vecina is not celda:
                        vecinos.append(vecina)
        return vecinos

    def revelar_celda(self, fila, columna):
        pendientes = [self.celda_en(fila, columna)]
        while pendientes:
            celda = pendientes.pop()
            if not celda.revelar():
                continue
            if not celda.tiene_mina and celda.minas_adyacentes == 0:
                pendientes.extend(self.calcular_vecinos(celda))

    def objetivo_completo(self):
        return all(
            celda.esta_revelada
            for fila in self._matriz
            for celda in fila
            if not celda.tiene_mina
        )


class Partida:
    def __init__(self, tablero):
        self.tablero = tablero
        self.estado = "en curso"

    def revelar_celda(self, fila, columna):
        if self.estado != "en curso" or not self.tablero.esta_dentro(fila, columna):
            return

        celda = self.tablero.celda_en(fila, columna)
        if celda.esta_revelada or celda.tiene_bandera:
            return

        self.tablero.revelar_celda(fila, columna)
        if celda.tiene_mina:
            self.estado = "derrota"
        elif self.tablero.objetivo_completo():
            self.estado = "victoria"

    def alternar_bandera(self, fila, columna):
        if self.estado != "en curso" or not self.tablero.esta_dentro(fila, columna):
            return
        self.tablero.celda_en(fila, columna).alternar_bandera()
