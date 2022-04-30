import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
	
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method    iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		bomba.iniciar()
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
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		gameOver.play()
		dino.morir()
		
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	method play(){
		game.sound("sounds/game-over.mp3").play()
	}
	

}

object reloj {
	
	var tiempo = 0
	
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
	 
	const posicionInicial = game.at(game.width()-1,suelo.position().y())
	var position = posicionInicial

	method image() = "img/cactus.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad*2,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
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

object bomba{
	const posicionInicial = game.at(game.width()-0.5,suelo.position().y())
	var position = posicionInicial
	
	method image() = "img/bomba.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverBomba",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		game.addVisual(explosion)
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverBomba")
	}
}

object explosion{
	method position() = game.at(6,4)
	method image() = "img/explosion3.png"	
}


object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "img/suelo.png"
}


object dino {
	var vivo = true
	var position = game.at(3.5,suelo.position().y())
	var image = "img/dino.png"
	
	method image() = image

	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch!")
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
			image = "img/dino2.png"
			return image }
		else {
			image = "img/dino.png"
			return image}
	}
}



