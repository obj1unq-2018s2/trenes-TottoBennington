class VagonDePasajeros{
	var property largo // dado que no tenemos una medida especifica
	var property anchoUtil //dado que tampoco tenemos una medida especifica
	
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
	var property locomotora
	var property vagones // sera obviamente usado como una lista
	
	method cantidadDeVagonesLivianos() = vagones.filter{
		vagon => vagon.pesoMaximo() < 2500
	}.size()
	
	method velocidadMaximaFormacion() = locomotora.min{
		loco => loco.velocidadMaxima()
	}.velocidadMaxima() // ya que queremos la velocidad, no la locomotora.
	
	method esFormacionEficiente() = locomotora.all{
		loco => loco.pesoMaximoArrastrable() >= loco.peso() * 5
	}           // si lo arrastrable es >= a 5 veces su peso base
	
	method arrastreMaximoDeTodasLasLocomotoras() = locomotora.sum{
		loco => loco.pesoMaximoArrastrable()
	}
	
	method pesoMaximosDeTodosLosVagones() = vagones.sum{
		vagon => vagon.pesoMaximo()
	}
	
	method puedeMoverse() = self.arrastreMaximoDeTodasLasLocomotoras() >= self.pesoMaximosDeTodosLosVagones()
	
	method kgDeEmpujeParaMoverse() = if(self.puedeMoverse()) 0 else self.pesoMaximosDeTodosLosVagones() - self.arrastreMaximoDeTodasLasLocomotoras()
	
	method vagonMasPesado() = vagones.max{vagon => vagon.pesoMaximo()}
}

class Deposito{
	var property formaciones
	
	method vagonesMasPesadosDeCadaFormacion() = formaciones.map{
		form => form.vagonMasPesado()
	}
}