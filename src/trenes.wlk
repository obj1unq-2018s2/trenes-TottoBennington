class VagonDePasajeros{
	
	var largo // dado que no tenemos una medida especifica
	var anchoUtil //dado que tampoco tenemos una medida especifica
	
	method cantidadDePasajeroTransportables(){
		return if(anchoUtil <= 2.5) largo * 8 else largo * 10
	}
	
	method pesoMaximo() = self.cantidadDePasajeroTransportables() * 80
	
	method cantidadDeBanios() = self.roundDown(self.cantidadDePasajeroTransportables() / 50)
	
	method roundDown(n){
		// La idea es que dado un numero con coma redondearlo hacia abajo.
		var res = 0
		res = n - (n.roundUp() - 1)
		return n - res
	}
}

class VagonDeCarga{
	
	var property cargaMaxima
	
	method pesoMaximo() = cargaMaxima + 160
	
	method cantidadDeBanios() = 0
}

class Locomotora{
	
	var property peso
	var property pesoMaximoArrastrable
	var property velocidadMaxima
	
	method cargaMaxima() = pesoMaximoArrastrable - peso
}

class Formacion{
	
	var property locomotoras = []
	var vagones = []
	
	method cantidadDeVagonesLivianos() = vagones.filter{
		vagon => vagon.pesoMaximo() < 2500
	}.size()
	
	method velocidadMaximaFormacion() = locomotoras.min{
		loco => loco.velocidadMaxima()
	}.velocidadMaxima() // ya que queremos la velocidad, no la locomotora.
	
	method esFormacionEficiente() = locomotoras.all{
		loco => loco.pesoMaximoArrastrable() >= loco.peso() * 5
	}           // si lo arrastrable es >= a 5 veces su peso base
	
	method arrastreMaximoDeTodasLasLocomotoras() = locomotoras.sum{
		loco => loco.pesoMaximoArrastrable()
	}
	method pesoDeLocomotoras() = locomotoras.sum{
		loco => loco.peso()
	}
	method pesoMaximosDeTodosLosVagones() = vagones.sum{
		vagon => vagon.pesoMaximo()
	}
	
	method puedeMoverse() = self.arrastreMaximoDeTodasLasLocomotoras() >= self.pesoMaximosDeTodosLosVagones()
	
	method kgDeEmpujeParaMoverse() = if(self.puedeMoverse()) 0 else self.pesoMaximosDeTodosLosVagones() - self.arrastreMaximoDeTodasLasLocomotoras()
	
	method vagonMasPesado() = vagones.max{vagon => vagon.pesoMaximo()}
	
	method esCompleja() = vagones.size() + locomotoras.size() > 20 or  self.pesoMaximosDeTodosLosVagones() + self.pesoDeLocomotoras() > 10000
	
	method cantidadDeBaniosDeLaFormacion() = vagones.sum{
		 v => v.cantidadDeBanios()
	}
	
	method cantidadDePasajerosDeFormacion() = vagones.sum{
		v => v.cantidadDePasajeroTransportables()
	}
	method estaBienArmada() = self.puedeMoverse()
}

class Deposito{
	
	var property formaciones
	var locomotorasSinUsar = []
	
	method agregarALocomotorasSinUso(locomotora){locomotorasSinUsar.add(locomotora)}
	
	method vagonesMasPesadosDeCadaFormacion() = formaciones.map{
		form => form.vagonMasPesado()
	}
	
	method esNecesarioConductorExp() = formaciones.any{f => f.esCompleja()}
	
	method agregarLocomotoraAFormacion(formacion){
		
		var locomotoraBuscada = null
		
		if(not formacion.puedeMoverse()){
			locomotoraBuscada = locomotorasSinUsar.filter{
				l => l.pesoMaximoArrastrable()>= formacion.kgDeEmpujeParaMoverse()
			}.first()
			
			if(locomotoraBuscada != null) formacion.locomotoras().add(locomotoraBuscada)
		}
	}
}

class FormacionesLargaDistancia inherits Formacion{
	
	var nroCiudadesQueUne //asignar en tests
	
	method roundDown(n){
		// lo copie desde el original en vagones porque esta clase ya hereda de Formacion
		// y no se si se puede heredar desde 2 clases.
		var res = 0
		res = n - (n.roundUp() - 1)
		return n - res
	}
	
	method hayBaniosSuficientes(){
		return (self.roundDown(self.cantidadDePasajerosDeFormacion() / 50)) == self.cantidadDeBaniosDeLaFormacion()
	}
	
	override method estaBienArmada() = super() && self.hayBaniosSuficientes()
	
	method velocidadMaxima() = if(nroCiudadesQueUne == 2) 200 else 150
}

class FormacionesCortaDistancia inherits Formacion{
	
	override method estaBienArmada() = super() && not self.esCompleja()
	
	method velocidadMaxima() = 60
}

class FormacionesDeAltaVelocidad inherits FormacionesLargaDistancia{
	
	method sonTodosSusVagonesLivianos() = self.cantidadDeVagonesLivianos() == vagones.size()
	
	method limiteMaxDeVelocidad() = 400
	
	override method estaBienArmada() = super() && self.sonTodosSusVagonesLivianos() && self.velocidadMaxima() >= 250
}