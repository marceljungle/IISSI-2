<?php
require_once("gestionBD.php");
require_once("gestionarEvento.php");
require_once("paginacion_consulta.php");
if (!isset($_SESSION['login'])) {
	Header("Location: login.php");
} else {
	if (isset($_SESSION["EVENTO"])) {
		$evento = $_SESSION["EVENTO"];
		unset($_SESSION["EVENTO"]);
	}





	//                                                      	 PAGINACION                                                           //
	if (isset($_SESSION["paginacion"]))
		$paginacion = $_SESSION["paginacion"];
	$pagina_seleccionada = isset($_GET["PAG_NUM"]) ? (int)$_GET["PAG_NUM"] : (isset($paginacion) ? (int)$paginacion["PAG_NUM"] : 1);
	$pag_tam = isset($_GET["PAG_TAM"]) ? (int)$_GET["PAG_TAM"] : (isset($paginacion) ? (int)$paginacion["PAG_TAM"] : 5);
	if ($pagina_seleccionada < 1) 		$pagina_seleccionada = 1;
	if ($pag_tam < 1) 		$pag_tam = 5;
	unset($_SESSION["paginacion"]);
	$conexion = crearConexionBD();
	$query = 'SELECT * from EVENTO';
	$total_registros = total_consulta($conexion, $query);
	$total_paginas = (int)($total_registros / $pag_tam);
	if ($total_registros % $pag_tam > 0)		$total_paginas++;
	if ($pagina_seleccionada > $total_paginas)		$pagina_seleccionada = $total_paginas;
	$paginacion["PAG_NUM"] = $pagina_seleccionada;
	$paginacion["PAG_TAM"] = $pag_tam;
	$_SESSION["paginacion"] = $paginacion;
	$filas = consulta_paginada($conexion, $query, $pagina_seleccionada, $pag_tam);
	cerrarConexionBD($conexion);
}
$conexion = crearConexionBD();
$filas = consulta_paginada($conexion, $query, $pagina_seleccionada, $pag_tam);
cerrarConexionBD($conexion);
?>

