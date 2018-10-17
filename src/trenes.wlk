class VagonDePasajeros{
	var largo // dado que no tenemos una medida especifica
	var anchoUtil //dado que tampoco tenemos una medida especifica
	
	method cantidadDePasajeroTransportables(){
		return if(anchoUtil <= 2.5) largo * 8 else largo * 10
	}
	
	method pesoMaximo() = self.cantidadDePasajeroTransportables() * 80
}

class VagonDeCarga{
	var property cargaMaxima
	
	method pesoMaximo() = cargaMaxima + 160
}

class Locomotora{
	var property peso
	var property pesoMaximoArrastrable
	var property velocidadMaxima
	
	method cargaMaxima() = pesoMaximoArrastrable - peso
}

class Formacion{
	var locomotoras = []
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
		var locomotoraBuscada
		if(not formacion.puedeMoverse()){
			locomotoraBuscada = locomotorasSinUsar.filter{
				l => l.pesoMaximoArrastrable()>= formacion.kgDeEmpujeParaMoverse()
			}.first()
			
			if(not locomotoraBuscada.isEmpty()) formacion.add(locomotoraBuscada)
			// agregamos la primera que encuentra & que cumpla con las condiciones
			// dado que no seria nada raro que haya mas de una
		}
	}
}
/*
class FormacionLargaDistancia inherits Formacion{
	
}*/