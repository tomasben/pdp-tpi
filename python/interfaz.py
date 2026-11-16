import random
import tkinter as tk

from buscaminas import Partida, Tablero


class Interfaz:
    def __init__(self, ventana):
        self.ventana = ventana
        self.ventana.title("Buscaminas")
        self.ventana.resizable(False, False)

        self.estado = tk.Label(ventana)
        self.estado.pack()

        tablero = tk.Frame(ventana)
        tablero.pack(padx=10, pady=10)
        self.botones = {}
        for fila in range(8):
            for columna in range(8):
                boton = tk.Button(
                    tablero, width=3, height=1, font=("Arial", 14),
                    command=lambda f=fila, c=columna: self.abrir(f, c),
                )
                boton.grid(row=fila, column=columna)
                boton.bind("<Button-3>", lambda evento, f=fila, c=columna: self.marcar(f, c))
                self.botones[fila, columna] = boton

        tk.Button(ventana, text="Nueva partida", command=self.nueva_partida).pack(pady=10)
        self.nueva_partida()

    def nueva_partida(self):
        posiciones = [(fila, columna) for fila in range(8) for columna in range(8)]
        minas = random.sample(posiciones, 10)
        self.partida = Partida(Tablero(8, 8, minas))
        self.actualizar()

    def abrir(self, fila, columna):
        self.partida.revelar_celda(fila, columna)
        self.actualizar()

    def marcar(self, fila, columna):
        self.partida.alternar_bandera(fila, columna)
        self.actualizar()

    def actualizar(self):
        terminada = self.partida.estado != "en curso"
        for (fila, columna), boton in self.botones.items():
            celda = self.partida.tablero.celda_en(fila, columna)
            texto = ""
            fondo = "#dddddd"
            if terminada and celda.tiene_mina:
                texto = "*"
                fondo = "#f09090"
            elif celda.esta_revelada:
                texto = str(celda.minas_adyacentes) if celda.minas_adyacentes else ""
                fondo = "#ffffff"
            elif celda.tiene_bandera:
                texto = "B"

            boton.config(
                text=texto,
                bg=fondo,
                relief=tk.SUNKEN if celda.esta_revelada else tk.RAISED,
                state=tk.DISABLED if terminada or celda.esta_revelada else tk.NORMAL,
                disabledforeground="black",
            )

        mensajes = {"en curso": "Buscá las 10 minas", "victoria": "¡Ganaste!", "derrota": "Pisaste una mina"}
        self.estado.config(text=mensajes[self.partida.estado])


if __name__ == "__main__":
    ventana = tk.Tk()
    Interfaz(ventana)
    ventana.mainloop()