<body>
	<nav>
		<form method="get" action="pagina.php" class="formpaginacion">
			<input id="PAG_NUM" name="PAG_NUM" type="hidden" value="<?php echo $pagina_seleccionada ?>" />
			<a class="mostrando">Mostrando</a>
			<input id="PAG_TAM" name="PAG_TAM" type="number" min="1" max="<?php echo $total_registros; ?>" value="<?php echo $pag_tam ?>" autofocus="autofocus" />
			entradas de <?php echo $total_registros ?>
			<input id="pagin" name="pagin" type="submit" value="Cambiar" class="subpaginacion">
		</form>
	</nav>
	<!--                                                      	 PAGINACION                                                           -->










	<!--                                                      	MODAL_FORM                                                            -->
	<!-- Trigger/Open The Modal -->
	<button id="myBtn" class="mybtn">Añadir Evento </button>

	<!-- The Modal -->
	
	<div id="myModal" class="modal">

		<!-- Modal content -->
		<div class="modal-content">
			<div class="modal-header">
				<span class="close">&times;</span> <!-- he utilizado bootstrap solo para la X -->
				<h2>Añadir Evento</h2>
			</div>
			<div class="modal-body">
				<form method="POST" action="produccion/controlador_evento.php">
					<label>Lugar: </label>
					<div><textarea required type="text" id="place" name="place" rows="3" cols="40"></textarea></div>
					<label>Fecha de Inicio: </label> <input required type="date" id="finicio" name="finicio" class="form-modal">
					<label>Fecha de Fin: </label> <input required type="date" id="ffin" name="ffin" class="form-modal">
					<label>Precio Total: </label> <input type="text" id="totalprice" name="totalprice" class="form-modal">
					<label>Descripcion: </label>
					<div><textarea id="description" name="description" rows="10" cols="70"></textarea></div>
					<button id="agregar" name="agregar" type="submit" value="Añadir" class="btn">Añadir</button>
					<?php if (isset($_SESSION["errormodal"])) { ?>
						<label>HA OCURRIDO UN ERROR</label>
					<?php } ?>


				</form>
			</div>
		</div>
	</div>
	<script src="js/modal.js"></script>
	<script>
		window.onload = function(event){
 		 if($_SESSION["errormodal"]=="TRUE") {
    		modal.style.display = "block";
  }
}
</script>
	<!--                                                      	MODAL_FORM                                                            -->














	<!--                                                      	TRATAMIENTO DE EXCEPCIONES                                                            -->
	<?php if (isset($_SESSION["borrado"])) {
		echo "No se puede borrar";
	}
	if (isset($_SESSION["editando"])) {
		echo "No se puede modificar, tenga cuidado con el formato que se requiere";
	}
	?>
	<!--                                                      	TRATAMIENTO DE EXCEPCIONES                                                            -->















	<!--                                                       CONSULTA_EVENTO                                                            -->
	<div class="seccionEntradas">
		<table id="tabla1" style="width:100%">
			<tr>
				<th>Evento</th>
				<th>Precio</th>
				<th>Fecha de Inicio</th>
				<th>Fecha Fin</th>
				<th>Estado</th>
				<th>Descripcion del cliente</th>
				<th>Lugar</th>
				<th>Editar</th>
				<th>Borrar</th>
			</tr>
			<?php
			foreach ($filas as $fila) {
				?>
				<form method="POST" action="produccion/controlador_evento.php">
					<!-- Controles de los campos que quedan ocultos:
								OID_LIBRO, OID_AUTOR, OID_AUTORIA, NOMBRE, APELLIDOS -->
					<input id="EID" name="EID" type="hidden" value="<?php echo $fila["EID"]; ?>" />
					<input id="PRECIOTOTAL" name="PRECIOTOTAL" type="hidden" value="<?php echo $fila["PRECIOTOTAL"]; ?>" />
					<input id="LUGAR" name="LUGAR" type="hidden" value="<?php echo $fila["LUGAR"]; ?>" />
					<input id="FECHAINICIO" name="FECHAINICIO" type="hidden" value="<?php echo $fila["FECHAINICIO"]; ?>" />
					<input id="FECHAFIN" name="FECHAFIN" type="hidden" value="<?php echo $fila["FECHAFIN"]; ?>" />
					<input id="DESCRIPCIONCLIENTE" name="DESCRIPCIONCLIENTE" type="hidden" value="<?php echo $fila["DESCRIPCIONCLIENTE"]; ?>" />
					<input id="ESTADOEVENTO" name="ESTADOEVENTO" type="hidden" value="<?php echo $fila["ESTADOEVENTO"]; ?>" />

					<?php
					if (isset($evento) and ($fila["EID"] == $evento["EID"])) { ?>
						<!-- Editando título -->
						<tr>
							<td><?php echo $fila['EID']; ?></td>
							<td><input id="PRECIOTOTAL" name="PRECIOTOTAL" type="text" value="<?php echo $fila['PRECIOTOTAL']; ?>" /></td>
							<td><input id="FECHAINICIO" name="FECHAINICIO" type="date" required value="<?php echo date_format(date_create_from_format('d/m/y', $fila['FECHAINICIO']), 'Y-m-d'); ?>" /></td>
							<td><input id="FECHAFIN" name="FECHAFIN" type="date" required value="<?php if ($fila["FECHAFIN"] != 0) echo date_format(date_create_from_format('d/m/y', $fila['FECHAFIN']), 'Y-m-d'); ?>" /></td>
							<td><select id="ESTADOEVENTO" required name="ESTADOEVENTO">
									<?php if ($fila['ESTADOEVENTO'] != "porRealizar") echo "<option>porRealizar</option>" ?>
									<?php if ($fila['ESTADOEVENTO'] != "enPreparacion") echo "<option>enPreparacion</option>" ?>
									<?php if ($fila['ESTADOEVENTO'] != "Realizado") echo "<option>Realizado</option>" ?>
									<option selected="selected"><?php echo $fila['ESTADOEVENTO']; ?></option>
								</select></td>
							<td><input id="DESCRIPCIONCLIENTE" name="DESCRIPCIONCLIENTE" type="text" value="<?php echo $fila['DESCRIPCIONCLIENTE']; ?>" /></td>
							<td><input id="LUGAR" name="LUGAR" required type="text" value="<?php echo $fila['LUGAR']; ?>" /> </td>
						<?php } else { ?>
							<!-- mostrando título -->
						<tr>
							<td><?php echo $fila['EID']; ?></td>
							<td><?php echo $fila['PRECIOTOTAL']; ?></td>
							<td><?php if ($fila["FECHAINICIO"] != 0) echo date_format(date_create_from_format('d/m/y', $fila['FECHAINICIO']), 'Y-m-d'); ?></td>
							<td><?php if ($fila["FECHAFIN"] != 0) echo date_format(date_create_from_format('d/m/y', $fila['FECHAFIN']), 'Y-m-d'); ?></td>
							<td> <?php echo $fila['ESTADOEVENTO']; ?></td>
							<td>
								<p><?php echo $fila['DESCRIPCIONCLIENTE']; ?></p>
							</td>
							<td><?php echo $fila['LUGAR'] ?></td>

						<?php } ?>

						<?php if (isset($evento) and $fila["EID"] == $evento["EID"]) { ?>
							<td>
								<button id="grabar" name="grabar" type="submit" class="editar_fila">
									<img src="images/bag_menuito.bmp" class="editar_fila" alt="Guardar Cambios">
								</button>
							</td>
						<?php } else { ?>
							<td>
								<button id="editar" name="editar" type="submit" class="editar_fila">
									<img src="images/pencil_menuito.bmp" class="editar_fila" alt="Editar Libro">
								</button>
							</td>
						<?php } ?>
						<td>
							<button id="borrar" name="borrar" type="submit" class="editar_fila">
								<img src="images/remove_menuito.bmp" class="editar_fila" alt="Borrar Libro">
							</button>
						</td>

				</form>

				</article>
				<div>

				<?php } ?>
				<div id="enlaces" class="enlaces">

					<?php

					for ($pagina = 1; $pagina <= $total_paginas; $pagina++)

						if ($pagina == $pagina_seleccionada) { 	?>

						<span class="current"><?php echo $pagina; ?></span>

					<?php } else { ?>

						<a href="pagina.php?PAG_NUM=<?php echo $pagina; ?>&PAG_TAM=<?php echo $pag_tam; ?>"><?php echo $pagina; ?></a>

					<?php } ?>

				</div>

				<?php unset($_SESSION["excepcion"]);
				unset($_SESSION["borrado"]);
				unset($_SESSION["editando"]);
				
				
				?>
				<!--para reestablecer el error que salia antes, para evitar que salga siempre -->
				<!--                                                       CONSULTA_EVENTO                                                            -->

</body>