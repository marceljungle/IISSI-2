<?php
  /*
     * #===========================================================#
     * #	Este fichero contiene las funciones de gestión     			 
     * #	de libros de la capa de acceso a datos 		
     * #==========================================================#
     */
function quitar_evento($conexion,$EID) { //hay q hacer procedimientos para esto
	try {
		$stmt=$conexion->prepare('CALL QUITAR_EVENTO(:EID)');
		$stmt->bindParam(':EID',$EID);
		$stmt->execute();
		return "";
	} catch(PDOException $e) {
		return $e->getMessage();
    }
}

function modificar_evento($conexion,$EID,$PRECIOTOTAL,$LUGAR,$FECHAINICIO,$FECHAFIN,$DESCRIPCIONCLIENTE,$ESTADOEVENTO) {
	try {
		$stmt=$conexion->prepare("CALL MODIFICAR_EVENTO(:EID,:PRECIOTOTAL,:LUGAR,TO_DATE(:FECHAINICIO,'YYYY-MM-DD'),TO_DATE(:FECHAFIN,'YYYY-MM-DD'),:DESCRIPCIONCLIENTE,:ESTADOEVENTO)");
		$stmt->bindParam(':EID',$EID);
		$stmt->bindParam(':PRECIOTOTAL',$PRECIOTOTAL);
		$stmt->bindParam(':LUGAR',$LUGAR);
		$stmt->bindParam(':FECHAINICIO',$FECHAINICIO);
		$stmt->bindParam(':FECHAFIN',$FECHAFIN);
		$stmt->bindParam(':DESCRIPCIONCLIENTE',$DESCRIPCIONCLIENTE);
		$stmt->bindParam(':ESTADOEVENTO',$ESTADOEVENTO);
		$stmt->execute();
		return "";
	} catch(PDOException $e) {
		return $e->getMessage();
    }
}
function crear_evento($conexion,$PRECIOTOTAL,$LUGAR,$FECHAINICIO,$FECHAFIN,$DESCRIPCIONCLIENTE) { //hay q hacer procedimientos para esto
	try {
		$stmt=$conexion->prepare("CALL crear_evento(:PRECIOTOTAL,:LUGAR,TO_DATE(:FECHAINICIO,'YYYY-MM-DD'),TO_DATE(:FECHAFIN,'YYYY-MM-DD'),:DESCRIPCIONCLIENTE)");
		$stmt->bindParam(':PRECIOTOTAL',$PRECIOTOTAL);
		$stmt->bindParam(':LUGAR',$LUGAR);
		$stmt->bindParam(':FECHAINICIO',$FECHAINICIO);
		$stmt->bindParam(':FECHAFIN',$FECHAFIN);
		$stmt->bindParam(':DESCRIPCIONCLIENTE',$DESCRIPCIONCLIENTE);
		$stmt->execute();
		return "";
	} catch(PDOException $e) {
		return $e->getMessage();
    }
}
?>