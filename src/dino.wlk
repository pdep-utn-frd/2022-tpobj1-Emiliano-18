import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(bomba)
		game.addVisual(nube1)
	 	game.addVisual(nube2)
	 	game.addVisual(nube3)
		game.addVisual(dino)
		game.addVisual(reloj)
	
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		bomba.iniciar()
		nube1.iniciar()
		nube2.iniciar()
		nube3.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	 
	  
	 
	
	method terminar(){
		game.schedule(1000,{game.addVisual(gameOver)})
		cactus.detener()
		bomba.detener()
		reloj.detener()
		nube1.detener()
		nube2.detener()
		nube3.detener()
		dino.morir()
		game.schedule(250,{gameOver.play()})
	}
	
}

object gameOver {
	method position() = game.at(2.3,3.5)
	method image() = "img/game-over.png"
	method play(){
		game.sound("sounds/game-over.mp3").play()
	}
	

}

object reloj {
	
	var tiempo = 0
	var property punt = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
	
}

object cactus {
	 
	const posicionInicial = game.at(game.width()+1,suelo.position().y())
	var position = posicionInicial

	method image() = "img/cactus.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad*0.8,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(0.5)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}

object bomba {
	 
	const posicionInicial = game.at(game.width()-3,suelo.position().y())
	var position = posicionInicial

	method image() = "img/bomba.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad*0.8,"moverBomba",{self.mover()})
	}
	
	method mover(){
		position = position.left(0.5)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		game.addVisual(explosion)
		explosion.play()
		juego.terminar()
		game.schedule(1000,{game.removeVisual(explosion)} )
		
	}
    method detener(){
		game.removeTickEvent("moverBomba")
		
	}
}


object explosion{
	method position() = game.at(3.5,2.5)
	method image() = "img/explosion.png"
	method play(){
		game.sound("sounds/explosion.mp3").play()
	}	
}


object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "img/suelo.png"
}


object nube1 {
	 
	const posicionInicial = game.at(game.width(),6)
	var position = posicionInicial

	method image() = "img/Nube1.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverNube1",{self.mover()})
	}
	
	method mover(){
		position = position.left(0.5)
		if (position.x() == -3)
			position = posicionInicial
	}
	

    method detener(){
		game.removeTickEvent("moverNube1")
	}
}
 
object nube2 {
	const posicionInicial = game.at(game.width()-1,4)
	var position = posicionInicial
	method position() = position
	method image() = "img/Nube2.png"
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverNube2",{self.mover()})
	}
	
	method mover(){
		position = position.left(0.5)
		if (position.x() == -4)
			position = posicionInicial
	}
	
	method detener(){
		game.removeTickEvent("moverNube2")
	}
}

object nube3 {
	const posicionInicial = game.at(0,5)
	var position = posicionInicial
	method position() = position
	method image() = "img/Nube3.png"
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad*1.05,"moverNube3",{self.mover()})
	}
	
	method mover(){
		position = position.right(0.5)
		if (position.x() == +12)
			position = posicionInicial
	}
	
	method detener(){
		game.removeTickEvent("moverNube3")
	}
}


object dino {
	var vivo = true
	var position = game.at(2,suelo.position().y())
	var image = "img/dino.png"
	
	method image() = image

	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*2.5,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch, eso dolio!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
	
 	method actualizar(){
		if (image == "img/dino.png" && vivo){
			image = "img/dino2.1.png"
			return image }
		else {
			image = "img/dino.png"
			return image}
	}
}


